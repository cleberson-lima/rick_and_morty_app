import 'package:core/core.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

/// One page of a search, as the Blocs and Cubits consume it.
typedef FetchPage<T> =
    Future<Result<PageResult<T>>> Function(String query, {int page});

/// Client of `https://rickandmortyapi.com/api`.
///
/// Never throws: every call returns a `Result`, with Dio errors
/// mapped by [mapExceptionToFailure] (404 → `NotFoundFailure`).
///
/// Each resource type keeps its own [CancelToken]: starting a search cancels
/// the previous in-flight search of the same type, so a slow response for
/// "ri" can never overwrite the results for "rick". Screens that must not
/// cancel each other (the "Mais ..." sections) use their own instance.
class SearchApi {
  SearchApi(this._dio);

  final Dio _dio;
  final Map<ResourceType, CancelToken> _tokens = {};

  Future<Result<PageResult<Character>>> searchCharacters(
    String query, {
    int page = 1,
  }) => _search(ResourceType.character, query, page, Character.fromJson);

  Future<Result<PageResult<Episode>>> searchEpisodes(
    String query, {
    int page = 1,
  }) => _search(ResourceType.episode, query, page, Episode.fromJson);

  Future<Result<PageResult<Location>>> searchLocations(
    String query, {
    int page = 1,
  }) => _search(ResourceType.location, query, page, Location.fromJson);

  Future<Result<Character>> getCharacter(int id) =>
      _getById(ResourceType.character, id, Character.fromJson);

  Future<Result<Episode>> getEpisode(int id) =>
      _getById(ResourceType.episode, id, Episode.fromJson);

  Future<Result<Location>> getLocation(int id) =>
      _getById(ResourceType.location, id, Location.fromJson);

  /// Parses `{ "info": { "count", "next" }, "results": [...] }`.
  Future<Result<PageResult<T>>> _search<T>(
    ResourceType type,
    String query,
    int page,
    T Function(Json json) fromJson,
  ) => _guard(() async {
    final name = query.trim();
    final response = await _dio.get<Json>(
      '/${type.name}/',
      queryParameters: {
        if (name.isNotEmpty) 'name': name,
        if (page > 1) 'page': page,
      },
      cancelToken: _renewToken(type),
    );
    final json = response.data!;
    final info = json['info']! as Json;
    return PageResult<T>(
      items: [
        for (final item in json['results']! as List<Object?>)
          fromJson(item! as Json),
      ],
      totalCount: info['count']! as int,
      nextPage: parseNextPage(info['next'] as String?),
    );
  });

  Future<Result<T>> _getById<T>(
    ResourceType type,
    int id,
    T Function(Json json) fromJson,
  ) => _guard(() async {
    final response = await _dio.get<Json>('/${type.name}/$id');
    return fromJson(response.data!);
  });

  CancelToken _renewToken(ResourceType type) {
    _tokens[type]?.cancel('Superseded by a newer search');
    return _tokens[type] = CancelToken();
  }

  static Future<Result<T>> _guard<T>(Future<T> Function() body) =>
      Result.guard(body, toFailure: mapExceptionToFailure);
}
