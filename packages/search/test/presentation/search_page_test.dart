import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/domain/entities/character.dart';
import 'package:search/src/domain/entities/episode.dart';
import 'package:search/src/domain/entities/location.dart';
import 'package:search/src/presentation/bloc/search_bloc.dart';
import 'package:search/src/presentation/bloc/search_event.dart';
import 'package:search/src/presentation/bloc/search_state.dart';
import 'package:search/src/presentation/pages/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_data.dart';

class _CharacterBloc extends MockBloc<SearchEvent, SearchState<Character>>
    implements SearchBloc<Character> {}

class _EpisodeBloc extends MockBloc<SearchEvent, SearchState<Episode>>
    implements SearchBloc<Episode> {}

class _LocationBloc extends MockBloc<SearchEvent, SearchState<Location>>
    implements SearchBloc<Location> {}

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

void main() {
  late _CharacterBloc characters;
  late _EpisodeBloc episodes;
  late _LocationBloc locations;
  late _FavoritesCubit favorites;
  late ThemeCubit theme;

  setUpAll(() => registerFallbackValue(const SearchSubmitted('')));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    theme = ThemeCubit(await SharedPreferences.getInstance());
    characters = _CharacterBloc();
    episodes = _EpisodeBloc();
    locations = _LocationBloc();
    favorites = _FavoritesCubit();
    when(() => episodes.state).thenReturn(const SearchState.initial());
    when(() => locations.state).thenReturn(const SearchState.initial());
    when(
      () => favorites.state,
    ).thenReturn(const FavoritesState.loaded(items: []));
  });

  Future<void> pump(
    WidgetTester tester,
    SearchState<Character> state, {
    void Function(ResourceType, int)? onOpen,
  }) async {
    when(() => characters.state).thenReturn(state);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: theme),
          BlocProvider<FavoritesCubit>.value(value: favorites),
          BlocProvider<SearchBloc<Character>>.value(value: characters),
          BlocProvider<SearchBloc<Episode>>.value(value: episodes),
          BlocProvider<SearchBloc<Location>>.value(value: locations),
        ],
        child: MaterialApp(
          theme: AppTheme.light(useGoogleFonts: false),
          home: SearchPage(onOpenDetails: onOpen),
        ),
      ),
    );
  }

  testWidgets('starts by listing all characters', (tester) async {
    await pump(tester, const SearchState.initial());

    verify(() => characters.add(any(that: isA<SearchSubmitted>()))).called(1);
    expect(find.byType(LoadingSkeleton), findsOneWidget);
  });

  testWidgets('shows results and opens details on tap', (tester) async {
    ResourceType? openedType;
    int? openedId;
    await pump(
      tester,
      const SearchState.success(query: '', items: [rick, morty], totalCount: 2),
      onOpen: (type, id) {
        openedType = type;
        openedId = id;
      },
    );

    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Morty Smith'), findsOneWidget);
    expect(find.text('2 resultados'), findsOneWidget);

    await tester.tap(find.text('Morty Smith'));
    expect(openedType, ResourceType.character);
    expect(openedId, 2);
  });

  testWidgets('shows the not-found message with the query', (tester) async {
    await pump(tester, const SearchState.notFound(query: 'xyz'));

    expect(find.text('Nenhum resultado'), findsOneWidget);
    expect(find.textContaining('"xyz"'), findsOneWidget);
  });

  testWidgets('error state retries the same query', (tester) async {
    await pump(
      tester,
      const SearchState.error(query: 'rick', message: 'Sem conexão'),
    );
    clearInteractions(characters);

    await tester.tap(find.text('Tentar novamente'));

    final event =
        verify(() => characters.add(captureAny())).captured.single
            as SearchSubmitted;
    expect(event.query, 'rick');
  });

  testWidgets('typing dispatches debounced query events', (tester) async {
    await pump(tester, const SearchState.initial());
    clearInteractions(characters);

    await tester.enterText(find.byType(TextField), 'rick');

    final event =
        verify(() => characters.add(captureAny())).captured.single
            as SearchQueryChanged;
    expect(event.query, 'rick');
  });

  testWidgets('switching tabs searches the current query there', (
    tester,
  ) async {
    await pump(tester, const SearchState.initial());
    await tester.enterText(find.byType(TextField), 'pilot');

    await tester.tap(find.text('Episódios'));
    // Run the tab animation frame by frame: the skeleton pulses forever, so
    // pumpAndSettle would never return.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    final event =
        verify(() => episodes.add(captureAny())).captured.single
            as SearchSubmitted;
    expect(event.query, 'pilot');
  });

  testWidgets('uses a grid on tablets', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pump(
      tester,
      const SearchState.success(query: '', items: [rick, morty], totalCount: 2),
    );

    final rickTop = tester.getTopLeft(find.text('Rick Sanchez'));
    final mortyTop = tester.getTopLeft(find.text('Morty Smith'));
    expect(rickTop.dy, mortyTop.dy, reason: 'side by side in one row');
  });
}
