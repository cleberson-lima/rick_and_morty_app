import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';

import '../open_details.dart';

/// Small origin / last-location card on the character page.
class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.icon,
    required this.caption,
    required this.name,
    required this.id,
    this.onOpenDetails,
    super.key,
  });

  final IconData icon;
  final String caption;
  final String name;
  final int? id;
  final OpenDetails? onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final id = this.id;
    return SizedBox(
      width: 150,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
          child: Column(
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 4),
              Text(caption, style: theme.textTheme.labelMedium),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              if (id != null) ...[
                DetailsChipButton(
                  onPressed: () =>
                      onOpenDetails?.call(ResourceType.location, id),
                ),
                FavoriteButton(
                  compact: true,
                  item: FavoriteItem(
                    type: ResourceType.location,
                    id: id,
                    name: name,
                  ),
                ),
              ] else
                const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
