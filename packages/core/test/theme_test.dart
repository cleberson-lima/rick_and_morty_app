import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppTheme follows the prototype palette', () {
    test('cyan is the primary color in both themes', () {
      expect(
        AppTheme.light(useGoogleFonts: false).colorScheme.primary,
        AppColors.cyan,
      );
      expect(
        AppTheme.dark(useGoogleFonts: false).colorScheme.primary,
        AppColors.cyan,
      );
    });

    test('backgrounds and text match each theme', () {
      final light = AppTheme.light(useGoogleFonts: false);
      final dark = AppTheme.dark(useGoogleFonts: false);

      expect(light.scaffoldBackgroundColor, AppColors.lightBackground);
      expect(light.colorScheme.onSurface, AppColors.lightText);
      expect(light.cardTheme.color, AppColors.lightCard);
      expect(dark.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(dark.colorScheme.onSurface, Colors.white);
      expect(dark.cardTheme.color, AppColors.darkCard);
    });
  });

  group('ThemeModeSelector', () {
    late ThemeCubit cubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      cubit = ThemeCubit(await SharedPreferences.getInstance());
    });

    Future<void> pump(WidgetTester tester, ThemeMode mode) async {
      await cubit.setMode(mode);
      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, mode) => MaterialApp(
              theme: AppTheme.light(useGoogleFonts: false),
              darkTheme: AppTheme.dark(useGoogleFonts: false),
              themeMode: mode,
              home: const Scaffold(body: ThemeModeSelector()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    bool selected(WidgetTester tester, String label) => tester
        .widget<ChoiceChip>(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(ChoiceChip),
          ),
        )
        .selected;

    testWidgets('highlights the theme on screen and switches it', (
      tester,
    ) async {
      await pump(tester, ThemeMode.light);
      expect(selected(tester, 'Claro'), isTrue);
      expect(selected(tester, 'Escuro'), isFalse);

      await tester.tap(find.text('Escuro'));
      await tester.pumpAndSettle();

      expect(cubit.state, ThemeMode.dark);
      expect(selected(tester, 'Escuro'), isTrue);

      await tester.tap(find.text('Claro'));
      await tester.pumpAndSettle();
      expect(cubit.state, ThemeMode.light);
    });
  });
}
