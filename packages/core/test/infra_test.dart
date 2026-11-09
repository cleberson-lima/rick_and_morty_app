import 'dart:io';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('createDio targets the API with timeouts and a debug logger', () {
    final dio = createDio();

    expect(dio.options.baseUrl, ApiConfig.baseUrl);
    expect(dio.options.connectTimeout, ApiConfig.timeout);
    expect(dio.options.receiveTimeout, ApiConfig.timeout);
    expect(dio.interceptors.whereType<LogInterceptor>(), isNotEmpty);
  });

  test('PaginatedList.hasNext follows nextPage', () {
    expect(
      const PaginatedList(items: [1], totalCount: 2, nextPage: 2).hasNext,
      isTrue,
    );
    expect(const PaginatedList(items: [1], totalCount: 1).hasNext, isFalse);
  });

  test(
    'CoreDependencies.load reads storage and builds the API client',
    () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

      final temp = await Directory.systemTemp.createTemp('core_test');
      addTearDown(() => temp.delete(recursive: true));

      final core = await CoreDependencies.load(cacheRoot: () async => temp);

      expect(core.preferences.getString('theme_mode'), 'dark');
      expect(core.dio.options.baseUrl, ApiConfig.baseUrl);
      final cache = core.dio.interceptors
          .whereType<OfflineCacheInterceptor>()
          .single;
      expect(cache.directory.path, '${temp.path}/api');
    },
  );

  test('CoreDependencies keeps an injected Dio', () async {
    SharedPreferences.setMockInitialValues({});
    final dio = Dio();

    final core = CoreDependencies(
      preferences: await SharedPreferences.getInstance(),
      dio: dio,
    );

    expect(core.dio, same(dio));
  });
}
