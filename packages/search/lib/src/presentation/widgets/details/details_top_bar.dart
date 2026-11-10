import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Back arrow, logo and "Lista de favoritos" (same as the home hero row).
class DetailsTopBar extends StatelessWidget {
  const DetailsTopBar({this.onOpenFavorites, super.key});

  final VoidCallback? onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: AppStrings.back,
            icon: const Icon(PhosphorIconsRegular.caretLeft),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: AppLogo()),
          const SizedBox(width: 12),
          PillButton(
            label: AppStrings.favoritesList,
            icon: PhosphorIconsRegular.heart,
            onPressed: onOpenFavorites,
          ),
        ],
      ),
    );
  }
}
