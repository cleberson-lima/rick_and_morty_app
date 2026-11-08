import 'package:core/core.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/api_models.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._remote);

  final SearchRemoteDataSource _remote;

  @override
  Future<Either<Failure, PageResult<Character>>> searchCharacters(
    String name, {
    int page = 1,
  }) => _page(() => _remote.searchCharacters(name, page), (m) => m.toEntity());

  @override
  Future<Either<Failure, PageResult<Episode>>> searchEpisodes(
    String name, {
    int page = 1,
  }) => _page(() => _remote.searchEpisodes(name, page), (m) => m.toEntity());

  @override
  Future<Either<Failure, PageResult<Location>>> searchLocations(
    String name, {
    int page = 1,
  }) => _page(() => _remote.searchLocations(name, page), (m) => m.toEntity());

  @override
  Future<Either<Failure, Character>> getCharacter(int id) =>
      _guard(() async => (await _remote.getCharacter(id)).toEntity());

  @override
  Future<Either<Failure, Episode>> getEpisode(int id) =>
      _guard(() async => (await _remote.getEpisode(id)).toEntity());

  @override
  Future<Either<Failure, Location>> getLocation(int id) =>
      _guard(() async => (await _remote.getLocation(id)).toEntity());

  Future<Either<Failure, PageResult<E>>> _page<M, E>(
    Future<PageModel<M>> Function() request,
    E Function(M) toEntity,
  ) => _guard(() async {
    final model = await request();
    return PageResult<E>(
      items: model.results.map(toEntity).toList(growable: false),
      totalCount: model.info.count,
      nextPage: parseNextPage(model.info.next),
    );
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }
}
