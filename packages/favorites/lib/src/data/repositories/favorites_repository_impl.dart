import 'package:core/domain.dart';

import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../models/favorite_item_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._dataSource);

  final FavoritesLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<FavoriteItem>>> getAll() async {
    try {
      return Right(_toEntities(_dataSource.read()));
    } catch (_) {
      return const Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, List<FavoriteItem>>> add(FavoriteItem item) => _update(
    (items) => [
      FavoriteItemModel.fromEntity(item),
      ...items.where((m) => !_same(m, item.type, item.id)),
    ],
  );

  @override
  Future<Either<Failure, List<FavoriteItem>>> remove(
    ResourceType type,
    int id,
  ) => _update((items) => items.where((m) => !_same(m, type, id)).toList());

  Future<Either<Failure, List<FavoriteItem>>> _update(
    List<FavoriteItemModel> Function(List<FavoriteItemModel>) change,
  ) async {
    try {
      final updated = change(_dataSource.read());
      await _dataSource.write(updated);
      return Right(_toEntities(updated));
    } catch (_) {
      return const Left(Failure.cache());
    }
  }

  static bool _same(FavoriteItemModel m, ResourceType type, int id) =>
      m.type == type && m.id == id;

  static List<FavoriteItem> _toEntities(List<FavoriteItemModel> models) =>
      List.unmodifiable(models.map((m) => m.toEntity()));
}
