import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart'
    hide ModularWatchExtension;

import 'data/models/models.dart';
import 'data/search_api.dart';
import 'presentation/bloc/details_cubit.dart';
import 'presentation/bloc/related_items_cubit.dart';
import 'presentation/bloc/search_bloc.dart';
import 'presentation/pages/details_page.dart';
import 'presentation/pages/search_page.dart';

/// Search (`/`) and details (`/details/:type/:id`).
class SearchModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i
      ..addLazySingleton<SearchApi>(SearchApi.new)
      // Factories: each screen gets a fresh instance; BlocProvider closes it.
      ..add<CharacterSearchBloc>(CharacterSearchBloc.new)
      ..add<EpisodeSearchBloc>(EpisodeSearchBloc.new)
      ..add<LocationSearchBloc>(LocationSearchBloc.new)
      ..add<DetailsCubit>(DetailsCubit.new)
      // "Mais ..." sections get their own SearchApi: it cancels the previous
      // search of the same type, and must not cancel the home page's.
      ..add<RelatedCharactersCubit>(
        () => RelatedCharactersCubit(SearchApi(i.get<Dio>())),
      )
      ..add<RelatedEpisodesCubit>(
        () => RelatedEpisodesCubit(SearchApi(i.get<Dio>())),
      )
      ..add<RelatedLocationsCubit>(
        () => RelatedLocationsCubit(SearchApi(i.get<Dio>())),
      );
  }

  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (_) => const _SearchRoute())
      ..child(
        AppRoutes.detailsPattern,
        child: (_) => _DetailsRoute(
          type: ResourceType.tryParse(r.args.params['type'] as String?),
          id: int.tryParse('${r.args.params['id']}'),
        ),
      );
  }
}

class _SearchRoute extends StatelessWidget {
  const _SearchRoute();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc<Character>>(
          create: (_) => Modular.get<CharacterSearchBloc>(),
        ),
        BlocProvider<SearchBloc<Episode>>(
          create: (_) => Modular.get<EpisodeSearchBloc>(),
        ),
        BlocProvider<SearchBloc<Location>>(
          create: (_) => Modular.get<LocationSearchBloc>(),
        ),
      ],
      child: SearchPage(
        onOpenDetails: (type, id) =>
            Modular.to.pushNamed(AppRoutes.details(type, id)),
        onOpenFavorites: () => Modular.to.pushNamed(AppRoutes.favorites),
      ),
    );
  }
}

class _DetailsRoute extends StatelessWidget {
  const _DetailsRoute({required this.type, required this.id});

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
          title: 'Link inválido',
          message: 'Não foi possível abrir este item.',
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailsCubit>(
          create: (_) => Modular.get<DetailsCubit>()..load(type, id),
        ),
        switch (type) {
          ResourceType.character => BlocProvider<RelatedItemsCubit<Character>>(
            create: (_) => Modular.get<RelatedCharactersCubit>()..load(1),
          ),
          ResourceType.episode => BlocProvider<RelatedItemsCubit<Episode>>(
            create: (_) => Modular.get<RelatedEpisodesCubit>()..load(1),
          ),
          ResourceType.location => BlocProvider<RelatedItemsCubit<Location>>(
            create: (_) => Modular.get<RelatedLocationsCubit>()..load(1),
          ),
        },
      ],
      child: Builder(
        builder: (context) => DetailsPage(
          onRetry: () => context.read<DetailsCubit>().load(type, id),
          onOpenDetails: (type, id) =>
              Modular.to.pushNamed(AppRoutes.details(type, id)),
          onOpenFavorites: () => Modular.to.pushNamed(AppRoutes.favorites),
        ),
      ),
    );
  }
}
