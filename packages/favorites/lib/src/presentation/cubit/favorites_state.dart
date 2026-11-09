part of 'favorites_cubit.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const FavoritesState._();

  const factory FavoritesState.loading() = FavoritesLoading;

  /// [actionFailure] reports a failed add/remove while keeping the list usable.
  const factory FavoritesState.loaded({
    required List<FavoriteItem> items,
    Failure? actionFailure,
  }) = FavoritesLoaded;

  const factory FavoritesState.error(Failure failure) = FavoritesError;

  List<FavoriteItem> get items => switch (this) {
    FavoritesLoaded(:final items) => items,
    _ => const [],
  };

  bool isFavorite(ResourceType type, int id) =>
      items.containsResource(type, id);
}
