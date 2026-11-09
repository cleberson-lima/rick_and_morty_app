import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'favorite_snapshots.dart';

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
