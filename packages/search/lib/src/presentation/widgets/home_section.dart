import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

/// One block of the home overview ("Personagens", "Episódios",
/// "Localizações"): title, "Ver todos" and the first [maxItems] results of
/// the unfiltered list.
class HomeSection<T> extends StatelessWidget {
  const HomeSection({
    required this.title,
    required this.itemBuilder,
    required this.tileHeight,
    required this.maxTileWidth,
    required this.onSeeAll,
    this.maxItems = 4,
    super.key,
  });

  final String title;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final double tileHeight;
  final double maxTileWidth;
  final VoidCallback onSeeAll;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PillButton(
                label: 'Ver todos',
                icon: PhosphorIconsRegular.queue,
                dense: true,
                onPressed: onSeeAll,
                tooltip: 'Ver todos: $title',
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<SearchBloc<T>, SearchState<T>>(
            builder: (context, state) => switch (state) {
              // The overview only shows the unfiltered list.
              SearchSuccess(:final items, :final query) when query.isEmpty =>
                _grid(items.take(maxItems).toList()),
              SearchError(:final message) => _SectionMessage(
                text: message,
                actionLabel: 'Tentar novamente',
                onAction: () => context.read<SearchBloc<T>>().add(
                  const SearchSubmitted(''),
                ),
              ),
              SearchEmpty() ||
              SearchNotFound() => const _SectionMessage(text: 'Nada por aqui.'),
              _ => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _grid(List<T> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxTileWidth,
        mainAxisExtent: tileHeight,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}

class _SectionMessage extends StatelessWidget {
  const _SectionMessage({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
