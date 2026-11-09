import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Name (headline) + heart.
class DetailsTitle extends StatelessWidget {
  const DetailsTitle({required this.text, required this.favorite, super.key});

  final String text;
  final FavoriteItem favorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        FavoriteSlot(item: favorite),
      ],
    );
  }
}
