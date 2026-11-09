import 'package:flutter/widgets.dart';

import '../types/favorite_item.dart';

/// Builds the favorite toggle for [item]. [compact] asks for the smaller
/// version used inside cards.
typedef FavoriteButtonBuilder =
    Widget Function(BuildContext context, FavoriteItem item, {bool compact});

/// Gives every [FavoriteSlot] below it the widget that marks an item as a
/// favorite.
///
/// Features place a [FavoriteSlot] where the heart goes and don't depend on
/// the `favorites` package; the app wires the real button once, at the root.
class FavoriteButtonScope extends InheritedWidget {
  const FavoriteButtonScope({
    required this.builder,
    required super.child,
    super.key,
  });

  final FavoriteButtonBuilder builder;

  /// The nearest scope's builder, or `null` when there is none.
  static FavoriteButtonBuilder? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<FavoriteButtonScope>()
      ?.builder;

  @override
  bool updateShouldNotify(FavoriteButtonScope oldWidget) =>
      builder != oldWidget.builder;
}

/// Where the favorite toggle for [item] goes. Renders the button from the
/// nearest [FavoriteButtonScope], or nothing when there is no scope.
class FavoriteSlot extends StatelessWidget {
  const FavoriteSlot({required this.item, this.compact = false, super.key});

  final FavoriteItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final builder = FavoriteButtonScope.maybeOf(context);
    return builder == null
        ? const SizedBox.shrink()
        : builder(context, item, compact: compact);
  }
}
