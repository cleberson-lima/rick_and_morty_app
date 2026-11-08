import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/domain/entities/episode.dart';
import 'package:search/src/domain/entities/location.dart';
import 'package:search/src/presentation/bloc/details_cubit.dart';
import 'package:search/src/presentation/pages/details_page.dart';

import '../test_data.dart';

class _DetailsCubit extends MockCubit<DetailsState> implements DetailsCubit {}

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

void main() {
  late _DetailsCubit details;
  late _FavoritesCubit favorites;

  setUpAll(
    () => registerFallbackValue(
      const FavoriteItem(type: ResourceType.character, id: 0, name: ''),
    ),
  );

  setUp(() {
    details = _DetailsCubit();
    favorites = _FavoritesCubit();
    when(
      () => favorites.state,
    ).thenReturn(const FavoritesState.loaded(items: []));
    when(() => favorites.toggle(any())).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester,
    DetailsState state, {
    VoidCallback? onRetry,
    Size size = const Size(400, 900),
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
        ],
        child: MaterialApp(
          theme: AppTheme.light(useGoogleFonts: false),
          home: DetailsPage(onRetry: onRetry ?? () {}),
        ),
      ),
    );
  }

  testWidgets('loading shows a spinner', (tester) async {
    await pump(tester, const DetailsState.loading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('character shows its facts and can be favorited', (tester) async {
    await pump(tester, const DetailsState.character(rick));

    expect(find.text('Rick Sanchez'), findsNWidgets(2)); // app bar + title
    expect(find.text('Vivo'), findsOneWidget);
    expect(find.text('Human'), findsOneWidget);
    expect(find.text('Earth (C-137)'), findsOneWidget);
    expect(find.text('Citadel of Ricks'), findsOneWidget);
    expect(find.text('51'), findsOneWidget);
    expect(find.byType(AppNetworkImage), findsOneWidget);

    await tester.tap(find.byTooltip('Adicionar aos favoritos'));
    final item =
        verify(() => favorites.toggle(captureAny())).captured.single
            as FavoriteItem;
    expect(item.type, ResourceType.character);
    expect(item.id, 1);
  });

  testWidgets('episode shows code, air date and cast size', (tester) async {
    await pump(
      tester,
      const DetailsState.episode(
        Episode(
          id: 1,
          name: 'Pilot',
          airDate: 'December 2, 2013',
          code: 'S01E01',
          characterCount: 19,
        ),
      ),
    );

    expect(find.text('S01E01'), findsOneWidget);
    expect(find.text('December 2, 2013'), findsOneWidget);
    expect(find.text('19'), findsOneWidget);
    expect(find.byIcon(Icons.movie_outlined), findsWidgets);
  });

  testWidgets('location sits beside its icon on wide screens', (tester) async {
    await pump(
      tester,
      const DetailsState.location(
        Location(
          id: 1,
          name: 'Earth (C-137)',
          type: 'Planet',
          dimension: 'Dimension C-137',
          residentCount: 27,
        ),
      ),
      size: const Size(1200, 900),
    );

    expect(find.text('Planet'), findsOneWidget);
    expect(find.text('Dimension C-137'), findsOneWidget);
    expect(find.text('27'), findsOneWidget);

    final hero = tester.getCenter(find.byIcon(Icons.public).first);
    final facts = tester.getCenter(find.text('Planet'));
    expect(facts.dx, greaterThan(hero.dx), reason: 'side by side');
  });

  testWidgets('not found explains the item does not exist', (tester) async {
    await pump(tester, const DetailsState.notFound());

    expect(find.text('Não encontrado'), findsOneWidget);
  });

  testWidgets('error offers a retry', (tester) async {
    var retried = false;
    await pump(
      tester,
      const DetailsState.error('Sem conexão'),
      onRetry: () => retried = true,
    );

    await tester.tap(find.text('Tentar novamente'));

    expect(retried, isTrue);
  });
}
