import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';

part 'api_models.freezed.dart';
part 'api_models.g.dart';

/// `info` block of every paginated response.
@freezed
abstract class InfoModel with _$InfoModel {
  const factory InfoModel({
    required int count,
    required int pages,
    String? next,
    String? prev,
  }) = _InfoModel;

  factory InfoModel.fromJson(Map<String, Object?> json) =>
      _$InfoModelFromJson(json);
}

@Freezed(genericArgumentFactories: true)
abstract class PageModel<T> with _$PageModel<T> {
  const factory PageModel({required InfoModel info, required List<T> results}) =
      _PageModel<T>;

  factory PageModel.fromJson(
    Map<String, Object?> json,
    T Function(Object?) fromJsonT,
  ) => _$PageModelFromJson(json, fromJsonT);
}

/// `{ "name": ..., "url": ... }` reference used for origin and location.
@freezed
abstract class NamedRefModel with _$NamedRefModel {
  const factory NamedRefModel({required String name, String? url}) =
      _NamedRefModel;

  factory NamedRefModel.fromJson(Map<String, Object?> json) =>
      _$NamedRefModelFromJson(json);
}

@freezed
abstract class CharacterModel with _$CharacterModel {
  const CharacterModel._();

  const factory CharacterModel({
    required int id,
    required String name,
    required String status,
    required String species,
    @Default('') String type,
    required String gender,
    required NamedRefModel origin,
    required NamedRefModel location,
    required String image,
    @Default(<String>[]) List<String> episode,
  }) = _CharacterModel;

  factory CharacterModel.fromJson(Map<String, Object?> json) =>
      _$CharacterModelFromJson(json);

  Character toEntity() => Character(
    id: id,
    name: name,
    status: switch (status.toLowerCase()) {
      'alive' => CharacterStatus.alive,
      'dead' => CharacterStatus.dead,
      _ => CharacterStatus.unknown,
    },
    species: species,
    type: type,
    gender: gender,
    originName: origin.name,
    locationName: location.name,
    imageUrl: image,
    episodeCount: episode.length,
  );
}

@freezed
abstract class EpisodeModel with _$EpisodeModel {
  const EpisodeModel._();

  const factory EpisodeModel({
    required int id,
    required String name,
    @JsonKey(name: 'air_date') required String airDate,
    required String episode,
    @Default(<String>[]) List<String> characters,
  }) = _EpisodeModel;

  factory EpisodeModel.fromJson(Map<String, Object?> json) =>
      _$EpisodeModelFromJson(json);

  Episode toEntity() => Episode(
    id: id,
    name: name,
    airDate: airDate,
    code: episode,
    characterCount: characters.length,
  );
}

@freezed
abstract class LocationModel with _$LocationModel {
  const LocationModel._();

  const factory LocationModel({
    required int id,
    required String name,
    @Default('') String type,
    @Default('') String dimension,
    @Default(<String>[]) List<String> residents,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, Object?> json) =>
      _$LocationModelFromJson(json);

  Location toEntity() => Location(
    id: id,
    name: name,
    type: type,
    dimension: dimension,
    residentCount: residents.length,
  );
}
