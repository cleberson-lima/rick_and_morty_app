import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Colors from the Figma prototype ("Indentity" page and the Dark/White
/// screens).
///
/// The values were sampled from screenshots of the public file, so they are
/// close but not exact. TODO(figma): replace them with the hex codes from the
/// Figma inspector.
abstract final class AppColors {
  /// Brand cyan: logo, "lugar." in the hero, selected chips, hearts.
  static const cyan = Color(0xFF13AEC5);

  /// Lime accent from the identity palette (cover tagline).
  static const lime = Color(0xFF9BD93C);

  // Dark theme.
  static const darkHero = Color(0xFF000000);
  static const darkBackground = Color(0xFF1A1A1A);
  static const darkCard = Color(0xFF262626);
  static const darkChip = Color(0xFF333333);
  static const darkMuted = Color(0xFFB3B3B3);
  static const darkOutline = Color(0xFF3D3D3D);

  // White theme.
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF7F7F7);
  static const lightChip = Color(0xFFEDEDED);
  static const lightText = Color(0xFF333333);
  static const lightMuted = Color(0xFF6B6B6B);
  static const lightOutline = Color(0xFFD9D9D9);
}

/// Palette and typography applied to the whole app.
abstract final class AppTheme {
  /// Inter, bundled in `packages/core/assets/fonts` (weights 400, 500, 700
  /// and 800). Fonts declared by a package are registered as
  /// `packages/<package>/<family>`.
  ///
  /// TODO(figma): confirm the family name in the inspector (looks like Inter).
  static const fontFamily = 'packages/core/Inter';

  static const _radius = 12.0;

  static const _lightScheme = ColorScheme.light(
    primary: AppColors.cyan,
    onPrimary: Colors.white,
    secondary: AppColors.lime,
    onSecondary: AppColors.lightText,
    surface: AppColors.lightBackground,
    onSurface: AppColors.lightText,
    surfaceContainerLow: AppColors.lightCard,
    surfaceContainer: AppColors.lightCard,
    surfaceContainerHigh: AppColors.lightChip,
    surfaceContainerHighest: AppColors.lightChip,
    onSurfaceVariant: AppColors.lightMuted,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutline,
    primaryContainer: Color(0xFFD7F3F7),
    onPrimaryContainer: Color(0xFF075664),
  );

  static const _darkScheme = ColorScheme.dark(
    primary: AppColors.cyan,
    onPrimary: Colors.white,
    secondary: AppColors.lime,
    onSecondary: AppColors.darkBackground,
    surface: AppColors.darkBackground,
    onSurface: Colors.white,
    surfaceContainerLow: AppColors.darkCard,
    surfaceContainer: AppColors.darkCard,
    surfaceContainerHigh: AppColors.darkChip,
    surfaceContainerHighest: AppColors.darkChip,
    onSurfaceVariant: AppColors.darkMuted,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutline,
    primaryContainer: Color(0xFF0B4F59),
    onPrimaryContainer: Color(0xFFBDEFF6),
  );

  static ThemeData light() => _build(_lightScheme);

  static ThemeData dark() => _build(_darkScheme);

  /// Adds the Inter license (SIL OFL 1.1) to the app's license page. Call it
  /// once at startup.
  static void registerFontLicenses() => LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(const [
      'Inter',
    ], await rootBundle.loadString('packages/core/assets/fonts/INTER_LICENSE'));
  });

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: scheme.surface,
    );
    final textTheme = base.textTheme;

    return base.copyWith(
      textTheme: textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
      // Outlined search field with rounded corners, as in the prototype.
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      // Pill chips: grey when idle, cyan when selected ("Escuro", filters).
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primary,
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onPrimary,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 16),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        dividerColor: scheme.outlineVariant,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
