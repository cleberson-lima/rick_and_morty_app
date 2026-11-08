import 'package:core/domain.dart';
import 'package:dio/dio.dart';

import '../models/models.dart';

abstract interface class SearchRemoteDataSource {
  Future<PageModel<CharacterModel>> searchCharacters(String name, int page);

  Future<PageModel<EpisodeModel>> searchEpisodes(String name, int page);

  Future<PageModel<LocationModel>> searchLocations(String name, int page);

  Future<CharacterModel> getCharacter(int id);

  Future<EpisodeModel> getEpisode(int id);

  Future<LocationModel> getLocation(int id);
}

/// Talks to `https://rickandmortyapi.com/api`. Throws [DioException]; the
/// repository maps it to a `Failure`.
///
/// Each resource type keeps its own [CancelToken]: starting a search cancels
/// the previous in-flight search of the same type, so a slow response for
/// "ri" can never overwrite the results for "rick".
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this._dio);

  final Dio _dio;
  final Map<ResourceType, CancelToken> _tokens = {};

  CancelToken _renewToken(ResourceType type) {
    _tokens[type]?.cancel('Superseded by a newer search');
    return _tokens[type] = CancelToken();
  }

  Future<PageModel<M>> _search<M extends Model<Object?>>(
    ResourceType type,
    String name,
    int page,
  ) async {
    final response = await _dio.get<Json>(
      '/${type.name}/',
      queryParameters: {
        if (name.isNotEmpty) 'name': name,
        if (page > 1) 'page': page,
      },
      cancelToken: _renewToken(type),
    );
    return PageModel<M>.fromJson(response.data!);
  }

  Future<M> _getById<M extends Model<Object?>>(
    ResourceType type,
    int id,
  ) async {
    final response = await _dio.get<Json>('/${type.name}/$id');
    return Model.fromJson<M>(response.data!);
  }

  @override
  Future<PageModel<CharacterModel>> searchCharacters(String name, int page) =>
      _search(ResourceType.character, name, page);

  @override
  Future<PageModel<EpisodeModel>> searchEpisodes(String name, int page) =>
      _search(ResourceType.episode, name, page);

  @override
  Future<PageModel<LocationModel>> searchLocations(String name, int page) =>
      _search(ResourceType.location, name, page);

  @override
  Future<CharacterModel> getCharacter(int id) =>
      _getById(ResourceType.character, id);

  @override
  Future<EpisodeModel> getEpisode(int id) => _getById(ResourceType.episode, id);

  @override
  Future<LocationModel> getLocation(int id) =>
      _getById(ResourceType.location, id);
}
