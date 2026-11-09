import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'character_labels.dart';
import 'favorite_snapshots.dart';

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
