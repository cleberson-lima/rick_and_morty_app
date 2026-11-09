import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/data/models/models.dart';
import 'package:search/src/presentation/widgets/result_cards.dart';

import '../test_data.dart';

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
  late _FavoritesCubit favorites;

  setUp(() {
    favorites = _FavoritesCubit();
    when(
      () => favorites.state,
    ).thenReturn(FavoritesState.loaded(items: [rick.toFavorite()]));
  });

  /// Renders [cards] in the same grid the app uses, at a given width, so an
  /// overflow inside a card fails the test.
  Future<void> pumpGrid(
    WidgetTester tester, {
    required double width,
    required double tileHeight,
    required double maxTileWidth,
    required List<Widget> cards,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      BlocProvider<FavoritesCubit>.value(
        value: favorites,
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(
            body: ResponsiveResultsView(
              itemCount: cards.length,
              tileHeight: tileHeight,
              maxTileWidth: maxTileWidth,
              itemBuilder: (_, index) => cards[index],
            ),
          ),
        ),
      ),
    );
  }

  for (final width in [360.0, 1024.0]) {
    testWidgets('character card at ${width.toInt()}px', (tester) async {
      var opened = 0;
      await pumpGrid(
        tester,
        width: width,
        tileHeight: CardSizes.characterHeight,
        maxTileWidth: CardSizes.characterMaxWidth,
        cards: [
          CharacterCard(character: rick, onTap: () => opened++),
          const CharacterCard(character: morty),
        ],
      );

      expect(find.text('Rick Sanchez'), findsOneWidget);
      expect(find.text('Vivo'), findsNWidgets(2));
      expect(find.text('Humano'), findsNWidgets(2), reason: 'translated');
      expect(find.text('Earth (C-137)'), findsOneWidget);
      expect(find.byIcon(PhosphorIconsRegular.heartbeat), findsNWidgets(2));
      expect(find.byIcon(PhosphorIconsFill.heart), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Rick Sanchez')).dy,
        tester.getTopLeft(find.text('Morty Smith')).dy,
        reason: 'two columns even on a phone',
      );

      await tester.tap(find.text('Saiba mais').first);
      expect(opened, 1);
    });

    testWidgets('episode and location cards at ${width.toInt()}px', (
      tester,
    ) async {
      await pumpGrid(
        tester,
        width: width,
        tileHeight: CardSizes.episodeHeight,
        maxTileWidth: CardSizes.episodeMaxWidth,
        cards: const [EpisodeCard(episode: _pilot)],
      );
      expect(find.text('Pilot | S01E01'), findsOneWidget);
      expect(find.byIcon(PhosphorIconsRegular.monitorPlay), findsOneWidget);

      await pumpGrid(
        tester,
        width: width,
        tileHeight: CardSizes.locationHeight,
        maxTileWidth: CardSizes.locationMaxWidth,
        cards: const [LocationCard(location: _earth)],
      );
      expect(find.text('Planet'), findsOneWidget);
      expect(find.text('Earth (C-137)'), findsOneWidget);
      expect(find.text('Saiba mais'), findsOneWidget);
    });
  }

  test('speciesLabel translates known species and keeps the rest', () {
    expect(speciesLabel('Human'), 'Humano');
    expect(speciesLabel('Alien'), 'Alienígena');
    expect(speciesLabel('unknown'), 'Desconhecido');
    expect(speciesLabel('Cronenberg'), 'Cronenberg');
  });
}
