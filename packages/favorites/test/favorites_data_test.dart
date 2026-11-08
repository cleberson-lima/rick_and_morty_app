import 'package:core/domain.dart';
import 'package:favorites/src/data/datasources/favorites_local_data_source.dart';
import 'package:favorites/src/data/models/favorite_item_model.dart';
import 'package:favorites/src/data/repositories/favorites_repository_impl.dart';
import 'package:favorites/src/domain/entities/favorite_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockDataSource extends Mock implements FavoritesLocalDataSource {}

const rick = FavoriteItem(
  type: ResourceType.character,
  id: 1,
  name: 'Rick Sanchez',
  subtitle: 'Human · Vivo',
  imageUrl: 'https://example.test/1.jpeg',
);
const pilot = FavoriteItem(type: ResourceType.episode, id: 1, name: 'Pilot');

Future<FavoritesRepositoryImpl> _realRepository([
  Map<String, Object> initial = const {},
]) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  return FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl(prefs));
}

void main() {
  group('FavoriteItemModel', () {
    test('round-trips through JSON, enum stored by name', () {
      final model = FavoriteItemModel.fromEntity(rick);
      final json = model.toJson();

      expect(json['type'], 'character');
      expect(FavoriteItemModel.fromJson(json).toEntity(), rick);
    });
  });

  group('FavoritesRepositoryImpl with SharedPreferences', () {
    test('starts empty', () async {
      final repository = await _realRepository();

      expect((await repository.getAll()).getOrElse(() => [rick]), isEmpty);
    });

    test('add puts the newest first and persists across instances', () async {
      final repository = await _realRepository();
      await repository.add(rick);
      await repository.add(pilot);

      final prefs = await SharedPreferences.getInstance();
      final reopened = FavoritesRepositoryImpl(
        FavoritesLocalDataSourceImpl(prefs),
      );

      expect((await reopened.getAll()).getOrElse(() => []), [pilot, rick]);
    });

    test('same type and id are not duplicated', () async {
      final repository = await _realRepository();
      await repository.add(rick);
      final result = await repository.add(rick.copyWith(name: 'Rick C-137'));

      final items = result.getOrElse(() => []);
      expect(items, hasLength(1));
      expect(items.single.name, 'Rick C-137');
    });

    test('a character and an episode with the same id are distinct', () async {
      final repository = await _realRepository();
      await repository.add(rick);
      final result = await repository.add(pilot);

      expect(result.getOrElse(() => []), hasLength(2));
    });

    test('remove deletes only the matching item', () async {
      final repository = await _realRepository();
      await repository.add(rick);
      await repository.add(pilot);

      final result = await repository.remove(ResourceType.character, 1);

      expect(result.getOrElse(() => []), [pilot]);
    });

    test('corrupted storage becomes a cache failure', () async {
      final repository = await _realRepository({
        FavoritesLocalDataSourceImpl.storageKey: 'not json',
      });

      expect(
        await repository.getAll(),
        const Left<Failure, Never>(Failure.cache()),
      );
    });
  });

  test('write failure becomes a cache failure', () async {
    final dataSource = _MockDataSource();
    when(dataSource.read).thenReturn(const []);
    when(() => dataSource.write(any())).thenThrow(StateError('disk full'));

    final result = await FavoritesRepositoryImpl(dataSource).add(rick);

    expect(result, const Left<Failure, Never>(Failure.cache()));
  });
}
