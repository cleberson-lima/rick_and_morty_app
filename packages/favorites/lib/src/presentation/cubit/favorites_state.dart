import 'package:core/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/favorite_item.dart';

part 'favorites_state.freezed.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const FavoritesState._();

  const factory FavoritesState.loading() = FavoritesLoading;

  /// [errorMessage] reports a failed add/remove while keeping the list usable.
  const factory FavoritesState.loaded({
    required List<FavoriteItem> items,
    String? errorMessage,
  }) = FavoritesLoaded;

  const factory FavoritesState.error(String message) = FavoritesError;

  List<FavoriteItem> get items => switch (this) {
    FavoritesLoaded(:final items) => items,
    _ => const [],
  };

  bool isFavorite(ResourceType type, int id) =>
      items.containsResource(type, id);
}
