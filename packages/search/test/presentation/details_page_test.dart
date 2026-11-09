import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/data/models/models.dart';
import 'package:search/src/presentation/bloc/details_cubit.dart';
import 'package:search/src/presentation/bloc/related_items_cubit.dart';
import 'package:search/src/presentation/pages/details_page.dart';
import 'package:search/src/presentation/widgets/open_details.dart';

import '../test_data.dart';

class _DetailsCubit extends MockCubit<DetailsState> implements DetailsCubit {}

class _RelatedCharacters extends MockCubit<RelatedItemsState<Character>>
    implements RelatedItemsCubit<Character> {}

class _RelatedEpisodes extends MockCubit<RelatedItemsState<Episode>>
    implements RelatedItemsCubit<Episode> {}

class _RelatedLocations extends MockCubit<RelatedItemsState<Location>>
    implements RelatedItemsCubit<Location> {}

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
  late _DetailsCubit details;
  late _RelatedCharacters moreCharacters;
  late _RelatedEpisodes moreEpisodes;
  late _RelatedLocations moreLocations;
  late _FavoritesCubit favorites;

  setUpAll(
    () => registerFallbackValue(
      const FavoriteItem(type: ResourceType.character, id: 0, name: ''),
    ),
  );

  setUp(() {
    details = _DetailsCubit();
    moreCharacters = _RelatedCharacters();
    moreEpisodes = _RelatedEpisodes();
    moreLocations = _RelatedLocations();
    favorites = _FavoritesCubit();
    when(
      () => favorites.state,
    ).thenReturn(const FavoritesState.loaded(items: []));
    when(() => favorites.toggle(any())).thenAnswer((_) async {});
    when(() => moreCharacters.state).thenReturn(
      const RelatedItemsState.success(items: [morty], page: 1, totalPages: 42),
    );
    when(() => moreEpisodes.state).thenReturn(
      const RelatedItemsState.success(items: [_pilot], page: 1, totalPages: 3),
    );
    when(() => moreLocations.state).thenReturn(
      const RelatedItemsState.success(items: [_earth], page: 1, totalPages: 7),
    );
    when(() => moreCharacters.load(any())).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester,
    DetailsState state, {
    VoidCallback? onRetry,
    OpenDetails? onOpen,
    VoidCallback? onOpenFavorites,
    Size size = const Size(400, 2400),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    when(() => details.state).thenReturn(state);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<DetailsCubit>.value(value: details),
          BlocProvider<FavoritesCubit>.value(value: favorites),
          BlocProvider<RelatedItemsCubit<Character>>.value(
            value: moreCharacters,
          ),
          BlocProvider<RelatedItemsCubit<Episode>>.value(value: moreEpisodes),
          BlocProvider<RelatedItemsCubit<Location>>.value(value: moreLocations),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: DetailsPage(
            onRetry: onRetry ?? () {},
            onOpenDetails: onOpen,
            onOpenFavorites: onOpenFavorites,
          ),
        ),
      ),
    );
  }

  testWidgets('loading shows a spinner under the top bar', (tester) async {
    await pump(tester, const DetailsState.loading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Lista de favoritos'), findsOneWidget);
  });

  testWidgets('character: facts, places, favorite and more characters', (
    tester,
  ) async {
    final opened = <(ResourceType, int)>[];
    const withPlaces = Character(
      id: 1,
      name: 'Rick Sanchez',
      status: CharacterStatus.alive,
      species: 'Human',
      type: '',
      gender: 'Male',
      originName: 'Earth (C-137)',
      locationName: 'Citadel of Ricks',
      originId: 1,
      locationId: 3,
      imageUrl: 'https://example.test/1.jpeg',
      episodeCount: 51,
    );
    await pump(
      tester,
      const DetailsState.character(withPlaces),
      onOpen: (type, id) => opened.add((type, id)),
    );

    expect(find.text('Participou de 51 episódios'), findsOneWidget);
    expect(find.text('Vivo'), findsWidgets);
    expect(find.text('Humano'), findsWidgets);
    expect(find.text('Male'), findsOneWidget);
    expect(find.byIcon(PhosphorIconsRegular.genderMale), findsOneWidget);
    expect(find.text('Origem'), findsOneWidget);
    expect(find.text('Citadel of Ricks'), findsOneWidget);
    expect(find.text('Mais personagens'), findsOneWidget);
    expect(find.text('Morty Smith'), findsOneWidget);

    // Heart next to the name favorites the character.
    await tester.tap(find.byTooltip('Adicionar aos favoritos').first);
    final item =
        verify(() => favorites.toggle(captureAny())).captured.single
            as FavoriteItem;
    expect((item.type, item.id), (ResourceType.character, 1));

    // "Saiba mais" on the last-location card opens location 3.
    final locationCard = find.ancestor(
      of: find.text('Citadel of Ricks'),
      matching: find.byType(Card),
    );
    await tester.tap(
      find.descendant(of: locationCard, matching: find.text('Saiba mais')),
    );
    expect(opened.last, (ResourceType.location, 3));

    // Another page of "Mais personagens".
    await tester.tap(find.text('2'));
    verify(() => moreCharacters.load(2)).called(1);
  });

  testWidgets('unknown origin has no buttons', (tester) async {
    await pump(tester, const DetailsState.character(morty));

    final originCard = find.ancestor(
      of: find.text('Origem'),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: originCard, matching: find.text('Saiba mais')),
      findsNothing,
    );
  });

  testWidgets('episode: date, code, cast size and more episodes', (
    tester,
  ) async {
    await pump(tester, const DetailsState.episode(_pilot));

    expect(find.text('December 2, 2013'), findsOneWidget);
    expect(find.text('S01E01'), findsOneWidget);
    expect(
      find.text('19 personagens participaram deste episódio'),
      findsOneWidget,
    );
    expect(find.text('Mais episódios'), findsOneWidget);
    expect(find.text('Pilot | S01E01'), findsOneWidget);
  });

  testWidgets('location: type, dimension, residents and more locations', (
    tester,
  ) async {
    await pump(tester, const DetailsState.location(_earth));

    expect(find.text('Dimension C-137'), findsOneWidget);
    expect(find.text('27 residentes'), findsOneWidget);
    expect(find.text('Mais localizações'), findsOneWidget);
  });

  testWidgets('wide screens put the image beside the facts', (tester) async {
    await pump(
      tester,
      const DetailsState.character(rick),
      size: const Size(1200, 1600),
    );

    final image = tester.getCenter(find.byType(AppNetworkImage).first);
    final facts = tester.getCenter(find.text('Participou de 51 episódios'));
    expect(facts.dx, greaterThan(image.dx));
  });

  testWidgets('a failed "Mais" page offers a retry', (tester) async {
    when(() => moreEpisodes.state).thenReturn(
      const RelatedItemsState.error(failure: Failure.network(), page: 2),
    );
    when(() => moreEpisodes.retry()).thenAnswer((_) async {});
    await pump(tester, const DetailsState.episode(_pilot));

    await tester.tap(find.text('Tentar novamente'));

    verify(() => moreEpisodes.retry()).called(1);
  });

  testWidgets('not found explains the item does not exist', (tester) async {
    await pump(tester, const DetailsState.notFound());

    expect(find.text('Não encontrado'), findsOneWidget);
  });

  testWidgets('error offers a retry', (tester) async {
    var retried = false;
    await pump(
      tester,
      const DetailsState.error(Failure.network()),
      onRetry: () => retried = true,
    );

    await tester.tap(find.text('Tentar novamente'));

    expect(retried, isTrue);
  });

  testWidgets('top bar opens favorites and goes back', (tester) async {
    var favoritesOpened = false;
    await pump(
      tester,
      const DetailsState.loading(),
      onOpenFavorites: () => favoritesOpened = true,
    );

    await tester.tap(find.text('Lista de favoritos'));
    expect(favoritesOpened, isTrue);
    expect(find.byTooltip('Voltar'), findsOneWidget);
  });
}
