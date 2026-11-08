import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps content above the system navigation bar', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(useGoogleFonts: false),
        builder: (context, child) => BottomSafeArea(child: child!),
        home: const Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Text('last item'),
          ),
        ),
      ),
    );

    final bottom = tester.getBottomLeft(find.text('last item')).dy;
    expect(bottom, lessThanOrEqualTo(800 - 34));

    // Only the bottom inset is consumed: the app bar still handles the top.
    final inner = tester.element(find.text('last item'));
    expect(MediaQuery.paddingOf(inner).top, 24);
    expect(MediaQuery.paddingOf(inner).bottom, 0);
  });
}
