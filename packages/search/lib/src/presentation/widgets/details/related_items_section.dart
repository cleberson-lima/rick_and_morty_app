import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/related_items_cubit.dart';

/// "Mais personagens / episódios / localizações": a grid of one API page with
/// numbered pagination below it.
class RelatedItemsSection<T> extends StatelessWidget {
  const RelatedItemsSection({
    required this.title,
    required this.icon,
    required this.itemBuilder,
    required this.tileHeight,
    required this.maxTileWidth,
    super.key,
  });

  final String title;
  final IconData icon;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final double tileHeight;
  final double maxTileWidth;

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
              Icon(icon, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<RelatedItemsCubit<T>, RelatedItemsState<T>>(
            builder: (context, state) {
              final cubit = context.read<RelatedItemsCubit<T>>();
              return switch (state) {
                RelatedItemsLoading() => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
                RelatedItemsError(:final failure) => MessageView.failure(
                  failure: failure,
                  onRetry: cubit.retry,
                ),
                RelatedItemsSuccess(
                  :final items,
                  :final page,
                  :final totalPages,
                ) =>
                  Column(
                    children: [
                      GridView.builder(
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
                        itemBuilder: (context, index) =>
                            itemBuilder(context, items[index]),
                      ),
                      const SizedBox(height: 16),
                      PageSelector(
                        currentPage: page,
                        totalPages: totalPages,
                        onPageSelected: cubit.load,
                      ),
                    ],
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
