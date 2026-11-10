import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/models/models.dart';
import 'data/search_api.dart';
import 'presentation/bloc/details_cubit.dart';
import 'presentation/bloc/related_items_cubit.dart';
import 'presentation/bloc/search_bloc.dart';
import 'presentation/pages/details_page.dart';
import 'presentation/pages/search_page.dart';

/// Search (`/`) and details (`/details/:type/:id`) routes, built from the
/// app's [CoreDependencies].
///
/// Each screen creates its Blocs/Cubits in `BlocProvider.create`, so they are
/// closed when the screen leaves. Every Bloc/Cubit gets its own [SearchApi]:
/// a new search cancels only the previous one of the same instance, so the
/// "Mais ..." sections never cancel the home page's requests.
List<RouteBase> searchRoutes(CoreDependencies core) => [
  GoRoute(
    path: AppRoutes.search,
    builder: (context, state) => SearchRoute(dio: core.dio),
  ),
  GoRoute(
    path: AppRoutes.detailsPattern,
    builder: (context, state) => DetailsRoute(
      dio: core.dio,
      type: ResourceType.tryParse(state.pathParameters['type']),
      id: int.tryParse(state.pathParameters['id'] ?? ''),
    ),
  ),
];

/// Home page with the three search Blocs.
class SearchRoute extends StatelessWidget {
  const SearchRoute({required this.dio, super.key});

  final Dio dio;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc<Character>>(
          create: (_) => CharacterSearchBloc(SearchApi(dio)),
        ),
        BlocProvider<SearchBloc<Episode>>(
          create: (_) => EpisodeSearchBloc(SearchApi(dio)),
        ),
        BlocProvider<SearchBloc<Location>>(
          create: (_) => LocationSearchBloc(SearchApi(dio)),
        ),
      ],
      child: SearchPage(
        onOpenDetails: (type, id) => context.push(AppRoutes.details(type, id)),
        onOpenFavorites: () => context.push(AppRoutes.favorites),
      ),
    );
  }
}

/// Details page of ([type], [id]) with its "Mais ..." section. A link with an
/// unknown type or a non-numeric id shows "Link inválido".
class DetailsRoute extends StatelessWidget {
  const DetailsRoute({
    required this.dio,
    required this.type,
    required this.id,
    super.key,
  });

  final Dio dio;
  final ResourceType? type;
  final int? id;

  @override
  Widget build(BuildContext context) {
    final type = this.type;
    final id = this.id;
    if (type == null || id == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const MessageView(
          icon: Icons.link_off,
          title: AppStrings.invalidLinkTitle,
          message: AppStrings.invalidLinkMessage,
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailsCubit>(
          create: (_) => DetailsCubit(SearchApi(dio))..load(type, id),
        ),
        switch (type) {
          ResourceType.character => BlocProvider<RelatedItemsCubit<Character>>(
            create: (_) => RelatedCharactersCubit(SearchApi(dio))..load(1),
          ),
          ResourceType.episode => BlocProvider<RelatedItemsCubit<Episode>>(
            create: (_) => RelatedEpisodesCubit(SearchApi(dio))..load(1),
          ),
          ResourceType.location => BlocProvider<RelatedItemsCubit<Location>>(
            create: (_) => RelatedLocationsCubit(SearchApi(dio))..load(1),
          ),
        },
      ],
      child: Builder(
        builder: (context) => DetailsPage(
          onRetry: () => context.read<DetailsCubit>().load(type, id),
          onOpenDetails: (type, id) =>
              context.push(AppRoutes.details(type, id)),
          onOpenFavorites: () => context.push(AppRoutes.favorites),
        ),
      ),
    );
  }
}
