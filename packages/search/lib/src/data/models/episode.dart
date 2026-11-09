import 'package:freezed_annotation/freezed_annotation.dart';

import 'json.dart';

part 'episode.freezed.dart';

/// `/episode` resource.
@Freezed(fromJson: false, toJson: false)
abstract class Episode with _$Episode {
  const factory Episode({
    required int id,
    required String name,

    /// Air date as the API sends it, e.g. "December 2, 2013".
    required String airDate,

    /// Season/episode code, e.g. "S01E01".
    required String code,
    required int characterCount,
  }) = _Episode;

  factory Episode.fromJson(Json json) => Episode(
    id: json['id']! as int,
    name: json['name']! as String,
    airDate: json['air_date']! as String,
    code: json['episode']! as String,
    characterCount: countOf(json['characters']),
  );
}
