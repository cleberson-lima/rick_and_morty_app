import '../../domain/entities/character.dart';
import 'model.dart';

/// `/character` resource.
class CharacterModel extends Model<Character> {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
    this.type = '',
    this.originUrl,
    this.locationUrl,
    this.episodeCount = 0,
  });

  factory CharacterModel.fromJson(Json json) {
    final origin = json['origin']! as Json;
    final location = json['location']! as Json;
    return CharacterModel(
      id: json['id']! as int,
      name: json['name']! as String,
      status: json['status']! as String,
      species: json['species']! as String,
      type: json['type'] as String? ?? '',
      gender: json['gender']! as String,
      originName: origin['name']! as String,
      originUrl: origin['url'] as String?,
      locationName: location['name']! as String,
      locationUrl: location['url'] as String?,
      image: json['image']! as String,
      episodeCount: countOf(json['episode']),
    );
  }

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String originName;
  final String? originUrl;
  final String locationName;
  final String? locationUrl;
  final String image;
  final int episodeCount;

  @override
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
    originName: originName,
    locationName: locationName,
    originId: idFromResourceUrl(originUrl),
    locationId: idFromResourceUrl(locationUrl),
    imageUrl: image,
    episodeCount: episodeCount,
  );
}
