import 'dart:async';
import 'dart:io';

import 'package:core/domain.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/src/data/models/models.dart';
import 'package:search/src/data/search_api.dart';

import '../helpers.dart';

T _data<T>(Result<T> result) => switch (result) {
  Success(:final data) => data,
  Failed() => throw StateError('expected Success, got $result'),
};

void main() {
  group('search', () {
    test('parses a character page and sends the trimmed name + page', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody(fixture('characters_page.json')),
      );
      final api = SearchApi(dioWith(adapter));

      final page = _data(await api.searchCharacters('  rick ', page: 2));

      expect(page.totalCount, 107);
      expect(page.nextPage, 2);
      expect(page.items.first.name, 'Rick Sanchez');
      expect(page.items.first.locationId, 3);
      expect(adapter.requests.single.path, '/character/');
      expect(adapter.requests.single.queryParameters, {
        'name': 'rick',
        'page': 2,
      });
    });

    test('omits an empty name and the first page from the query', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody(fixture('episodes_page.json')),
      );
      final api = SearchApi(dioWith(adapter));

      final page = _data(await api.searchEpisodes(''));

      expect(page.items.first.code, 'S01E01');
      expect(adapter.requests.single.path, '/episode/');
      expect(adapter.requests.single.queryParameters, isEmpty);
    });

    test('the last page has no next page', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody({
          'info': {'count': 1, 'next': null},
          'results': [
            {'id': 1, 'name': 'Earth'},
          ],
        }),
      );
      final api = SearchApi(dioWith(adapter));

      final page = _data(await api.searchLocations('earth'));

      expect(page.nextPage, isNull);
      expect(page.items.single, const Location(id: 1, name: 'Earth'));
    });
  });

  group('get by id', () {
    test('fetches one character, episode and location', () async {
      Json first(String name) =>
          (fixture(name)['results']! as List<Object?>).first! as Json;
      final adapter = FakeAdapter(
        (options) async => jsonBody(switch (options.path) {
          '/character/1' => first('characters_page.json'),
          '/episode/1' => first('episodes_page.json'),
          _ => first('locations_page.json'),
        }),
      );
      final api = SearchApi(dioWith(adapter));

      expect(_data(await api.getCharacter(1)).name, 'Rick Sanchez');
      expect(_data(await api.getEpisode(1)).code, 'S01E01');
      expect(_data(await api.getLocation(1)).id, 1);
      expect(adapter.requests.map((r) => r.path), [
        '/character/1',
        '/episode/1',
        '/location/1',
      ]);
    });

    test('a 404 becomes notFound', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody({'error': 'Character not found'}, status: 404),
      );
      final api = SearchApi(dioWith(adapter));

      expect(
        await api.getCharacter(9999),
        const Failed<Never>(Failure.notFound()),
      );
    });
  });

  group('errors become failures, never exceptions', () {
    DioException timeout(RequestOptions options) => DioException(
      requestOptions: options,
      type: DioExceptionType.receiveTimeout,
    );
    DioException noConnection(RequestOptions options) => DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
    );

    final cases =
        <String, (Future<ResponseBody> Function(RequestOptions), Failure)>{
          '404 → notFound': (
            (_) async =>
                jsonBody({'error': 'There is nothing here'}, status: 404),
            const Failure.notFound(),
          ),
          '429 → tooManyRequests': (
            (_) async => jsonBody({}, status: 429),
            const Failure.tooManyRequests(),
          ),
          '500 → server': (
            (_) async => jsonBody({}, status: 500),
            const Failure.server(statusCode: 500),
          ),
          'timeout → network': (
            (options) async => throw timeout(options),
            const Failure.network(),
          ),
          'no connection → network': (
            (options) async => throw noConnection(options),
            const Failure.network(),
          ),
          'socket error → network': (
            (_) async => throw const SocketException('down'),
            const Failure.network(),
          ),
          'malformed payload → unexpected': (
            (_) async => jsonBody({'unexpected': true}),
            const Failure.unexpected(),
          ),
        };

    for (final MapEntry(key: name, value: (handler, failure))
        in cases.entries) {
      test(name, () async {
        final api = SearchApi(dioWith(FakeAdapter(handler)));

        expect(await api.searchCharacters('x'), Failed<Never>(failure));
      });
    }
  });

  group('cancellation', () {
    test('a new search cancels the previous one of the same type', () async {
      final staleResponse = Completer<void>();
      final adapter = FakeAdapter((options) async {
        if (options.queryParameters['name'] == 'ri') {
          await staleResponse.future; // the stale request hangs
        }
        return jsonBody(fixture('characters_page.json'));
      });
      final api = SearchApi(dioWith(adapter));

      final first = api.searchCharacters('ri');
      final second = api.searchCharacters('rick');

      expect(await first, const Failed<Never>(Failure.cancelled()));
      expect(_data(await second).items, isNotEmpty);
      staleResponse.complete();
    });

    test('searches of different types do not cancel each other', () async {
      final adapter = FakeAdapter((options) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return jsonBody(
          fixture(
            options.path == '/character/'
                ? 'characters_page.json'
                : 'episodes_page.json',
          ),
        );
      });
      final api = SearchApi(dioWith(adapter));

      final results = await Future.wait([
        api.searchCharacters('rick'),
        api.searchEpisodes('pilot'),
      ]);

      expect(results.every((r) => r is Success), isTrue);
    });

    test('separate instances do not cancel each other', () async {
      final adapter = FakeAdapter((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return jsonBody(fixture('characters_page.json'));
      });
      final dio = dioWith(adapter);

      final results = await Future.wait([
        SearchApi(dio).searchCharacters(''),
        SearchApi(dio).searchCharacters(''),
      ]);

      expect(results.every((r) => r is Success), isTrue);
    });
  });
}
