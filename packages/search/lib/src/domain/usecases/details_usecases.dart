import 'package:core/domain.dart';

import '../entities/character.dart';
import '../entities/episode.dart';
import '../entities/location.dart';
import '../repositories/search_repository.dart';

class GetCharacterUseCase {
  const GetCharacterUseCase(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, Character>> call(int id) =>
      _repository.getCharacter(id);
}

class GetEpisodeUseCase {
  const GetEpisodeUseCase(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, Episode>> call(int id) => _repository.getEpisode(id);
}

class GetLocationUseCase {
  const GetLocationUseCase(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, Location>> call(int id) => _repository.getLocation(id);
}
