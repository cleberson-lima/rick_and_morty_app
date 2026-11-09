import 'package:auto_injector/auto_injector.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  test('CoreModule exports SharedPreferences, Dio and ThemeCubit', () async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    await CoreModule.initialize();

    final injector = AutoInjector();
    CoreModule().exportedBinds(injector);
    injector.commit();

    expect(injector.get<SharedPreferences>(), isA<SharedPreferences>());
    expect(injector.get<Dio>().options.baseUrl, ApiConfig.baseUrl);
    expect(injector.get<ThemeCubit>().state, ThemeMode.dark);
    expect(
      identical(injector.get<Dio>(), injector.get<Dio>()),
      isTrue,
      reason: 'singleton',
    );
  });
}
