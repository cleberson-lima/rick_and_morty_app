import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? AppTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  group('ResultCard', () {
    testWidgets('shows texts, footer, trailing and handles taps', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        _app(
          ResultCard(
            title: 'Pilot',
            subtitle: 'S01E01',
            caption: 'December 2, 2013',
            fallbackIcon: Icons.movie_outlined,
            footer: const Text('footer'),
            trailing: const Icon(Icons.star),
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Pilot'), findsOneWidget);
      expect(find.text('S01E01'), findsOneWidget);
      expect(find.text('December 2, 2013'), findsOneWidget);
      expect(find.text('footer'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.movie_outlined), findsOneWidget);

      await tester.tap(find.text('Pilot'));
      expect(tapped, isTrue);
    });

    testWidgets('uses a network image when imageUrl is set', (tester) async {
      await tester.pumpWidget(
        _app(
          const ResultCard(title: 'Rick', imageUrl: 'https://example.test/1'),
        ),
      );

      expect(find.byType(AppNetworkImage), findsOneWidget);
    });
  });

  testWidgets('StatusChip shows its label', (tester) async {
    await tester.pumpWidget(
      _app(const StatusChip(label: 'Vivo', color: Colors.green)),
    );

    expect(find.text('Vivo'), findsOneWidget);
  });

  testWidgets('MessageView without action shows no button', (tester) async {
    await tester.pumpWidget(
      _app(
        const MessageView(
          icon: Icons.inbox,
          title: 'Nada por aqui',
          message: 'Sem resultados',
        ),
      ),
    );

    expect(find.text('Nada por aqui'), findsOneWidget);
    expect(find.text('Sem resultados'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  group('ResponsiveResultsView', () {
    Widget view({VoidCallback? onEndReached, int count = 30}) =>
        ResponsiveResultsView(
          itemCount: count,
          itemBuilder: (_, index) => ResultCard(title: 'Item $index'),
          footer: const Text('footer'),
          onEndReached: onEndReached,
        );

    testWidgets('one column on phones', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_app(view()));

      expect(
        tester.getTopLeft(find.text('Item 1')).dy,
        greaterThan(tester.getTopLeft(find.text('Item 0')).dy),
      );
    });

    testWidgets('requests more items near the end of the list', (tester) async {
      var calls = 0;
      await tester.pumpWidget(_app(view(onEndReached: () => calls++)));
      expect(calls, 0);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -5000));
      await tester.pump();

      expect(calls, greaterThan(0));
      expect(find.text('footer'), findsOneWidget);
    });
  });

  testWidgets('LoadingSkeleton renders placeholders and disposes cleanly', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const LoadingSkeleton(itemCount: 3)));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(Card), findsNWidgets(3));
    expect(find.bySemanticsLabel('Carregando'), findsOneWidget);

    await tester.pumpWidget(_app(const SizedBox()));
  });

  testWidgets('AppNetworkImage shows a placeholder while loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const AppNetworkImage(url: 'https://example.test/a.png', width: 50)),
    );

    expect(find.byType(ColoredBox), findsWidgets);
  });

  testWidgets('ThemeToggleButton switches the theme mode', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final cubit = ThemeCubit(await SharedPreferences.getInstance());
    await cubit.setMode(ThemeMode.light);

    await tester.pumpWidget(
      BlocProvider.value(value: cubit, child: _app(const ThemeToggleButton())),
    );
    expect(find.byTooltip('Tema escuro'), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    expect(cubit.state, ThemeMode.dark);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: _app(const ThemeToggleButton(), theme: AppTheme.dark()),
      ),
    );
    await tester.pumpAndSettle(); // theme changes animate
    expect(find.byTooltip('Tema claro'), findsOneWidget);
  });

  test('AppTheme builds light and dark schemes from the seed', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
    expect(light.useMaterial3, isTrue);
  });
}
