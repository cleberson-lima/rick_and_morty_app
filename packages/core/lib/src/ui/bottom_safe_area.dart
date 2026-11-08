import 'package:flutter/material.dart';

/// Keeps every screen above the system navigation bar / home indicator.
///
/// Android 15+ draws apps edge to edge, so without this the end of lists and
/// bottom buttons sit under the gesture bar. The strip below the content is
/// painted with the theme's surface color, so it blends in light and dark.
/// Used once in `MaterialApp.builder`, so it applies to every route.
class BottomSafeArea extends StatelessWidget {
  const BottomSafeArea({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(top: false, left: false, right: false, child: child),
    );
  }
}
