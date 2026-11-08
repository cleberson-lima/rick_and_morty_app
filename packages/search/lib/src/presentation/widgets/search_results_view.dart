import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import 'result_cards.dart';

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
        return switch (state) {
          SearchInitial() || SearchLoading() => const LoadingSkeleton(),
          SearchError(:final query, :final message) => StateView.error(
            message: message,
            onRetry: () => bloc.add(SearchSubmitted(query)),
          ),
          SearchNotFound(:final query) => StateView(
            icon: Icons.search_off,
            title: 'Nenhum resultado',
            message: query.isEmpty
                ? 'Não encontramos nenhum ${type.label.toLowerCase()}.'
                : 'Não existe ${type.label.toLowerCase()} com o nome "$query". '
                      'Confira a grafia ou tente outro termo.',
          ),
          SearchEmpty() => const StateView(
            icon: Icons.inbox_outlined,
            title: 'Nada por aqui',
            message: 'A busca não retornou resultados.',
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
    } else if (state.loadMoreError != null) {
      child = Column(
        children: [
          Text(state.loadMoreError!, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      );
    } else if (state.nextPage == null) {
      child = Text(
        '${state.totalCount} resultado${state.totalCount == 1 ? '' : 's'}',
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
