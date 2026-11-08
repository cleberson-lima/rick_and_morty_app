import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/src/data/datasources/search_remote_data_source.dart';

import '../helpers.dart';

void main() {
  group('SearchRemoteDataSourceImpl', () {
    test('parses a character page and sends name + page', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody(fixture('characters_page.json')),
      );
      final source = SearchRemoteDataSourceImpl(dioWith(adapter));

      final page = await source.searchCharacters('rick', 2);

      expect(page.info.count, 107);
      expect(page.results.first.name, 'Rick Sanchez');
      expect(adapter.requests.single.path, '/character/');
      expect(adapter.requests.single.queryParameters, {
        'name': 'rick',
        'page': 2,
      });
    });

    test('omits empty name and first page from the query', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody(fixture('episodes_page.json')),
      );
      final source = SearchRemoteDataSourceImpl(dioWith(adapter));

      final page = await source.searchEpisodes('', 1);

      expect(page.results.first.episode, 'S01E01');
      expect(adapter.requests.single.queryParameters, isEmpty);
    });

    test('parses locations and fetches by id', () async {
      final adapter = FakeAdapter((options) async {
        if (options.path == '/location/3') {
          return jsonBody(
            (fixture('locations_page.json')['results']! as List).first,
          );
        }
        return jsonBody(fixture('locations_page.json'));
      });
      final source = SearchRemoteDataSourceImpl(dioWith(adapter));

      final page = await source.searchLocations('earth', 1);
      final single = await source.getLocation(3);

      expect(page.results, isNotEmpty);
      expect(single.name, page.results.first.name);
    });

    test('throws a 404 DioException when nothing matches', () async {
      final adapter = FakeAdapter(
        (_) async => jsonBody({'error': 'There is nothing here'}, status: 404),
      );
      final source = SearchRemoteDataSourceImpl(dioWith(adapter));

      await expectLater(
        source.searchCharacters('xyz', 1),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        ),
      );
    });

    test('a new search cancels the previous one of the same type', () async {
      final firstResponse = Completer<void>();
      final adapter = FakeAdapter((options) async {
        if (options.queryParameters['name'] == 'ri') {
          await firstResponse.future; // the stale request hangs
        }
        return jsonBody(fixture('characters_page.json'));
      });
      final source = SearchRemoteDataSourceImpl(dioWith(adapter));

      final first = source.searchCharacters('ri', 1);
      final second = source.searchCharacters('rick', 1);

      await expectLater(
        first,
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.cancel,
          ),
        ),
      );
      expect((await second).results, isNotEmpty);
      firstResponse.complete();
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
      final source = SearchRemoteDataSourceImpl(dioWith(adapter));

      final results = await Future.wait([
        source.searchCharacters('rick', 1),
        source.searchEpisodes('pilot', 1),
      ]);

      expect(results, hasLength(2));
    });
  });
}
