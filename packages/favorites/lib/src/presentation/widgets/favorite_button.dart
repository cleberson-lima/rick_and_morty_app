import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/favorite_item.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

/// Heart toggle bound to the app-wide [FavoritesCubit].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.item, super.key});

  final FavoriteItem item;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesCubit, bool>(
      (cubit) => cubit.state.isFavorite(item.type, item.id),
    );
    final color = Theme.of(context).colorScheme.error;
    return IconButton(
      tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
      isSelected: isFavorite,
      icon: const Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite, color: color),
      onPressed: () => context.read<FavoritesCubit>().toggle(item),
    );
  }
}

/// Shows a snackbar when a favorites write fails. Place it once, high in the
/// tree (the app root does this).
class FavoritesErrorListener extends StatelessWidget {
  const FavoritesErrorListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (_, current) =>
          current is FavoritesLoaded && current.errorMessage != null,
      listener: (context, state) {
        final message = (state as FavoritesLoaded).errorMessage!;
        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: child,
    );
  }
}
