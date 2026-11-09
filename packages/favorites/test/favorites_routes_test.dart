import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_storage_test.dart' show rick;

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

late SharedPreferences _preferences;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    _preferences = await SharedPreferences.getInstance();
  });

  testWidgets('favoritesRoute shows the list and opens details', (
    tester,
  ) async {
    final cubit = _FavoritesCubit();
    when(
      () => cubit.state,
    ).thenReturn(const FavoritesState.loaded(items: [rick]));
    final opened = <String>[];
    final router = GoRouter(
      initialLocation: AppRoutes.favorites,
      routes: [
        favoritesRoute(),
        GoRoute(
          path: AppRoutes.detailsPattern,
          builder: (_, state) {
            opened.add(state.uri.path);
            return const Text('details');
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoritesCubit>.value(value: cubit),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(_preferences)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    expect(find.text('Favoritos'), findsOneWidget);

    await tester.tap(find.text('Rick Sanchez'));
    await tester.pumpAndSettle();

    expect(opened, [AppRoutes.details(ResourceType.character, 1)]);
  });

  test('FavoritesCubit loads from FavoritesStorage', () async {
    final cubit = FavoritesCubit(FavoritesStorage(_preferences));
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, const FavoritesState.loaded(items: []));
  });

  testWidgets('FavoritesErrorListener shows a snackbar on write errors', (
    tester,
  ) async {
    final cubit = _FavoritesCubit();
    whenListen(
      cubit,
      Stream.fromIterable(const [
        FavoritesState.loaded(items: [rick]),
        FavoritesState.loaded(items: [rick], actionFailure: Failure.cache()),
      ]),
      initialState: const FavoritesState.loading(),
    );

    await tester.pumpWidget(
      BlocProvider<FavoritesCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: FavoritesErrorListener(child: Scaffold(body: Text('home'))),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.text('Não foi possível acessar os dados salvos.'),
      findsOneWidget,
    );
  });
}
