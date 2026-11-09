import 'package:bloc_test/bloc_test.dart';
import 'package:core/types.dart';
import 'package:favorites/favorites.dart';
import 'package:favorites/src/data/favorites_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'favorites_storage_test.dart' show pilot, rick;

class _MockStorage extends Mock implements FavoritesStorage {}

void main() {
  late _MockStorage storage;

  setUpAll(() => registerFallbackValue(rick));

  setUp(() => storage = _MockStorage());

  FavoritesCubit build() => FavoritesCubit(storage);

  blocTest<FavoritesCubit, FavoritesState>(
    'load emits the stored items',
    setUp: () => when(
      () => storage.getAll(),
    ).thenAnswer((_) async => const Success([rick])),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      FavoritesState.loading(),
      FavoritesState.loaded(items: [rick]),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'load failure emits error',
    setUp: () => when(
      () => storage.getAll(),
    ).thenAnswer((_) async => const Failed(Failure.cache())),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const FavoritesState.loading(),
      const FavoritesState.error(Failure.cache()),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle adds an item that is not a favorite',
    setUp: () => when(
      () => storage.add(pilot),
    ).thenAnswer((_) async => const Success([pilot, rick])),
    build: build,
    seed: () => const FavoritesState.loaded(items: [rick]),
    act: (cubit) => cubit.toggle(pilot),
    expect: () => const [
      FavoritesState.loaded(items: [pilot, rick]),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle removes an item that is already a favorite',
    setUp: () => when(
      () => storage.remove(ResourceType.character, 1),
    ).thenAnswer((_) async => const Success([])),
    build: build,
    seed: () => const FavoritesState.loaded(items: [rick]),
    act: (cubit) => cubit.toggle(rick),
    expect: () => const [FavoritesState.loaded(items: [])],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'a failed write keeps the list and reports the error',
    setUp: () => when(
      () => storage.add(any()),
    ).thenAnswer((_) async => const Failed(Failure.cache())),
    build: build,
    seed: () => const FavoritesState.loaded(items: [rick]),
    act: (cubit) => cubit.add(pilot),
    expect: () => [
      const FavoritesState.loaded(
        items: [rick],
        actionFailure: Failure.cache(),
      ),
    ],
  );

  test('isFavorite matches on type and id', () {
    const state = FavoritesState.loaded(items: [rick]);

    expect(state.isFavorite(ResourceType.character, 1), isTrue);
    expect(state.isFavorite(ResourceType.episode, 1), isFalse);
    expect(
      const FavoritesState.loading().isFavorite(ResourceType.character, 1),
      isFalse,
    );
  });
}
