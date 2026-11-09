import 'package:auto_injector/auto_injector.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:favorites/src/data/datasources/favorites_local_data_source.dart';
import 'package:favorites/src/domain/repositories/favorites_repository.dart';
import 'package:favorites/src/domain/usecases/favorites_usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_data_test.dart' show pilot, rick;

class _MockRepository extends Mock implements FavoritesRepository {}

class _MockPrefs extends Mock implements SharedPreferences {}

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

void main() {
  group('use cases delegate to the repository', () {
    late _MockRepository repository;

    setUp(() => repository = _MockRepository());

    test('get, add and remove', () async {
      when(repository.getAll).thenAnswer((_) async => const Right([rick]));
      when(
        () => repository.add(pilot),
      ).thenAnswer((_) async => const Right([pilot, rick]));
      when(
        () => repository.remove(ResourceType.character, 1),
      ).thenAnswer((_) async => const Right([]));

      expect(
        await GetFavoritesUseCase(repository)(),
        const Right<Failure, List<FavoriteItem>>([rick]),
      );
      expect(
        await AddFavoriteUseCase(repository)(pilot),
        const Right<Failure, List<FavoriteItem>>([pilot, rick]),
      );
      expect(
        await RemoveFavoriteUseCase(repository)(ResourceType.character, 1),
        const Right<Failure, List<FavoriteItem>>([]),
      );
    });
  });

  test('data source throws when SharedPreferences refuses to save', () async {
    final prefs = _MockPrefs();
    when(() => prefs.setString(any(), any())).thenAnswer((_) async => false);

    await expectLater(
      FavoritesLocalDataSourceImpl(prefs).write(const []),
      throwsStateError,
    );
  });

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
