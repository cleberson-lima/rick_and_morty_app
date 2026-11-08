import 'dart:io';

import 'package:core/domain.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/data/datasources/search_remote_data_source.dart';
import 'package:search/src/data/models/api_models.dart';
import 'package:search/src/data/repositories/search_repository_impl.dart';
import 'package:search/src/domain/entities/character.dart';

import '../helpers.dart';

class _MockRemote extends Mock implements SearchRemoteDataSource {}

DioException _dioError(DioExceptionType type, {int? status, Object? error}) {
  final options = RequestOptions(path: '/character/');
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
  late _MockRemote remote;
  late SearchRepositoryImpl repository;

  final page = PageModel.fromJson(
    fixture('characters_page.json'),
    (json) => CharacterModel.fromJson(json! as Map<String, Object?>),
  );

  setUp(() {
    remote = _MockRemote();
    repository = SearchRepositoryImpl(remote);
  });

  group('searchCharacters', () {
    test('maps models to entities and parses the next page', () async {
      when(
        () => remote.searchCharacters('rick', 1),
      ).thenAnswer((_) async => page);

      final result = await repository.searchCharacters('rick');

      final value = result.getOrElse(() => throw StateError('expected Right'));
      expect(value.totalCount, 107);
      expect(value.nextPage, 2);
      expect(value.items.first.name, 'Rick Sanchez');
      expect(value.items.first.status, CharacterStatus.alive);
      expect(value.items.first.episodeCount, greaterThan(0));
    });

    final cases = <String, (DioException, Failure)>{
      '404 → notFound': (
        _dioError(DioExceptionType.badResponse, status: 404),
        const Failure.notFound(),
      ),
      '429 → tooManyRequests': (
        _dioError(DioExceptionType.badResponse, status: 429),
        const Failure.tooManyRequests(),
      ),
      '500 → server': (
        _dioError(DioExceptionType.badResponse, status: 500),
        const Failure.server(statusCode: 500),
      ),
      'timeout → network': (
        _dioError(DioExceptionType.receiveTimeout),
        const Failure.network(),
      ),
      'no connection → network': (
        _dioError(DioExceptionType.connectionError),
        const Failure.network(),
      ),
      'socket error → network': (
        _dioError(
          DioExceptionType.unknown,
          error: const SocketException('down'),
        ),
        const Failure.network(),
      ),
      'cancel → cancelled': (
        _dioError(DioExceptionType.cancel),
        const Failure.cancelled(),
      ),
    };

    for (final MapEntry(key: name, value: (error, failure)) in cases.entries) {
      test(name, () async {
        when(() => remote.searchCharacters(any(), any())).thenThrow(error);

        final result = await repository.searchCharacters('x');

        expect(result, Left<Failure, Never>(failure));
      });
    }

    test('malformed payload → unexpected', () async {
      when(
        () => remote.searchCharacters(any(), any()),
      ).thenThrow(const FormatException('bad json'));

      expect(
        await repository.searchCharacters('x'),
        const Left<Failure, Never>(Failure.unexpected()),
      );
    });
  });

  test('episodes and locations map to entities', () async {
    when(() => remote.searchEpisodes('pilot', 1)).thenAnswer(
      (_) async => PageModel.fromJson(
        fixture('episodes_page.json'),
        (json) => EpisodeModel.fromJson(json! as Map<String, Object?>),
      ),
    );
    when(() => remote.searchLocations('earth', 1)).thenAnswer(
      (_) async => PageModel.fromJson(
        fixture('locations_page.json'),
        (json) => LocationModel.fromJson(json! as Map<String, Object?>),
      ),
    );

    final episodes = await repository.searchEpisodes('pilot');
    final locations = await repository.searchLocations('earth');

    expect(episodes.isRight(), isTrue);
    expect(episodes.fold((_) => null, (p) => p.items.first.code), 'S01E01');
    expect(locations.fold((_) => null, (p) => p.items), isNotEmpty);
  });

  test('getCharacter maps 404 to notFound', () async {
    when(
      () => remote.getCharacter(9999),
    ).thenThrow(_dioError(DioExceptionType.badResponse, status: 404));

    expect(
      await repository.getCharacter(9999),
      const Left<Failure, Never>(Failure.notFound()),
    );
  });

  test('getEpisode and getLocation return entities', () async {
    when(() => remote.getEpisode(1)).thenAnswer(
      (_) async => const EpisodeModel(
        id: 1,
        name: 'Pilot',
        airDate: 'December 2, 2013',
        episode: 'S01E01',
        characters: ['a', 'b'],
      ),
    );
    when(() => remote.getLocation(1)).thenAnswer(
      (_) async => const LocationModel(id: 1, name: 'Earth', residents: ['a']),
    );

    final episode = await repository.getEpisode(1);
    final location = await repository.getLocation(1);

    expect(episode.fold((_) => null, (e) => e.characterCount), 2);
    expect(location.fold((_) => null, (l) => l.residentCount), 1);
  });
}
