import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({this.onOpen, super.key});

  /// Called when a favorite is tapped (the route opens its details).
  final ValueChanged<FavoriteItem>? onOpen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favoritesTitle),
        actions: const [ThemeToggleButton()],
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesLoading() => const LoadingSkeleton(),
          FavoritesError(:final failure) => MessageView.failure(
            failure: failure,
            onRetry: () => context.read<FavoritesCubit>().load(),
          ),
          FavoritesLoaded(:final items) when items.isEmpty => const MessageView(
            icon: Icons.favorite_border,
            title: AppStrings.favoritesEmptyTitle,
            message: AppStrings.favoritesEmptyMessage,
          ),
          FavoritesLoaded(:final items) => ResponsiveResultsView(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _FavoriteTile(item: items[index], onOpen: onOpen),
          ),
        },
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.item, this.onOpen});

  final FavoriteItem item;
  final ValueChanged<FavoriteItem>? onOpen;

  @override
  Widget build(BuildContext context) {
    return ResultCard(
      key: ValueKey('${item.type.name}-${item.id}'),
      title: item.name,
      subtitle: item.subtitle,
      caption: AppStrings.resourceLabel(item.type),
      imageUrl: item.imageUrl,
      fallbackIcon: switch (item.type) {
        ResourceType.character => Icons.person_outline,
        ResourceType.episode => Icons.movie_outlined,
        ResourceType.location => Icons.public,
      },
      onTap: onOpen == null ? null : () => onOpen!(item),
      trailing: IconButton(
        tooltip: AppStrings.removeFromFavorites,
        icon: const Icon(Icons.delete_outline),
        onPressed: () =>
            context.read<FavoritesCubit>().remove(item.type, item.id),
      ),
    );
  }
}
