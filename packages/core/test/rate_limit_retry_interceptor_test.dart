import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers each request with the next status in [statuses] (the last one
/// repeats), so a test can script "429, 429, 200".
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.statuses, {this.headers = const {}});

  final List<int> statuses;
  final Map<String, List<String>> headers;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final status =
        statuses[calls < statuses.length ? calls : statuses.length - 1];
    calls++;
    return ResponseBody.fromString(
      jsonEncode(status == 200 ? {'ok': true} : {'error': 'nope'}),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late List<Duration> waits;

  Dio buildDio(_ScriptedAdapter adapter, {Future<void> Function()? onWait}) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(
      RateLimitRetryInterceptor(
        dio,
        wait: (delay) async {
          waits.add(delay);
          await onWait?.call();
        },
      ),
    );
    return dio;
  }

  setUp(() => waits = []);

  test('retries a 429 and returns the successful response', () async {
    final adapter = _ScriptedAdapter([429, 429, 200]);

    final response = await buildDio(adapter).get<Object?>('/character/');

    expect(response.statusCode, 200);
    expect(adapter.calls, 3);
    expect(waits, const [Duration(seconds: 1), Duration(seconds: 2)]);
  });

  test('honors Retry-After when the server sends it', () async {
    final adapter = _ScriptedAdapter(
      [429, 200],
      headers: {
        'retry-after': ['3'],
      },
    );

    await buildDio(adapter).get<Object?>('/character/');

    expect(waits, const [Duration(seconds: 3)]);
  });

  test('caps very long Retry-After values', () async {
    final adapter = _ScriptedAdapter(
      [429, 200],
      headers: {
        'retry-after': ['3600'],
      },
    );

    await buildDio(adapter).get<Object?>('/character/');

    expect(waits, const [Duration(seconds: 10)]);
  });

  test('gives up after 3 retries and maps to tooManyRequests', () async {
    final adapter = _ScriptedAdapter([429]);

    final error = await buildDio(adapter)
        .get<Object?>('/character/')
        .then<DioException?>(
          (_) => null,
          onError: (Object e) => e as DioException,
        );

    expect(adapter.calls, 4, reason: '1 request + 3 retries');
    expect(waits, const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ]);
    expect(error?.response?.statusCode, 429);
    expect(mapExceptionToFailure(error!), const Failure.tooManyRequests());
  });

  test('does not retry other errors', () async {
    final adapter = _ScriptedAdapter([500]);

    await expectLater(
      buildDio(adapter).get<Object?>('/character/'),
      throwsA(isA<DioException>()),
    );

    expect(adapter.calls, 1);
    expect(waits, isEmpty);
  });

  test('stops retrying when the request is cancelled while waiting', () async {
    final token = CancelToken();
    final adapter = _ScriptedAdapter([429, 200]);
    final dio = buildDio(
      adapter,
      onWait: () async => token.cancel('newer search'),
    );

    await expectLater(
      dio.get<Object?>('/character/', cancelToken: token),
      throwsA(isA<DioException>()),
    );

    expect(adapter.calls, 1, reason: 'no request after cancellation');
  });

  test('createDio installs the retry interceptor', () {
    expect(
      createDio().interceptors.whereType<RateLimitRetryInterceptor>(),
      hasLength(1),
    );
  });
}
