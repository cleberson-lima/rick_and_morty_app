import 'package:core/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/favorite_item.dart';
import '../../domain/usecases/favorites_usecases.dart';

part 'favorites_cubit.freezed.dart';
part 'favorites_state.dart';

/// App-wide favorites state: one instance shared by search, details and the
/// favorites page, so a heart toggled anywhere updates everywhere.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._getFavorites, this._addFavorite, this._removeFavorite)
    : super(const FavoritesState.loading());

  final GetFavoritesUseCase _getFavorites;
  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;

  Future<void> load() async {
    emit(const FavoritesState.loading());
    final result = await _getFavorites();
    emit(
      result.fold(
        FavoritesState.error,
        (items) => FavoritesState.loaded(items: items),
      ),
    );
  }

  Future<void> toggle(FavoriteItem item) => state.isFavorite(item.type, item.id)
      ? remove(item.type, item.id)
      : add(item);

  Future<void> add(FavoriteItem item) => _apply(() => _addFavorite(item));

  Future<void> remove(ResourceType type, int id) =>
      _apply(() => _removeFavorite(type, id));

  Future<void> _apply(
    Future<Either<Failure, List<FavoriteItem>>> Function() action,
  ) async {
    final previous = state.items;
    final result = await action();
    emit(
      result.fold(
        (failure) =>
            FavoritesState.loaded(items: previous, actionFailure: failure),
        (items) => FavoritesState.loaded(items: items),
      ),
    );
  }
}
