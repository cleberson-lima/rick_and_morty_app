import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../strings/app_strings.dart';
import 'theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark
          ? AppStrings.switchToLightTheme
          : AppStrings.switchToDarkTheme,
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => context.read<ThemeCubit>().toggle(
        MediaQuery.platformBrightnessOf(context),
      ),
    );
  }
}
