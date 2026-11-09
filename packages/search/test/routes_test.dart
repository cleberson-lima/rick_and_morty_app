import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:search/search.dart';
import 'package:search/src/data/models/json.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers.dart';

Json _first(String name) =>
    (fixture(name)['results']! as List<Object?>).first! as Json;

/// Answers like the API: lists from the fixtures, and the first item of each
/// fixture for `/<type>/<id>`.
Future<ResponseBody> _api(RequestOptions options) async {
  final segments = options.uri.pathSegments
      .where((segment) => segment.isNotEmpty)
      .toList();
  final type = segments.first;
  final file = '${type}s_page.json';
  return jsonBody(segments.length > 1 ? _first(file) : fixture(file));
}

void main() {
  late FakeAdapter adapter;
  late GoRouter router;
  final opened = <String>[];

  Future<void> pumpAt(WidgetTester tester, String location) async {
    SharedPreferences.setMockInitialValues({});
    adapter = FakeAdapter(_api);
    final core = CoreDependencies(
      preferences: await SharedPreferences.getInstance(),
      dio: dioWith(adapter),
    );
    opened.clear();
    router = GoRouter(
      initialLocation: location,
      routes: [
        ...searchRoutes(core),
        GoRoute(
          path: AppRoutes.favorites,
          builder: (_, _) {
            opened.add(AppRoutes.favorites);
            return const Text('favorites');
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    tester.view.physicalSize = const Size(400, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      BlocProvider<ThemeCubit>(
        create: (_) => ThemeCubit(core.preferences),
        child: FakeFavorites().wrap(
          MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
        ),
      ),
    );
    // Let the requests answer; LoadingSkeleton never settles, so pump in steps.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('/ loads the three unfiltered lists', (tester) async {
    await pumpAt(tester, AppRoutes.search);

    expect(
      adapter.requests.map((r) => r.path),
      containsAll(['/character/', '/episode/', '/location/']),
    );
    expect(find.text('Rick Sanchez'), findsOneWidget);
  });

  testWidgets('a card on the home page pushes its details route', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutes.search);

    await tester.tap(find.text('Rick Sanchez'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(
      router.routerDelegate.currentConfiguration.last.matchedLocation,
      AppRoutes.details(ResourceType.character, 1),
    );
    expect(find.text('Origem'), findsOneWidget);
  });

  testWidgets('/details/:type/:id loads the item and its "Mais" section', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutes.details(ResourceType.episode, 1));

    final paths = adapter.requests.map((r) => r.path).toList();
    expect(paths, contains('/episode/1'));
    expect(paths, contains('/episode/'), reason: '"Mais episódios"');
    expect(find.text('Mais episódios'), findsOneWidget);

    await tester.tap(find.text('Lista de favoritos'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(opened, [AppRoutes.favorites]);
  });

  for (final link in ['/details/planet/1', '/details/character/abc']) {
    testWidgets('$link shows "Link inválido"', (tester) async {
      await pumpAt(tester, link);

      expect(find.text('Link inválido'), findsOneWidget);
      expect(adapter.requests, isEmpty);
    });
  }
}
