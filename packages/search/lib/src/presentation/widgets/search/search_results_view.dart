import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/search_bloc.dart';
import '../cards/cards.dart';

/// Renders every [SearchState] of one tab: skeleton, results with infinite
/// scroll, empty, not found and error with retry.
class SearchResultsView<T> extends StatelessWidget {
  const SearchResultsView({
    required this.type,
    required this.itemBuilder,
    super.key,
  });

  final ResourceType type;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc<T>, SearchState<T>>(
      builder: (context, state) {
        final bloc = context.read<SearchBloc<T>>();
        final l10n = context.l10n;
        final typeName = l10n.resourceLabel(type).toLowerCase();
        return switch (state) {
          SearchInitial() || SearchLoading() => const LoadingSkeleton(),
          SearchError(:final query, :final failure) => MessageView.failure(
            failure: failure,
            onRetry: () => bloc.add(SearchSubmitted(query)),
          ),
          SearchNotFound(:final query) => MessageView(
            icon: Icons.search_off,
            title: l10n.noResultsTitle,
            message: query.isEmpty
                ? l10n.noResultsOfType(typeName)
                : l10n.noResultsForQuery(typeName, query),
          ),
          SearchEmpty() => MessageView(
            icon: Icons.inbox_outlined,
            title: l10n.emptyTitle,
            message: l10n.emptyMessage,
          ),
          SearchSuccess(:final items) => ResponsiveResultsView(
            tileHeight: switch (type) {
              ResourceType.character => CardSizes.characterHeight,
              ResourceType.episode => CardSizes.episodeHeight,
              ResourceType.location => CardSizes.locationHeight,
            },
            maxTileWidth: switch (type) {
              ResourceType.character => CardSizes.characterMaxWidth,
              ResourceType.episode => CardSizes.episodeMaxWidth,
              ResourceType.location => CardSizes.locationMaxWidth,
            },
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(context, items[index]),
            onEndReached: () => bloc.add(const SearchNextPageRequested()),
            footer: _PaginationFooter(
              state: state,
              onRetry: () =>
                  bloc.add(const SearchNextPageRequested(retry: true)),
            ),
          ),
        };
      },
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.state, required this.onRetry});

  final SearchSuccess<Object?> state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget child;
    if (state.isLoadingMore) {
      child = const CircularProgressIndicator();
    } else if (state.loadMoreFailure case final failure?) {
      child = Column(
        children: [
          Text(failure.message(context.l10n), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      );
    } else if (state.nextPage == null) {
      child = Text(
        context.l10n.resultCount(state.totalCount),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      child = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(child: child),
    );
  }
}
