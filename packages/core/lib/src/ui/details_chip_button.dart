import 'package:flutter/material.dart';

import '../strings/app_strings.dart';
import 'phosphor_icons.dart';

/// Pill-shaped button with a small icon, used across the prototype:
/// "Lista de favoritos", "Ver todos", "Saiba mais". Cyan when [filled],
/// grey otherwise.
///
/// Material's ActionChip clips its label when it has an avatar, so this is a
/// plain InkWell with an explicit layout.
class PillButton extends StatelessWidget {
  const PillButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = true,
    this.dense = false,
    this.tooltip,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool dense;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = filled ? scheme.onPrimary : scheme.onSurface;
    final textStyle =
        (dense ? theme.textTheme.labelSmall : theme.textTheme.labelMedium)
            ?.copyWith(color: foreground);
    final button = Material(
      color: filled ? scheme.primary : scheme.surfaceContainerHighest,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: Padding(
          padding: dense
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: dense ? 14 : 16, color: foreground),
              const SizedBox(width: 6),
              // Shrinks with an ellipsis on very narrow cards / large fonts.
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}

/// The small "ⓘ Saiba mais" pill on every card.
class DetailsChipButton extends StatelessWidget {
  const DetailsChipButton({
    required this.onPressed,
    this.label,
    this.highlighted = false,
    super.key,
  });

  final VoidCallback? onPressed;

  /// Defaults to "Saiba mais".
  final String? label;

  /// Cyan fill instead of grey (the prototype highlights the focused card).
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return PillButton(
      label: label ?? AppStrings.learnMore,
      icon: PhosphorIconsRegular.info,
      onPressed: onPressed,
      filled: highlighted,
      dense: true,
    );
  }
}
