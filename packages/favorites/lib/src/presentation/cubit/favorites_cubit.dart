import 'package:core/types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/favorites_storage.dart';

part 'favorites_cubit.freezed.dart';
part 'favorites_state.dart';

/// App-wide favorites state: one instance shared by search, details and the
/// favorites page, so a heart toggled anywhere updates everywhere.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._storage) : super(const FavoritesState.loading());

  final FavoritesStorage _storage;

  Future<void> load() async {
    emit(const FavoritesState.loading());
    emit(switch (await _storage.getAll()) {
      Success(data: final items) => FavoritesState.loaded(items: items),
      Failed(:final failure) => FavoritesState.error(failure),
    });
  }

  Future<void> toggle(FavoriteItem item) => state.isFavorite(item.type, item.id)
      ? remove(item.type, item.id)
      : add(item);

  Future<void> add(FavoriteItem item) => _apply(() => _storage.add(item));

  Future<void> remove(ResourceType type, int id) =>
      _apply(() => _storage.remove(type, id));

  Future<void> _apply(
    Future<Result<List<FavoriteItem>>> Function() action,
  ) async {
    final previous = state.items;
    emit(switch (await action()) {
      Success(data: final items) => FavoritesState.loaded(items: items),
      // Keep the list usable; the listener shows the failure in a snackbar.
      Failed(:final failure) => FavoritesState.loaded(
        items: previous,
        actionFailure: failure,
      ),
    });
  }
}
