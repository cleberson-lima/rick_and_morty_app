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
    subtitle: '${speciesLabel(species)} · ${status.label}',
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

/// The prototype shows species in Portuguese ("Humano"). Unknown values from
/// the API are shown as they come.
String speciesLabel(String species) => switch (species.toLowerCase()) {
  'human' => 'Humano',
  'alien' => 'Alienígena',
  'humanoid' => 'Humanoide',
  'robot' => 'Robô',
  'animal' => 'Animal',
  'mythological creature' => 'Criatura mitológica',
  'disease' => 'Doença',
  'unknown' => 'Desconhecido',
  _ => species,
};

/// Card sizes for [ResponsiveResultsView] (tile height, max tile width).
abstract final class CardSizes {
  static const characterHeight = 300.0;
  static const characterMaxWidth = 220.0;
  static const episodeHeight = 96.0;
  // One column on phones (the "Name | S01E01" title needs the width).
  static const episodeMaxWidth = 420.0;
  static const locationHeight = 176.0;
  // Two columns on phones, so "Saiba mais" fits.
  static const locationMaxWidth = 190.0;
}

/// Vertical character card: image, name + heart, status / species / origin
/// with icons and "Saiba mais".
class CharacterCard extends StatelessWidget {
  const CharacterCard({required this.character, this.onTap, super.key});

  final Character character;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(url: character.imageUrl, width: 220),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      character.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FavoriteButton(item: character.toFavorite(), compact: true),
                ],
              ),
              _IconLine(
                icon: PhosphorIconsRegular.heartbeat,
                iconColor: statusColor(character.status),
                text: character.status.label,
              ),
              _IconLine(
                icon: PhosphorIconsRegular.alien,
                text: speciesLabel(character.species),
              ),
              _IconLine(
                icon: PhosphorIconsRegular.planet,
                text: character.originName,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: DetailsChipButton(onPressed: onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact episode card: "Name | S01E01", "Saiba mais" and heart.
class EpisodeCard extends StatelessWidget {
  const EpisodeCard({required this.episode, this.onTap, super.key});

  final Episode episode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(PhosphorIconsRegular.monitorPlay, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${episode.name} | ${episode.code}',
                      style: Theme.of(context).textTheme.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: DetailsChipButton(onPressed: onTap)),
                  FavoriteButton(item: episode.toFavorite(), compact: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Location card: planet icon, type, name in cyan, "Saiba mais" and heart.
class LocationCard extends StatelessWidget {
  const LocationCard({required this.location, this.onTap, super.key});

  final Location location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = location.type.isNotEmpty
        ? location.type
        : location.dimension;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 2),
          child: Column(
            children: [
              const Icon(PhosphorIconsRegular.planet, size: 30),
              const SizedBox(height: 4),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                location.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              DetailsChipButton(onPressed: onTap),
              FavoriteButton(item: location.toFavorite(), compact: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text, this.iconColor});

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
