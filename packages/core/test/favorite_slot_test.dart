import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _rick = FavoriteItem(
  type: ResourceType.character,
  id: 1,
  name: 'Rick Sanchez',
);

void main() {
  testWidgets('FavoriteSlot renders nothing without a scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FavoriteSlot(item: _rick)),
      ),
    );

    expect(tester.getSize(find.byType(FavoriteSlot)), Size.zero);
  });

  testWidgets('FavoriteSlot builds the scope button with item and size', (
    tester,
  ) async {
    final calls = <(FavoriteItem, bool)>[];
    await tester.pumpWidget(
      FavoriteButtonScope(
        builder: (context, item, {compact = false}) {
          calls.add((item, compact));
          return Text('heart ${item.id}');
        },
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                FavoriteSlot(item: _rick),
                FavoriteSlot(item: _rick, compact: true),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('heart 1'), findsNWidgets(2));
    expect(calls, [(_rick, false), (_rick, true)]);
  });

  testWidgets('a new builder rebuilds the slots', (tester) async {
    Widget app(String label) => FavoriteButtonScope(
      builder: (context, item, {compact = false}) => Text(label),
      child: const MaterialApp(
        home: Scaffold(body: FavoriteSlot(item: _rick)),
      ),
    );

    await tester.pumpWidget(app('first'));
    await tester.pumpWidget(app('second'));

    expect(find.text('second'), findsOneWidget);
  });

  test('FavoriteItem round-trips through JSON, enum stored by name', () {
    final json = _rick.toJson();

    expect(json['type'], 'character');
    expect(FavoriteItem.fromJson(json), _rick);
  });
}
