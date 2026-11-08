import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';

enum CharacterStatus {
  alive('Vivo'),
  dead('Morto'),
  unknown('Desconhecido');

  const CharacterStatus(this.label);

  final String label;
}

@freezed
abstract class Character with _$Character {
  const factory Character({
    required int id,
    required String name,
    required CharacterStatus status,
    required String species,
    required String type,
    required String gender,
    required String originName,
    required String locationName,

    /// Ids of the origin / last location, or `null` when unknown.
    int? originId,
    int? locationId,
    required String imageUrl,
    required int episodeCount,
  }) = _Character;
}
