import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../cards/cards.dart';
import 'details_attribute.dart';
import 'details_title.dart';

/// Episode page header: name + heart, air date, code and cast size.
class EpisodeDetailsHeader extends StatelessWidget {
  const EpisodeDetailsHeader({required this.episode, super.key});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(PhosphorIconsRegular.monitorPlay, size: 32),
        const SizedBox(height: 8),
        DetailsTitle(text: episode.name, favorite: episode.toFavorite()),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            DetailsAttribute(
              icon: PhosphorIconsRegular.calendarBlank,
              text: episode.airDate,
            ),
            DetailsAttribute(
              icon: PhosphorIconsRegular.queue,
              text: episode.code,
            ),
          ],
        ),
        const SizedBox(height: 12),
        DetailsAttribute(
          icon: PhosphorIconsRegular.users,
          text: context.l10n.charactersInEpisode(episode.characterCount),
        ),
      ],
    );
  }
}
