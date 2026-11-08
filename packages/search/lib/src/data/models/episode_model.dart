import '../../domain/entities/episode.dart';
import 'model.dart';

/// `/episode` resource.
class EpisodeModel extends Model<Episode> {
  const EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    this.characterCount = 0,
  });

  factory EpisodeModel.fromJson(Json json) => EpisodeModel(
    id: json['id']! as int,
    name: json['name']! as String,
    airDate: json['air_date']! as String,
    episode: json['episode']! as String,
    characterCount: countOf(json['characters']),
  );

  final int id;
  final String name;
  final String airDate;

  /// Episode code, e.g. `S01E01`.
  final String episode;
  final int characterCount;

  @override
  Episode toEntity() => Episode(
    id: id,
    name: name,
    airDate: airDate,
    code: episode,
    characterCount: characterCount,
  );
}
