import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/data/models/models.dart';
import 'package:search/src/presentation/bloc/search_bloc.dart';
import 'package:search/src/presentation/pages/search_page.dart';
import 'package:search/src/presentation/widgets/home/home_hero.dart';
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

const _pilot = Episode(
  id: 1,
  name: 'Pilot',
  airDate: 'December 2, 2013',
  code: 'S01E01',
  characterCount: 19,
);

const _earth = Location(
  id: 1,
  name: 'Earth (C-137)',
  type: 'Planet',
  dimension: 'Dimension C-137',
  residentCount: 27,
);

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
    when(() => characters.state).thenReturn(
      const SearchState.success(query: '', items: [rick, morty], totalCount: 2),
    );
    when(() => episodes.state).thenReturn(
      const SearchState.success(query: '', items: [_pilot], totalCount: 1),
    );
    when(() => locations.state).thenReturn(
      const SearchState.success(query: '', items: [_earth], totalCount: 1),
    );
    when(
      () => favorites.state,
    ).thenReturn(const FavoritesState.loaded(items: []));
  });

  Future<void> pump(
    WidgetTester tester, {
    void Function(ResourceType, int)? onOpen,
    VoidCallback? onOpenFavorites,
  }) async {
    // Tall phone, so the whole overview is laid out without scrolling.
    tester.view.physicalSize = const Size(400, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
          theme: AppTheme.light(),
          home: SearchPage(
            onOpenDetails: onOpen,
            onOpenFavorites: onOpenFavorites,
          ),
        ),
      ),
    );
  }

  testWidgets('loads the three unfiltered lists on start', (tester) async {
    await pump(tester);

    for (final bloc in [characters, episodes, locations]) {
      final event =
          verify(() => bloc.add(captureAny())).captured.single
              as SearchSubmitted;
      expect(event.query, '');
    }
  });

  testWidgets('overview shows hero, sections and footer', (tester) async {
    var favoritesOpened = false;
    await pump(tester, onOpenFavorites: () => favoritesOpened = true);

    expect(find.textContaining('lugar.', findRichText: true), findsOneWidget);
    expect(find.text(HomeHero.lightTagline), findsOneWidget);
    expect(find.text('Personagens'), findsWidgets);
    expect(find.text('Episódios'), findsWidgets);
    expect(find.text('Localizações'), findsWidgets);
    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Pilot | S01E01'), findsOneWidget);
    expect(find.text('Planet'), findsOneWidget, reason: 'location card');
    expect(find.text('Voltar ao topo'), findsOneWidget);

    await tester.tap(find.text('Lista de favoritos'));
    expect(favoritesOpened, isTrue);
  });

  testWidgets('tapping a card opens its details', (tester) async {
    ResourceType? type;
    int? id;
    await pump(
      tester,
      onOpen: (t, i) {
        type = t;
        id = i;
      },
    );

    await tester.tap(find.text('Morty Smith'));

    expect(type, ResourceType.character);
    expect(id, 2);
  });

  testWidgets('typing searches the selected filter and shows results', (
    tester,
  ) async {
    await pump(tester);
    clearInteractions(characters);

    await tester.enterText(find.byType(TextField), 'rick');
    await tester.pump();

    final event =
        verify(() => characters.add(captureAny())).captured.single
            as SearchQueryChanged;
    expect(event.query, 'rick');
    expect(find.byType(HomeHero), findsNothing, reason: 'results mode');
    expect(find.byTooltip('Voltar ao início'), findsOneWidget);
  });

  testWidgets('"Ver todos" lists every location', (tester) async {
    await pump(tester);

    await tester.tap(find.byTooltip('Ver todos: Localizações'));
    await tester.pump();

    expect(find.byType(HomeHero), findsNothing);
    expect(find.text('Earth (C-137)'), findsOneWidget);
    final chip = tester.widget<PillButton>(
      find.byKey(const ValueKey('filter-location')),
    );
    expect(chip.filled, isTrue, reason: 'Locais filter selected');
  });

  testWidgets('a filter re-runs the current query for its type', (
    tester,
  ) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField), 'pilot');
    await tester.pump();
    clearInteractions(episodes);

    // The filters scroll horizontally: bring the chip into view first.
    final chip = find.byKey(const ValueKey('filter-episode'));
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await tester.pump();

    final event =
        verify(() => episodes.add(captureAny())).captured.single
            as SearchSubmitted;
    expect(event.query, 'pilot');
  });

  testWidgets('back returns to the overview and resets filtered lists', (
    tester,
  ) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField), 'rick');
    await tester.pump();
    when(() => characters.state).thenReturn(
      const SearchState.success(query: 'rick', items: [rick], totalCount: 1),
    );
    clearInteractions(characters);

    await tester.tap(find.byTooltip('Voltar ao início'));
    await tester.pump();

    expect(find.byType(HomeHero), findsOneWidget);
    final event =
        verify(() => characters.add(captureAny())).captured.single
            as SearchSubmitted;
    expect(event.query, '');
  });

  testWidgets('a failed section offers a retry', (tester) async {
    when(() => episodes.state).thenReturn(
      const SearchState.error(query: '', failure: Failure.network()),
    );
    await pump(tester);
    clearInteractions(episodes);

    await tester.tap(find.text('Tentar novamente'));

    final event =
        verify(() => episodes.add(captureAny())).captured.single
            as SearchSubmitted;
    expect(event.query, '');
  });

  testWidgets('the theme selector switches to dark', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Escuro'));
    await tester.pump();

    expect(theme.state, ThemeMode.dark);
  });
}
