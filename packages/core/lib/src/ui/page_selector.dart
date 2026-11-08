import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'phosphor_icons.dart';

/// Numbered pagination from the prototype: `‹ 1 2 3 4 5 ›`, current page in
/// a cyan circle, showing a window of [window] pages around it.
class PageSelector extends StatelessWidget {
  const PageSelector({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    this.window = 5,
    super.key,
  }) : assert(currentPage >= 1 && currentPage <= totalPages);

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  final int window;

  /// First and last page numbers shown, keeping [currentPage] centred when
  /// possible.
  static (int, int) visibleRange(int current, int total, int window) {
    final size = math.min(window, total);
    var first = current - size ~/ 2;
    first = first.clamp(1, total - size + 1);
    return (first, first + size - 1);
  }

  @override
  Widget build(BuildContext context) {
    final (first, last) = visibleRange(currentPage, totalPages, window);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Página anterior',
          icon: const Icon(PhosphorIconsRegular.caretLeft, size: 18),
          onPressed: currentPage > 1
              ? () => onPageSelected(currentPage - 1)
              : null,
        ),
        for (var page = first; page <= last; page++)
          _PageDot(
            page: page,
            selected: page == currentPage,
            onTap: () => onPageSelected(page),
          ),
        IconButton(
          tooltip: 'Próxima página',
          icon: const Icon(PhosphorIconsRegular.caretRight, size: 18),
          onPressed: currentPage < totalPages
              ? () => onPageSelected(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({
    required this.page,
    required this.selected,
    required this.onTap,
  });

  final int page;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      label: 'Página $page',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: selected ? null : onTap,
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? scheme.primary : null,
              border: selected ? null : Border.all(color: scheme.outline),
            ),
            child: Text(
              '$page',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
