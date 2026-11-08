import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/domain/entities/episode.dart';
import 'package:search/src/domain/entities/location.dart';
import 'package:search/src/presentation/bloc/search_bloc.dart';
import 'package:search/src/presentation/bloc/search_event.dart';
import 'package:search/src/presentation/bloc/search_state.dart';
import 'package:search/src/presentation/widgets/result_cards.dart';
import 'package:search/src/presentation/widgets/search_results_view.dart';

class _EpisodeBloc extends MockBloc<SearchEvent, SearchState<Episode>>
    implements SearchBloc<Episode> {}

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

const _pilot = Episode(
  id: 1,
  name: 'Pilot',
  airDate: 'December 2, 2013',
  code: 'S01E01',
  characterCount: 19,
);

void main() {
  late _EpisodeBloc bloc;
  late _FavoritesCubit favorites;

  setUpAll(() => registerFallbackValue(const SearchSubmitted('')));

  setUp(() {
    bloc = _EpisodeBloc();
    favorites = _FavoritesCubit();
    when(
      () => favorites.state,
    ).thenReturn(const FavoritesState.loaded(items: []));
  });

  Future<void> pump(WidgetTester tester, SearchState<Episode> state) async {
    when(() => bloc.state).thenReturn(state);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc<Episode>>.value(value: bloc),
          BlocProvider<FavoritesCubit>.value(value: favorites),
        ],
        child: MaterialApp(
          theme: AppTheme.light(useGoogleFonts: false),
          home: Scaffold(
            body: SearchResultsView<Episode>(
              type: ResourceType.episode,
              itemBuilder: (_, episode) => EpisodeCard(episode: episode),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows a spinner while the next page loads', (tester) async {
    await pump(
      tester,
      const SearchState.success(
        query: '',
        items: [_pilot],
        totalCount: 51,
        nextPage: 2,
        isLoadingMore: true,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Pilot | S01E01'), findsOneWidget);
  });

  testWidgets('a failed page offers an explicit retry', (tester) async {
    await pump(
      tester,
      const SearchState.success(
        query: '',
        items: [_pilot],
        totalCount: 51,
        nextPage: 2,
        loadMoreError: 'Sem conexão',
      ),
    );
    clearInteractions(bloc);

    await tester.tap(find.text('Tentar novamente'));

    final event =
        verify(() => bloc.add(captureAny())).captured.single
            as SearchNextPageRequested;
    expect(event.retry, isTrue);
  });

  testWidgets('the last page shows a singular count', (tester) async {
    await pump(
      tester,
      const SearchState.success(query: 'pilot', items: [_pilot], totalCount: 1),
    );

    expect(find.text('1 resultado'), findsOneWidget);
  });

  testWidgets('empty state', (tester) async {
    await pump(tester, const SearchState.empty(query: 'a'));

    expect(find.text('Nada por aqui'), findsOneWidget);
  });

  testWidgets('not found without a query uses the generic message', (
    tester,
  ) async {
    await pump(tester, const SearchState.notFound(query: ''));

    expect(find.text('Não encontramos nenhum episódio.'), findsOneWidget);
  });

  group('cards and favorite snapshots', () {
    testWidgets('location card hides empty type and dimension', (tester) async {
      const location = Location(
        id: 3,
        name: 'Citadel of Ricks',
        type: '',
        dimension: 'unknown',
        residentCount: 101,
      );
      await tester.pumpWidget(
        BlocProvider<FavoritesCubit>.value(
          value: favorites,
          child: const MaterialApp(
            home: Scaffold(body: LocationCard(location: location)),
          ),
        ),
      );

      expect(find.text('Citadel of Ricks'), findsOneWidget);
      expect(find.text('unknown'), findsOneWidget);
      expect(location.toFavorite().subtitle, 'unknown');
    });

    test('episode snapshot carries code and air date', () {
      final item = _pilot.toFavorite();

      expect(item.type, ResourceType.episode);
      expect(item.subtitle, 'S01E01 · December 2, 2013');
      expect(item.imageUrl, isNull);
    });
  });

  test('currentQuery is null before the first search', () {
    expect(const SearchState<Episode>.initial().currentQuery, isNull);
    expect(const SearchState<Episode>.empty(query: 'x').currentQuery, 'x');
    expect(
      const SearchState<Episode>.error(query: 'y', message: 'm').currentQuery,
      'y',
    );
  });
}
