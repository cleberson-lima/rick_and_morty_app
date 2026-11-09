import 'package:freezed_annotation/freezed_annotation.dart';

import 'json.dart';

part 'character.freezed.dart';

/// Status as the API reports it; its name on screen comes from
/// `CharacterLabels.statusLabel`.
enum CharacterStatus {
  alive,
  dead,
  unknown;

  static CharacterStatus parse(String? value) => switch (value?.toLowerCase()) {
    'alive' => alive,
    'dead' => dead,
    _ => unknown,
  };
}

/// `/character` resource.
@Freezed(fromJson: false, toJson: false)
abstract class Character with _$Character {
  const factory Character({
    required int id,
    required String name,
    required CharacterStatus status,
    required String species,
    @Default('') String type,
    required String gender,
    required String originName,
    required String locationName,

    /// Ids of the origin / last location, or `null` when unknown.
    int? originId,
    int? locationId,
    required String imageUrl,
    @Default(0) int episodeCount,
  }) = _Character;

  factory Character.fromJson(Json json) {
    final origin = json['origin']! as Json;
    final location = json['location']! as Json;
    return Character(
      id: json['id']! as int,
      name: json['name']! as String,
      status: CharacterStatus.parse(json['status'] as String?),
      species: json['species']! as String,
      type: json['type'] as String? ?? '',
      gender: json['gender']! as String,
      originName: origin['name']! as String,
      originId: idFromResourceUrl(origin['url'] as String?),
      locationName: location['name']! as String,
      locationId: idFromResourceUrl(location['url'] as String?),
      imageUrl: json['image']! as String,
      episodeCount: countOf(json['episode']),
    );
  }
}
