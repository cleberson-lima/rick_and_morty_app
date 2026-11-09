import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_storage_test.dart' show pilot, rick;

class _FavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

void main() {
  late _FavoritesCubit cubit;
  late ThemeCubit theme;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    theme = ThemeCubit(await SharedPreferences.getInstance());
    cubit = _FavoritesCubit();
    when(() => cubit.remove(any(), any())).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(ResourceType.character);
    registerFallbackValue(rick);
  });

  Future<void> pump(
    WidgetTester tester,
    FavoritesState state, {
    ValueChanged<FavoriteItem>? onOpen,
    Widget? home,
  }) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: theme),
          BlocProvider<FavoritesCubit>.value(value: cubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: home ?? FavoritesPage(onOpen: onOpen),
        ),
      ),
    );
  }

  testWidgets('empty state explains how to add favorites', (tester) async {
    await pump(tester, const FavoritesState.loaded(items: []));

    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
  });

  testWidgets('lists favorites and opens one on tap', (tester) async {
    FavoriteItem? opened;
    await pump(
      tester,
      const FavoritesState.loaded(items: [rick, pilot]),
      onOpen: (item) => opened = item,
    );

    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Pilot'), findsOneWidget);

    await tester.tap(find.text('Pilot'));
    expect(opened, pilot);
  });

  testWidgets('delete button removes the item', (tester) async {
    await pump(tester, const FavoritesState.loaded(items: [rick]));

    await tester.tap(find.byTooltip('Remover dos favoritos'));

    verify(() => cubit.remove(ResourceType.character, 1)).called(1);
  });

  testWidgets('error state retries loading', (tester) async {
    when(() => cubit.load()).thenAnswer((_) async {});
    await pump(tester, const FavoritesState.error(Failure.cache()));

    await tester.tap(find.text('Tentar novamente'));

    verify(() => cubit.load()).called(1);
  });

  testWidgets('FavoriteButton reflects and toggles state', (tester) async {
    when(() => cubit.toggle(any())).thenAnswer((_) async {});
    await pump(
      tester,
      const FavoritesState.loaded(items: [rick]),
      home: const Scaffold(
        body: Row(
          children: [
            FavoriteButton(item: rick),
            FavoriteButton(item: pilot),
          ],
        ),
      ),
    );

    expect(find.byIcon(PhosphorIconsFill.heart), findsOneWidget);
    expect(find.byIcon(PhosphorIconsRegular.heart), findsOneWidget);

    await tester.tap(find.byIcon(PhosphorIconsRegular.heart));
    verify(() => cubit.toggle(pilot)).called(1);
  });

  testWidgets('FavoriteButtonProvider turns FavoriteSlots into hearts', (
    tester,
  ) async {
    when(() => cubit.toggle(any())).thenAnswer((_) async {});
    await pump(
      tester,
      const FavoritesState.loaded(items: [rick]),
      home: const FavoriteButtonProvider(
        child: Scaffold(
          body: Row(
            children: [
              FavoriteSlot(item: rick),
              FavoriteSlot(item: pilot, compact: true),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(FavoriteButton), findsNWidgets(2));
    expect(
      tester.widget<FavoriteButton>(find.byType(FavoriteButton).last).compact,
      isTrue,
    );
    expect(find.byIcon(PhosphorIconsFill.heart), findsOneWidget);

    await tester.tap(find.byIcon(PhosphorIconsRegular.heart));
    verify(() => cubit.toggle(pilot)).called(1);
  });
}
