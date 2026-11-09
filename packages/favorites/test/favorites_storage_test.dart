import 'package:core/types.dart';
import 'package:favorites/src/data/favorites_storage.dart';
import 'package:favorites/src/data/models/favorite_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockPrefs extends Mock implements SharedPreferences {}

const rick = FavoriteItem(
  type: ResourceType.character,
  id: 1,
  name: 'Rick Sanchez',
  subtitle: 'Human · Vivo',
  imageUrl: 'https://example.test/1.jpeg',
);
const pilot = FavoriteItem(type: ResourceType.episode, id: 1, name: 'Pilot');

Future<FavoritesStorage> _storage([
  Map<String, Object> initial = const {},
]) async {
  SharedPreferences.setMockInitialValues(initial);
  return FavoritesStorage(await SharedPreferences.getInstance());
}

List<FavoriteItem> _items(Result<List<FavoriteItem>> result) =>
    switch (result) {
      Success(:final data) => data,
      Failed() => throw StateError('expected Success, got $result'),
    };

void main() {
  test('FavoriteItem round-trips through JSON, enum stored by name', () {
    final json = rick.toJson();

    expect(json['type'], 'character');
    expect(FavoriteItem.fromJson(json), rick);
  });

  group('FavoritesStorage with SharedPreferences', () {
    test('starts empty', () async {
      final storage = await _storage();

      expect(_items(await storage.getAll()), isEmpty);
    });

    test('reads favorites saved by earlier versions of the app', () async {
      final storage = await _storage({
        FavoritesStorage.storageKey:
            '[{"type":"episode","id":1,"name":"Pilot",'
            '"subtitle":null,"imageUrl":null}]',
      });

      expect(_items(await storage.getAll()), [pilot]);
    });

    test('add puts the newest first and persists across instances', () async {
      final storage = await _storage();
      await storage.add(rick);
      await storage.add(pilot);

      final reopened = FavoritesStorage(await SharedPreferences.getInstance());

      expect(_items(await reopened.getAll()), [pilot, rick]);
    });

    test('same type and id are not duplicated', () async {
      final storage = await _storage();
      await storage.add(rick);
      final items = _items(
        await storage.add(rick.copyWith(name: 'Rick C-137')),
      );

      expect(items, hasLength(1));
      expect(items.single.name, 'Rick C-137');
    });

    test('a character and an episode with the same id are distinct', () async {
      final storage = await _storage();
      await storage.add(rick);

      expect(_items(await storage.add(pilot)), hasLength(2));
    });

    test('remove deletes only the matching item', () async {
      final storage = await _storage();
      await storage.add(rick);
      await storage.add(pilot);

      expect(_items(await storage.remove(ResourceType.character, 1)), [pilot]);
    });

    test('corrupted storage becomes a cache failure', () async {
      final storage = await _storage({FavoritesStorage.storageKey: 'not json'});

      expect(await storage.getAll(), const Failed<Never>(Failure.cache()));
    });
  });

  test('a refused write becomes a cache failure', () async {
    final prefs = _MockPrefs();
    when(() => prefs.getString(any())).thenReturn(null);
    when(() => prefs.setString(any(), any())).thenAnswer((_) async => false);

    expect(
      await FavoritesStorage(prefs).add(rick),
      const Failed<Never>(Failure.cache()),
    );
  });

  test('a throwing write becomes a cache failure', () async {
    final prefs = _MockPrefs();
    when(() => prefs.getString(any())).thenReturn(null);
    when(() => prefs.setString(any(), any())).thenThrow(StateError('disk'));

    expect(
      await FavoritesStorage(prefs).add(rick),
      const Failed<Never>(Failure.cache()),
    );
  });
}
