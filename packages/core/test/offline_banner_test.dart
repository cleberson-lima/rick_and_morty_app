import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late OfflineStatus status;

  setUp(() => status = OfflineStatus());

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: OfflineBanner(
        status: status,
        child: const Scaffold(body: Text('content')),
      ),
    ),
  );

  testWidgets('shows only the content while online', (tester) async {
    await pump(tester);

    expect(find.text('content'), findsOneWidget);
    expect(find.text(AppStrings.offlineBanner), findsNothing);
  });

  testWidgets('shows the strip while the data comes from the cache', (
    tester,
  ) async {
    await pump(tester);

    status.value = true;
    await tester.pumpAndSettle();

    expect(
      find.text('Sem conexão. Mostrando os dados salvos.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(find.text('content'), findsOneWidget, reason: 'content stays');

    status.value = false;
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.offlineBanner), findsNothing);
  });

  testWidgets('the strip sits below the content', (tester) async {
    status.value = true;
    await pump(tester);
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text(AppStrings.offlineBanner)).dy,
      greaterThan(tester.getTopLeft(find.text('content')).dy),
    );
  });
}
