import 'character_model.dart';
import 'episode_model.dart';
import 'location_model.dart';

/// JSON object as decoded by Dio.
typedef Json = Map<String, Object?>;

/// Base class of the API models: each one reads its JSON in its own
/// `fromJson` factory and turns itself into a domain entity with
/// [toEntity].
///
/// Dart does not inherit static methods or constructors, so every model
/// declares its own `factory X.fromJson`. [Model.fromJson] is the single
/// entry point that picks the right one from the type, which is what lets
/// [PageModel] parse `results` without being told how.
abstract class Model<E> {
  const Model();

  E toEntity();

  /// Builds the model [T] from [json]:
  /// `Model.fromJson<CharacterModel>(json)`.
  static T fromJson<T extends Model<Object?>>(Json json) {
    final Model<Object?> model = switch (T) {
      const (CharacterModel) => CharacterModel.fromJson(json),
      const (EpisodeModel) => EpisodeModel.fromJson(json),
      const (LocationModel) => LocationModel.fromJson(json),
      _ => throw ArgumentError.value(T, 'T', 'No fromJson registered'),
    };
    return model as T;
  }
}

/// Extracts the trailing id from a resource URL
/// (`https://rickandmortyapi.com/api/location/3` → 3). Empty or missing
/// URLs (unknown origin) give `null`.
int? idFromResourceUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final segments = Uri.tryParse(url)?.pathSegments.where((s) => s.isNotEmpty);
  return segments == null || segments.isEmpty
      ? null
      : int.tryParse(segments.last);
}

/// Number of items in a JSON list of URLs (`episode`, `characters`,
/// `residents`); a missing list counts as empty.
int countOf(Object? list) => (list as List<Object?>?)?.length ?? 0;
