import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../cards/cards.dart';
import 'details_attribute.dart';
import 'details_title.dart';

/// Location page header: name + heart, type, dimension and residents.
class LocationDetailsHeader extends StatelessWidget {
  const LocationDetailsHeader({required this.location, super.key});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(PhosphorIconsRegular.planet, size: 32),
        const SizedBox(height: 8),
        DetailsTitle(text: location.name, favorite: location.toFavorite()),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (location.type.isNotEmpty)
              DetailsAttribute(
                icon: PhosphorIconsRegular.planet,
                text: location.type,
              ),
            if (location.dimension.isNotEmpty)
              DetailsAttribute(
                icon: PhosphorIconsRegular.mapPin,
                text: location.dimension,
              ),
          ],
        ),
        const SizedBox(height: 12),
        DetailsAttribute(
          icon: PhosphorIconsRegular.users,
          text: context.l10n.residentCount(location.residentCount),
        ),
      ],
    );
  }
}
