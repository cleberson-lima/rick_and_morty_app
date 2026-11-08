import 'dart:io';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

DioException _dio(DioExceptionType type, {int? status, Object? error}) {
  final options = RequestOptions(path: '/');
  return DioException(
    requestOptions: options,
    type: type,
    error: error,
    response: status == null
        ? null
        : Response<void>(requestOptions: options, statusCode: status),
  );
}

void main() {
  group('mapExceptionToFailure', () {
    test('404 is notFound', () {
      expect(
        mapExceptionToFailure(_dio(DioExceptionType.badResponse, status: 404)),
        const Failure.notFound(),
      );
    });

    test('429 is tooManyRequests', () {
      expect(
        mapExceptionToFailure(_dio(DioExceptionType.badResponse, status: 429)),
        const Failure.tooManyRequests(),
      );
    });

    test('other statuses are server failures with the code', () {
      expect(
        mapExceptionToFailure(_dio(DioExceptionType.badResponse, status: 503)),
        const Failure.server(statusCode: 503),
      );
    });

    test('timeouts and connection errors are network failures', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        expect(mapExceptionToFailure(_dio(type)), const Failure.network());
      }
      expect(
        mapExceptionToFailure(
          _dio(DioExceptionType.unknown, error: const SocketException('x')),
        ),
        const Failure.network(),
      );
      expect(
        mapExceptionToFailure(const SocketException('x')),
        const Failure.network(),
      );
    });

    test('cancel is cancelled; anything else is unexpected', () {
      expect(
        mapExceptionToFailure(_dio(DioExceptionType.cancel)),
        const Failure.cancelled(),
      );
      expect(
        mapExceptionToFailure(StateError('x')),
        const Failure.unexpected(),
      );
    });

    test('every failure has a user-facing message', () {
      const failures = [
        Failure.notFound(),
        Failure.network(),
        Failure.server(statusCode: 500),
        Failure.tooManyRequests(),
        Failure.cancelled(),
        Failure.cache(),
        Failure.unexpected(),
      ];
      for (final failure in failures) {
        expect(failure.message, isNotEmpty);
      }
      expect(const Failure.server(statusCode: 500).message, contains('500'));
    });
  });

  group('parseNextPage', () {
    test('reads the page from the API next url', () {
      expect(
        parseNextPage(
          'https://rickandmortyapi.com/api/character/?page=3&name=rick',
        ),
        3,
      );
    });

    test('null or malformed means no next page', () {
      expect(parseNextPage(null), isNull);
      expect(parseNextPage('https://x.test/?name=a'), isNull);
    });
  });

  test('ResourceType.tryParse', () {
    expect(ResourceType.tryParse('episode'), ResourceType.episode);
    expect(ResourceType.tryParse('nope'), isNull);
    expect(ResourceType.tryParse(null), isNull);
  });

  test('Breakpoints: 1 column on phones, 2–4 on wider screens', () {
    expect(Breakpoints.columnsFor(375), 1);
    expect(Breakpoints.columnsFor(800), 2);
    expect(Breakpoints.columnsFor(1200), 3);
    expect(Breakpoints.columnsFor(3000), 4);
  });

  group('ThemeCubit', () {
    test('defaults to system and persists the chosen mode', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(prefs);
      expect(cubit.state, ThemeMode.system);

      await cubit.toggle(Brightness.light);
      expect(cubit.state, ThemeMode.dark);
      expect(ThemeCubit(prefs).state, ThemeMode.dark, reason: 'restored');

      await cubit.toggle(Brightness.light);
      expect(cubit.state, ThemeMode.light);
    });

    test('following a dark system, toggle switches to light', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit(await SharedPreferences.getInstance());

      await cubit.toggle(Brightness.dark);

      expect(cubit.state, ThemeMode.light);
    });
  });

  testWidgets('StateView.error shows the message and retries', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StateView.error(
            message: 'Sem conexão',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('Sem conexão'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    expect(retried, isTrue);
  });

  test('AppRoutes.details builds the details path', () {
    expect(AppRoutes.details(ResourceType.location, 3), '/details/location/3');
  });
}
