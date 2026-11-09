import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/l10n.dart';
import 'theme_cubit.dart';

/// "Escuro / Claro" pill pair from the prototype's hero. The highlighted chip
/// follows the theme actually on screen, so it is right even while the app
/// still follows the system setting.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<ThemeCubit>();
    return Wrap(
      spacing: 8,
      children: [
        _ModeChip(
          label: context.l10n.themeDark,
          icon: Icons.dark_mode_outlined,
          selected: isDark,
          onSelected: () => cubit.setMode(ThemeMode.dark),
        ),
        _ModeChip(
          label: context.l10n.themeLight,
          icon: Icons.light_mode_outlined,
          selected: !isDark,
          onSelected: () => cubit.setMode(ThemeMode.light),
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      avatar: Icon(icon, size: 16, color: foreground),
      label: Text(label, style: TextStyle(color: foreground)),
      tooltip: context.l10n.themeTooltip(label.toLowerCase()),
    );
  }
}
