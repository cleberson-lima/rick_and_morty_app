import 'package:core/domain.dart';

import '../entities/favorite_item.dart';

abstract interface class FavoritesRepository {
  /// Most recently added first.
  Future<Either<Failure, List<FavoriteItem>>> getAll();

  /// Adds [item], or moves it to the top if it is already a favorite.
  Future<Either<Failure, List<FavoriteItem>>> add(FavoriteItem item);

  Future<Either<Failure, List<FavoriteItem>>> remove(ResourceType type, int id);
}
