import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('visibleRange keeps the current page centred', () {
    test('at the start, middle and end', () {
      expect(PageSelector.visibleRange(1, 42, 5), (1, 5));
      expect(PageSelector.visibleRange(10, 42, 5), (8, 12));
      expect(PageSelector.visibleRange(42, 42, 5), (38, 42));
    });

    test('fewer pages than the window', () {
      expect(PageSelector.visibleRange(2, 3, 5), (1, 3));
      expect(PageSelector.visibleRange(1, 1, 5), (1, 1));
    });
  });

  testWidgets('selects pages and disables arrows at the edges', (tester) async {
    int? selected;
    Future<void> pump(int current) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: PageSelector(
            currentPage: current,
            totalPages: 3,
            onPageSelected: (page) => selected = page,
          ),
        ),
      ),
    );

    await pump(1);
    expect(find.text('3'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, PhosphorIconsRegular.caretLeft),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('3'));
    expect(selected, 3);

    await tester.tap(find.byTooltip('Próxima página'));
    expect(selected, 2);

    await pump(3);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, PhosphorIconsRegular.caretRight),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('Página anterior'));
    expect(selected, 2);
  });
}
