import 'package:flutter/material.dart';

import 'result_card.dart';

/// Breakpoints shared by every list screen.
abstract final class Breakpoints {
  static const compact = 600.0;
  static const tileMaxWidth = 380.0;

  /// 1 column on phones, 2–4 on tablets / landscape.
  static int columnsFor(double width) =>
      width < compact ? 1 : (width / tileMaxWidth).floor().clamp(2, 4);
}

/// Scrollable grid of result tiles that calls [onEndReached] near the bottom
/// (infinite scroll).
///
/// By default tiles are [ResultCard]-shaped: one column on phones, 2–4 on
/// wider screens. Cards with their own shape pass [tileHeight] and
/// [maxTileWidth], and get as many columns as fit (e.g. 2 character cards
/// side by side on a phone).
class ResponsiveResultsView extends StatefulWidget {
  const ResponsiveResultsView({
    required this.itemCount,
    required this.itemBuilder,
    this.footer,
    this.onEndReached,
    this.padding = const EdgeInsets.all(16),
    this.tileHeight = ResultCard.height,
    this.maxTileWidth,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? footer;
  final VoidCallback? onEndReached;
  final EdgeInsets padding;
  final double tileHeight;
  final double? maxTileWidth;

  /// Distance from the bottom at which the next page is requested.
  static const loadMoreThreshold = 400.0;

  @override
  State<ResponsiveResultsView> createState() => _ResponsiveResultsViewState();
}

class _ResponsiveResultsViewState extends State<ResponsiveResultsView> {
  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (widget.onEndReached != null &&
        metrics.axis == Axis.vertical &&
        metrics.extentAfter < ResponsiveResultsView.loadMoreThreshold) {
      widget.onEndReached!();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Breakpoints.columnsFor(constraints.maxWidth);
        return NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: widget.padding,
                sliver: SliverGrid.builder(
                  gridDelegate: widget.maxTileWidth == null
                      ? SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisExtent: widget.tileHeight,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        )
                      : SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: widget.maxTileWidth!,
                          mainAxisExtent: widget.tileHeight,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                ),
              ),
              if (widget.footer != null)
                SliverToBoxAdapter(child: widget.footer),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}
