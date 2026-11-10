import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../cards/cards.dart';
import '../open_details.dart';
import 'details_attribute.dart';
import 'details_title.dart';
import 'place_card.dart';

/// Character page header: image, name + heart, attributes and the origin /
/// last-location cards. Side by side on wide screens.
class CharacterDetailsHeader extends StatelessWidget {
  const CharacterDetailsHeader({
    required this.character,
    this.onOpenDetails,
    super.key,
  });

  final Character character;
  final OpenDetails? onOpenDetails;

  IconData get _genderIcon => switch (character.gender.toLowerCase()) {
    'male' => PhosphorIconsRegular.genderMale,
    'female' => PhosphorIconsRegular.genderFemale,
    'genderless' => PhosphorIconsRegular.genderIntersex,
    _ => PhosphorIconsRegular.question,
  };

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AppNetworkImage(url: character.imageUrl, width: 220, height: 220),
    );
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsTitle(text: character.name, favorite: character.toFavorite()),
        DetailsAttribute(
          icon: PhosphorIconsRegular.monitorPlay,
          text: AppStrings.episodeCountOfCharacter(character.episodeCount),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            DetailsAttribute(
              icon: PhosphorIconsRegular.heartbeat,
              color: statusColor(character.status),
              text: statusLabel(character.status),
            ),
            DetailsAttribute(
              icon: PhosphorIconsRegular.alien,
              text: speciesLabel(character.species),
            ),
            DetailsAttribute(icon: _genderIcon, text: character.gender),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            PlaceCard(
              icon: PhosphorIconsRegular.planet,
              caption: AppStrings.origin,
              name: character.originName,
              id: character.originId,
              onOpenDetails: onOpenDetails,
            ),
            PlaceCard(
              icon: PhosphorIconsRegular.mapPin,
              caption: AppStrings.lastLocation,
              name: character.locationName,
              id: character.locationId,
              onOpenDetails: onOpenDetails,
            ),
          ],
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth >= Breakpoints.compact
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image,
                const SizedBox(width: 24),
                Expanded(child: info),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [image, const SizedBox(height: 16), info],
            ),
    );
  }
}
