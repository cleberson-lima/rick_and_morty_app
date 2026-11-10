import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers from [handler]; `online = false` makes every request fail as if
/// there were no connection.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;
  bool online = true;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    if (!online) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, {int status = 200}) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late Directory cacheDir;
  late _Adapter adapter;
  late Dio dio;

  setUp(() async {
    cacheDir = await Directory.systemTemp.createTemp('offline_cache');
    adapter = _Adapter((options) => _json({'path': options.uri.toString()}));
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(OfflineCacheInterceptor(cacheDir, maxEntries: 3));
  });

  tearDown(() => cacheDir.delete(recursive: true));

  test('online, it answers from the network and saves the response', () async {
    final response = await dio.get<Map<String, Object?>>('/character/1');

    expect(response.data, {'path': 'https://api.test/character/1'});
    expect(response.extra[OfflineCacheInterceptor.fromCacheKey], isNull);
    expect(cacheDir.listSync(), hasLength(1));
  });

  test('offline, it answers with the saved copy of the same URL', () async {
    await dio.get<Object?>('/character/', queryParameters: {'name': 'rick'});
    adapter.online = false;

    final response = await dio.get<Map<String, Object?>>(
      '/character/',
      queryParameters: {'name': 'rick'},
    );

    expect(response.statusCode, 200);
    expect(response.data, {'path': 'https://api.test/character/?name=rick'});
    expect(response.extra[OfflineCacheInterceptor.fromCacheKey], isTrue);
  });

  test('offline without a saved copy, the error goes through', () async {
    adapter.online = false;

    await expectLater(
      dio.get<Object?>('/character/2'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );
  });

  test('another query is another entry', () async {
    await dio.get<Object?>('/character/', queryParameters: {'name': 'rick'});
    adapter.online = false;

    await expectLater(
      dio.get<Object?>('/character/', queryParameters: {'name': 'morty'}),
      throwsA(isA<DioException>()),
    );
  });

  test('API errors are not replaced by the cache', () async {
    await dio.get<Object?>('/character/9');
    adapter = _Adapter((_) => _json({'error': 'nothing here'}, status: 404));
    dio.httpClientAdapter = adapter;

    await expectLater(
      dio.get<Object?>('/character/9'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      ),
    );
  });

  test('a cancelled request is not answered from the cache', () async {
    await dio.get<Object?>('/character/1');
    final token = CancelToken()..cancel('newer search');

    await expectLater(
      dio.get<Object?>('/character/1', cancelToken: token),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.cancel,
        ),
      ),
    );
  });

  test('keeps at most maxEntries files, dropping the oldest', () async {
    for (var id = 1; id <= 5; id++) {
      await dio.get<Object?>('/character/$id');
      // Distinct modification times, so "oldest" is well defined.
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    adapter.online = false;

    expect(cacheDir.listSync(), hasLength(3));
    await expectLater(
      dio.get<Object?>('/character/1'),
      throwsA(isA<DioException>()),
      reason: 'evicted',
    );
    final newest = await dio.get<Map<String, Object?>>('/character/5');
    expect(newest.data, {'path': 'https://api.test/character/5'});
  });

  test('a corrupted entry behaves like no cache', () async {
    await dio.get<Object?>('/character/1');
    for (final file in cacheDir.listSync().whereType<File>()) {
      file.writeAsStringSync('not json');
    }
    adapter.online = false;

    await expectLater(
      dio.get<Object?>('/character/1'),
      throwsA(isA<DioException>()),
    );
  });

  test('createDio adds the cache only when given a directory', () {
    expect(
      createDio().interceptors.whereType<OfflineCacheInterceptor>(),
      isEmpty,
    );
    expect(
      createDio(
        cacheDirectory: cacheDir,
      ).interceptors.whereType<OfflineCacheInterceptor>(),
      hasLength(1),
    );
  });

  group('OfflineStatus', () {
    late OfflineStatus status;

    setUp(() {
      status = OfflineStatus();
      dio.interceptors
        ..clear()
        ..add(OfflineCacheInterceptor(cacheDir, status: status));
    });

    test('starts as not showing saved data', () {
      expect(status.isShowingSavedData, isFalse);
    });

    test(
      'turns on when the cache answers, off on the next network answer',
      () async {
        await dio.get<Object?>('/character/1');
        expect(status.value, isFalse);

        adapter.online = false;
        await dio.get<Object?>('/character/1');
        expect(status.value, isTrue);

        adapter.online = true;
        await dio.get<Object?>('/character/2');
        expect(status.value, isFalse);
      },
    );

    test('stays as it was when offline without a saved copy', () async {
      adapter.online = false;

      await expectLater(
        dio.get<Object?>('/character/3'),
        throwsA(isA<DioException>()),
      );
      expect(status.value, isFalse);
    });

    test('createDio passes the status to the cache', () {
      final cache = createDio(
        cacheDirectory: cacheDir,
        offlineStatus: status,
      ).interceptors.whereType<OfflineCacheInterceptor>().single;

      expect(cache.status, same(status));
    });
  });
}
