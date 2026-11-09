import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'favorite_snapshots.dart';

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
              FavoriteSlot(item: location.toFavorite(), compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
