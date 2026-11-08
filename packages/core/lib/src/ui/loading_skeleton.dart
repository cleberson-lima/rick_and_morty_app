import 'package:flutter/material.dart';

import 'responsive_results_view.dart';
import 'result_card.dart';

/// Pulsing placeholder cards shown while the first page loads.
class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({this.itemCount = 8, super.key});

  final int itemCount;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.4,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      label: 'Carregando',
      child: FadeTransition(
        opacity: _controller,
        child: IgnorePointer(
          child: ResponsiveResultsView(
            itemCount: widget.itemCount,
            itemBuilder: (_, _) => Card(
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: ResultCard.height,
                    child: ColoredBox(color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bar(color: color, widthFactor: 0.7),
                        const SizedBox(height: 10),
                        _Bar(color: color, widthFactor: 0.45),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.color, required this.widthFactor});

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}
