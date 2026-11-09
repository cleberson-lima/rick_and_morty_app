import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:favorites/src/domain/usecases/favorites_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'favorites_data_test.dart' show pilot, rick;

class _MockGet extends Mock implements GetFavoritesUseCase {}

class _MockAdd extends Mock implements AddFavoriteUseCase {}

class _MockRemove extends Mock implements RemoveFavoriteUseCase {}

void main() {
  late _MockGet getFavorites;
  late _MockAdd addFavorite;
  late _MockRemove removeFavorite;

  setUpAll(() => registerFallbackValue(rick));

  setUp(() {
    getFavorites = _MockGet();
    addFavorite = _MockAdd();
    removeFavorite = _MockRemove();
  });

  FavoritesCubit build() =>
      FavoritesCubit(getFavorites, addFavorite, removeFavorite);

  blocTest<FavoritesCubit, FavoritesState>(
    'load emits the stored items',
    setUp: () =>
        when(() => getFavorites()).thenAnswer((_) async => const Right([rick])),
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
      () => getFavorites(),
    ).thenAnswer((_) async => const Left(Failure.cache())),
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
      () => addFavorite(pilot),
    ).thenAnswer((_) async => const Right([pilot, rick])),
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
      () => removeFavorite(ResourceType.character, 1),
    ).thenAnswer((_) async => const Right([])),
    build: build,
    seed: () => const FavoritesState.loaded(items: [rick]),
    act: (cubit) => cubit.toggle(rick),
    expect: () => const [FavoritesState.loaded(items: [])],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'a failed write keeps the list and reports the error',
    setUp: () => when(
      () => addFavorite(any()),
    ).thenAnswer((_) async => const Left(Failure.cache())),
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
