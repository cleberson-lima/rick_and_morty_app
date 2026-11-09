import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Top of the home page: logo, "Lista de favoritos", headline, theme
/// selector and the theme's tagline. Black in dark mode, white with a cyan
/// rule in light mode, as in the prototype.
class HomeHero extends StatelessWidget {
  const HomeHero({this.onOpenFavorites, this.image, super.key});

  final VoidCallback? onOpenFavorites;

  /// Theme illustration (step 2: exported from Figma).
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = context.l10n;
    final headline = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.2,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkHero : scheme.surface,
        border: isDark
            ? null
            : Border(bottom: BorderSide(color: scheme.primary)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: AppLogo()),
                const SizedBox(width: 12),
                PillButton(
                  label: l10n.favoritesList,
                  icon: PhosphorIconsRegular.heart,
                  onPressed: onOpenFavorites,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                text: l10n.homeHeadline,
                children: [
                  TextSpan(
                    text: l10n.homeHeadlineHighlight,
                    style: TextStyle(color: scheme.primary),
                  ),
                ],
              ),
              style: headline,
            ),
            const SizedBox(height: 8),
            Text(l10n.homeSubtitle, style: theme.textTheme.bodyMedium),
            if (image != null) ...[
              const SizedBox(height: 16),
              Center(child: image),
            ],
            const SizedBox(height: 16),
            const ThemeModeSelector(),
            const SizedBox(height: 8),
            Text(
              isDark ? l10n.homeTaglineDark : l10n.homeTaglineLight,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
