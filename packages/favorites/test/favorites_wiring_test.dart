import 'package:auto_injector/auto_injector.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_storage_test.dart' show rick;

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

void main() {
  test('FavoritesDataModule wires an app-wide FavoritesCubit', () async {
    SharedPreferences.setMockInitialValues({});
    await CoreModule.initialize();

    final injector = AutoInjector();
    CoreModule().exportedBinds(injector);
    FavoritesDataModule().exportedBinds(injector);
    injector.commit();

    final cubit = injector.get<FavoritesCubit>();
    expect(identical(cubit, injector.get<FavoritesCubit>()), isTrue);

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
