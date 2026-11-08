import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';

@freezed
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
}
