import 'package:core/domain.dart';

import '../entities/favorite_item.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<Either<Failure, List<FavoriteItem>>> call() => _repository.getAll();
}

class AddFavoriteUseCase {
  const AddFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<Either<Failure, List<FavoriteItem>>> call(FavoriteItem item) =>
      _repository.add(item);
}

class RemoveFavoriteUseCase {
  const RemoveFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<Either<Failure, List<FavoriteItem>>> call(ResourceType type, int id) =>
      _repository.remove(type, id);
}
