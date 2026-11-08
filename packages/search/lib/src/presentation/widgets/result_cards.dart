import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';

/// Entity → favorite snapshot. Lives in presentation: the domain of `search`
/// doesn't know about favorites.
extension CharacterFavoriteX on Character {
  FavoriteItem toFavorite() => FavoriteItem(
    type: ResourceType.character,
    id: id,
    name: name,
    subtitle: '$species · ${status.label}',
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

Color statusColor(CharacterStatus status) => switch (status) {
  CharacterStatus.alive => const Color(0xFF55CC44),
  CharacterStatus.dead => const Color(0xFFD63D2E),
  CharacterStatus.unknown => const Color(0xFF9E9E9E),
};

class CharacterCard extends StatelessWidget {
  const CharacterCard({required this.character, this.onTap, super.key});

  final Character character;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ResultCard(
      title: character.name,
      subtitle: character.species,
      imageUrl: character.imageUrl,
      footer: StatusChip(
        label: character.status.label,
        color: statusColor(character.status),
      ),
      trailing: FavoriteButton(item: character.toFavorite()),
      onTap: onTap,
    );
  }
}

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({required this.episode, this.onTap, super.key});

  final Episode episode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ResultCard(
      title: episode.name,
      subtitle: episode.code,
      caption: episode.airDate,
      fallbackIcon: Icons.movie_outlined,
      trailing: FavoriteButton(item: episode.toFavorite()),
      onTap: onTap,
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({required this.location, this.onTap, super.key});

  final Location location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ResultCard(
      title: location.name,
      subtitle: location.type.isEmpty ? null : location.type,
      caption: location.dimension.isEmpty ? null : location.dimension,
      fallbackIcon: Icons.public,
      trailing: FavoriteButton(item: location.toFavorite()),
      onTap: onTap,
    );
  }
}
