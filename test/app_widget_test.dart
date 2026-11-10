import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_app/app/app_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _emptyPage = <String, Object?>{
  'info': {'count': 0, 'next': null},
  'results': <Object?>[],
};

const _pilot = <String, Object?>{
  'id': 1,
  'name': 'Pilot',
  'air_date': 'December 2, 2013',
  'episode': 'S01E01',
  'characters': <Object?>[],
};

/// Dio that answers without network: episode 1 for `/episode/1`, an empty
/// page for everything else.
Dio _offlineApi(List<String> requested) =>
    Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requested.add(options.path);
            handler.resolve(
              Response<Map<String, Object?>>(
                requestOptions: options,
                statusCode: 200,
                data: options.path == '/episode/1' ? _pilot : _emptyPage,
              ),
            );
          },
        ),
      );

void main() {
  late List<String> requested;
  late CoreDependencies core;

  Future<void> pumpApp(
    WidgetTester tester, {
    Map<String, Object> stored = const {},
    String? initialLocation,
  }) async {
    SharedPreferences.setMockInitialValues(stored);
    requested = [];
    core = CoreDependencies(
      preferences: await SharedPreferences.getInstance(),
      dio: _offlineApi(requested),
    );
    tester.view.physicalSize = const Size(400, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      AppWidget(core: core, initialLocation: initialLocation),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('starts on the home page and loads the three lists', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(requested, containsAll(['/character/', '/episode/', '/location/']));
    expect(find.text('Lista de favoritos'), findsOneWidget);
  });

  testWidgets('runs in Portuguese, Material strings included', (tester) async {
    await pumpApp(tester);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('pt'));
    final context = tester.element(find.text('Lista de favoritos'));
    expect(MaterialLocalizations.of(context).backButtonTooltip, 'Voltar');
  });

  testWidgets('warns on every screen while showing saved data', (tester) async {
    await pumpApp(tester);
    expect(find.text(AppStrings.offlineBanner), findsNothing);

    core.offlineStatus.value = true;
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(AppStrings.offlineBanner), findsOneWidget);

    await tester.tap(find.text('Lista de favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text(AppStrings.offlineBanner), findsOneWidget);
  });

  testWidgets('restores the saved theme', (tester) async {
    await pumpApp(tester, stored: {ThemeCubit.storageKey: 'dark'});

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });

  testWidgets('"Lista de favoritos" opens the favorites route', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Lista de favoritos'));
    await tester.pumpAndSettle();

    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
  });

  testWidgets('saved favorites load at startup and hearts are real buttons', (
    tester,
  ) async {
    await pumpApp(
      tester,
      initialLocation: AppRoutes.favorites,
      stored: {
        FavoritesStorage.storageKey:
            '[{"type":"episode","id":1,"name":"Pilot",'
            '"subtitle":null,"imageUrl":null}]',
      },
    );

    expect(find.text('Pilot'), findsOneWidget);
    expect(find.byType(FavoriteButton), findsNothing, reason: 'list tiles');

    // A details page puts a FavoriteSlot next to the name, and the provider
    // at the root turns it into the favorites package's button.
    await tester.tap(find.text('Pilot'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(requested, contains('/episode/1'));
    expect(find.text('S01E01'), findsOneWidget);
    expect(find.byType(FavoriteButton), findsOneWidget);
    // Pilot is saved, so the heart on its page is already filled.
    expect(
      find.descendant(
        of: find.byType(FavoriteButton),
        matching: find.byTooltip('Remover dos favoritos'),
      ),
      findsOneWidget,
    );
  });
}
