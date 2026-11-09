import 'package:core/core.dart';

import '../../../data/models/models.dart';
import 'character_labels.dart';

/// Model → favorite snapshot. Lives in presentation: the models of `search`
/// don't know about favorites.
extension CharacterFavoriteX on Character {
  /// [l10n] names the species and status in the saved subtitle.
  FavoriteItem toFavorite(AppLocalizations l10n) => FavoriteItem(
    type: ResourceType.character,
    id: id,
    name: name,
    subtitle: '${l10n.speciesLabel(species)} · ${l10n.statusLabel(status)}',
    imageUrl: imageUrl,
  );
}

extension EpisodeFavoriteX on Episode {
  FavoriteItem toFavorite() => FavoriteItem(
    type: ResourceType.episode,
    id: id,
    name: name,
    subtitle: '$code · $airDate',
  );
}

extension LocationFavoriteX on Location {
  FavoriteItem toFavorite() => FavoriteItem(
    type: ResourceType.location,
    id: id,
    name: name,
    subtitle: [type, dimension].where((s) => s.isNotEmpty).join(' · '),
  );
}
