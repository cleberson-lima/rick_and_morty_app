import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/favorite_item.dart';
import '../cubit/favorites_cubit.dart';

/// Cyan heart toggle (outline / filled) bound to the app-wide
/// [FavoritesCubit]. [compact] shrinks it for use inside cards.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.item, this.compact = false, super.key});

  final FavoriteItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesCubit, bool>(
      (cubit) => cubit.state.isFavorite(item.type, item.id),
    );
    final color = Theme.of(context).colorScheme.primary;
    return IconButton(
      tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
      isSelected: isFavorite,
      color: color,
      iconSize: compact ? 22 : 26,
      visualDensity: compact ? VisualDensity.compact : null,
      icon: const Icon(PhosphorIconsRegular.heart),
      selectedIcon: const Icon(PhosphorIconsFill.heart),
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
          current is FavoritesLoaded && current.actionFailure != null,
      listener: (context, state) {
        final message = (state as FavoritesLoaded).actionFailure!.message;
        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: child,
    );
  }
}
