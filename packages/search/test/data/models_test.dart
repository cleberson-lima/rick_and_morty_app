import 'package:flutter_test/flutter_test.dart';
import 'package:search/src/data/models/models.dart';
import 'package:search/src/domain/entities/character.dart';

import '../helpers.dart';

/// Model with no `fromJson` registered in [Model.fromJson].
class _Unregistered extends Model<int> {
  @override
  int toEntity() => 0;
}

Json _first(String fixtureName) =>
    (fixture(fixtureName)['results']! as List<Object?>).first! as Json;

void main() {
  group('Model.fromJson', () {
    test('builds the model of the requested type', () {
      expect(
        Model.fromJson<CharacterModel>(_first('characters_page.json')),
        isA<CharacterModel>(),
      );
      expect(
        Model.fromJson<EpisodeModel>(_first('episodes_page.json')),
        isA<EpisodeModel>(),
      );
      expect(
        Model.fromJson<LocationModel>(_first('locations_page.json')),
        isA<LocationModel>(),
      );
    });

    test('an unregistered type is an error, not a silent null', () {
      expect(() => Model.fromJson<_Unregistered>({}), throwsArgumentError);
    });
  });

  test('CharacterModel reads the API JSON and maps to the entity', () {
    final model = CharacterModel.fromJson(_first('characters_page.json'));
    final entity = model.toEntity();

    expect(entity.id, 1);
    expect(entity.name, 'Rick Sanchez');
    expect(entity.status, CharacterStatus.alive);
    expect(entity.originName, 'Earth (C-137)');
    expect(entity.originId, 1);
    expect(entity.locationId, 3);
    expect(entity.episodeCount, greaterThan(0));
  });

  test('CharacterModel tolerates unknown origin and missing optionals', () {
    final entity = CharacterModel.fromJson({
      'id': 2,
      'name': 'X',
      'status': 'whatever',
      'species': 'Alien',
      'gender': 'unknown',
      'origin': {'name': 'unknown', 'url': ''},
      'location': {'name': 'unknown'},
      'image': 'https://x.test/2.jpeg',
    }).toEntity();

    expect(entity.status, CharacterStatus.unknown);
    expect(entity.type, '');
    expect(entity.originId, isNull);
    expect(entity.locationId, isNull);
    expect(entity.episodeCount, 0);
  });

  test('EpisodeModel reads air_date and the cast size', () {
    final entity = EpisodeModel.fromJson(
      _first('episodes_page.json'),
    ).toEntity();

    expect(entity.code, 'S01E01');
    expect(entity.airDate, isNotEmpty);
    expect(entity.characterCount, greaterThan(0));
  });

  test('LocationModel defaults type, dimension and residents', () {
    final entity = LocationModel.fromJson({
      'id': 9,
      'name': 'Nowhere',
    }).toEntity();

    expect((entity.type, entity.dimension, entity.residentCount), ('', '', 0));
  });

  test('PageModel parses info and every result with Model.fromJson', () {
    final page = PageModel<CharacterModel>.fromJson(
      fixture('characters_page.json'),
    );

    expect(page.count, 107);
    expect(page.nextPage, 2);
    expect(page.results, isNotEmpty);
    expect(page.results.first.name, 'Rick Sanchez');
  });

  test('PageModel on the last page has no next page', () {
    final page = PageModel<LocationModel>.fromJson({
      'info': {'count': 1, 'next': null},
      'results': [
        {'id': 1, 'name': 'Earth'},
      ],
    });

    expect(page.nextPage, isNull);
    expect(page.results.single.name, 'Earth');
  });

  test('idFromResourceUrl reads the trailing id', () {
    expect(idFromResourceUrl('https://rickandmortyapi.com/api/location/3'), 3);
    expect(idFromResourceUrl('https://rickandmortyapi.com/api/location/3/'), 3);
    expect(idFromResourceUrl(''), isNull, reason: 'unknown origin');
    expect(idFromResourceUrl(null), isNull);
    expect(idFromResourceUrl('https://x.test/api/location/abc'), isNull);
  });
}
