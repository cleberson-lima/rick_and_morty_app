import 'package:core/domain.dart';

import '../entities/character.dart';
import '../entities/episode.dart';
import '../entities/location.dart';
import '../repositories/search_repository.dart';

/// Common shape of the three search use cases, so one generic Bloc can drive
/// any of them.
abstract interface class SearchUseCase<T> {
  Future<Either<Failure, PageResult<T>>> call(String query, {int page = 1});
}

class SearchCharactersUseCase implements SearchUseCase<Character> {
  const SearchCharactersUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Either<Failure, PageResult<Character>>> call(
    String query, {
    int page = 1,
  }) => _repository.searchCharacters(query.trim(), page: page);
}

class SearchEpisodesUseCase implements SearchUseCase<Episode> {
  const SearchEpisodesUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Either<Failure, PageResult<Episode>>> call(
    String query, {
    int page = 1,
  }) => _repository.searchEpisodes(query.trim(), page: page);
}

class SearchLocationsUseCase implements SearchUseCase<Location> {
  const SearchLocationsUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Either<Failure, PageResult<Location>>> call(
    String query, {
    int page = 1,
  }) => _repository.searchLocations(query.trim(), page: page);
}
