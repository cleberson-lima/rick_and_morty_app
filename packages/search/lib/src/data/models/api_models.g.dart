// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InfoModel _$InfoModelFromJson(Map<String, dynamic> json) => _InfoModel(
  count: (json['count'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$InfoModelToJson(_InfoModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pages': instance.pages,
      'next': instance.next,
      'prev': instance.prev,
    };

_PageModel<T> _$PageModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PageModel<T>(
  info: InfoModel.fromJson(json['info'] as Map<String, dynamic>),
  results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$PageModelToJson<T>(
  _PageModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'info': instance.info,
  'results': instance.results.map(toJsonT).toList(),
};

_NamedRefModel _$NamedRefModelFromJson(Map<String, dynamic> json) =>
    _NamedRefModel(name: json['name'] as String, url: json['url'] as String?);

Map<String, dynamic> _$NamedRefModelToJson(_NamedRefModel instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url};

_CharacterModel _$CharacterModelFromJson(
  Map<String, dynamic> json,
) => _CharacterModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  status: json['status'] as String,
  species: json['species'] as String,
  type: json['type'] as String? ?? '',
  gender: json['gender'] as String,
  origin: NamedRefModel.fromJson(json['origin'] as Map<String, dynamic>),
  location: NamedRefModel.fromJson(json['location'] as Map<String, dynamic>),
  image: json['image'] as String,
  episode:
      (json['episode'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$CharacterModelToJson(_CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'species': instance.species,
      'type': instance.type,
      'gender': instance.gender,
      'origin': instance.origin,
      'location': instance.location,
      'image': instance.image,
      'episode': instance.episode,
    };

_EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) =>
    _EpisodeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episode: json['episode'] as String,
      characters:
          (json['characters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$EpisodeModelToJson(_EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'air_date': instance.airDate,
      'episode': instance.episode,
      'characters': instance.characters,
    };

_LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    _LocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String? ?? '',
      dimension: json['dimension'] as String? ?? '',
      residents:
          (json['residents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$LocationModelToJson(_LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'dimension': instance.dimension,
      'residents': instance.residents,
    };
