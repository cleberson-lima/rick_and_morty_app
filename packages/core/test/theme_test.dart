import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('bundled Inter font', () {
    test('every text style of both themes uses it', () {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        final textTheme = theme.textTheme;
        for (final style in [
          textTheme.displayLarge,
          textTheme.headlineMedium,
          textTheme.titleLarge,
          textTheme.titleMedium,
          textTheme.bodyMedium,
          textTheme.labelLarge,
          theme.appBarTheme.titleTextStyle,
        ]) {
          expect(style?.fontFamily, AppTheme.fontFamily);
        }
      }
      expect(AppTheme.fontFamily, 'packages/core/Inter');
    });

    test('ships a file for every weight the app uses', () {
      for (final name in ['Regular', 'Medium', 'Bold', 'ExtraBold']) {
        expect(
          File('assets/fonts/Inter-$name.ttf').existsSync(),
          isTrue,
          reason: 'Inter-$name.ttf',
        );
      }
      final pubspec = File('pubspec.yaml').readAsStringSync();
      for (final weight in [400, 500, 700, 800]) {
        expect(pubspec, contains('weight: $weight'));
      }
    });

    testWidgets('the asset loads and renders under the theme family', (
      tester,
    ) async {
      double widthOf(String family) {
        final painter = TextPainter(
          text: TextSpan(
            text: 'Rick Sanchez',
            style: TextStyle(fontFamily: family, fontSize: 20),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        return painter.width;
      }

      // Unloaded families fall back to the test font, where every glyph is
      // exactly fontSize wide: 12 characters → 240.
      expect(widthOf(AppTheme.fontFamily), 240);

      await tester.runAsync(() async {
        final bytes = File('assets/fonts/Inter-Regular.ttf').readAsBytes();
        await (FontLoader(
          AppTheme.fontFamily,
        )..addFont(bytes.then(ByteData.sublistView))).load();
      });

      expect(widthOf(AppTheme.fontFamily), isNot(240));
    });

    test('registerFontLicenses adds the Inter license', () async {
      AppTheme.registerFontLicenses();

      final inter = await LicenseRegistry.licenses
          .where((entry) => entry.packages.contains('Inter'))
          .first;
      final text = inter.paragraphs.map((p) => p.text).join('\n');

      expect(text, contains('SIL Open Font License'));
    });
  });

  group('AppTheme follows the prototype palette', () {
    test('cyan is the primary color in both themes', () {
      expect(AppTheme.light().colorScheme.primary, AppColors.cyan);
      expect(AppTheme.dark().colorScheme.primary, AppColors.cyan);
    });

    test('backgrounds and text match each theme', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

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
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
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
