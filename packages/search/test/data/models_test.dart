import 'package:flutter_test/flutter_test.dart';
import 'package:search/src/data/models/models.dart';

import '../helpers.dart';

Json _first(String fixtureName) =>
    (fixture(fixtureName)['results']! as List<Object?>).first! as Json;

void main() {
  test('Character reads the API JSON', () {
    final character = Character.fromJson(_first('characters_page.json'));

    expect(character.id, 1);
    expect(character.name, 'Rick Sanchez');
    expect(character.status, CharacterStatus.alive);
    expect(character.originName, 'Earth (C-137)');
    expect(character.originId, 1, reason: 'from origin.url');
    expect(character.locationId, 3, reason: 'from location.url');
    expect(character.imageUrl, endsWith('/1.jpeg'));
    expect(character.episodeCount, greaterThan(0));
  });

  test('Character tolerates unknown origin and missing optionals', () {
    final character = Character.fromJson({
      'id': 2,
      'name': 'X',
      'status': 'whatever',
      'species': 'Alien',
      'gender': 'unknown',
      'origin': {'name': 'unknown', 'url': ''},
      'location': {'name': 'unknown'},
      'image': 'https://x.test/2.jpeg',
    });

    expect(character.status, CharacterStatus.unknown);
    expect(character.type, '');
    expect(character.originId, isNull);
    expect(character.locationId, isNull);
    expect(character.episodeCount, 0);
  });

  test('CharacterStatus parses the API value, ignoring case', () {
    expect(CharacterStatus.parse('Alive'), CharacterStatus.alive);
    expect(CharacterStatus.parse('dead'), CharacterStatus.dead);
    expect(CharacterStatus.parse('unknown'), CharacterStatus.unknown);
    expect(CharacterStatus.parse(null), CharacterStatus.unknown);
  });

  test('Episode reads the code, air_date and the cast size', () {
    final episode = Episode.fromJson(_first('episodes_page.json'));

    expect(episode.code, 'S01E01');
    expect(episode.airDate, isNotEmpty);
    expect(episode.characterCount, greaterThan(0));
  });

  test('Location defaults type, dimension and residents', () {
    final location = Location.fromJson({'id': 9, 'name': 'Nowhere'});

    expect(
      (location.type, location.dimension, location.residentCount),
      ('', '', 0),
    );
  });

  test('models compare by value', () {
    expect(
      Location.fromJson({'id': 9, 'name': 'Nowhere'}),
      const Location(id: 9, name: 'Nowhere'),
    );
  });

  test('idFromResourceUrl reads the trailing id', () {
    expect(idFromResourceUrl('https://rickandmortyapi.com/api/location/3'), 3);
    expect(idFromResourceUrl('https://rickandmortyapi.com/api/location/3/'), 3);
    expect(idFromResourceUrl(''), isNull, reason: 'unknown origin');
    expect(idFromResourceUrl(null), isNull);
    expect(idFromResourceUrl('https://x.test/api/location/abc'), isNull);
  });
}
