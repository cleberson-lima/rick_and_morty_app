import 'package:flutter/material.dart';

/// Top bar + a message filling the rest (loading, not found, error).
class DetailsMessageLayout extends StatelessWidget {
  const DetailsMessageLayout({
    required this.topBar,
    required this.child,
    super.key,
  });

  final Widget topBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar,
        Expanded(child: child),
      ],
    );
  }
}

/// Top bar, header, cyan rule and the "Mais ..." section, scrolling together.
class DetailsContentLayout extends StatelessWidget {
  const DetailsContentLayout({
    required this.topBar,
    required this.header,
    required this.related,
    super.key,
  });

  final Widget topBar;
  final Widget header;
  final Widget related;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: topBar),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: header,
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SliverToBoxAdapter(child: related),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
