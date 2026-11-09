import 'package:freezed_annotation/freezed_annotation.dart';

import 'json.dart';

part 'location.freezed.dart';

/// `/location` resource.
@Freezed(fromJson: false, toJson: false)
abstract class Location with _$Location {
  const factory Location({
    required int id,
    required String name,
    @Default('') String type,
    @Default('') String dimension,
    @Default(0) int residentCount,
  }) = _Location;

  factory Location.fromJson(Json json) => Location(
    id: json['id']! as int,
    name: json['name']! as String,
    type: json['type'] as String? ?? '',
    dimension: json['dimension'] as String? ?? '',
    residentCount: countOf(json['residents']),
  );
}
