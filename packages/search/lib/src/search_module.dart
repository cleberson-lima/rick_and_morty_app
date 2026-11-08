import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart'
    hide ModularWatchExtension;

import 'data/datasources/search_remote_data_source.dart';
import 'data/repositories/search_repository_impl.dart';
import 'domain/entities/character.dart';
import 'domain/entities/episode.dart';
import 'domain/entities/location.dart';
import 'domain/repositories/search_repository.dart';
import 'domain/usecases/details_usecases.dart';
import 'domain/usecases/search_usecases.dart';
import 'presentation/bloc/details_cubit.dart';
import 'presentation/bloc/more_items_cubit.dart';
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
      ..addLazySingleton<SearchRemoteDataSource>(SearchRemoteDataSourceImpl.new)
      ..addLazySingleton<SearchRepository>(SearchRepositoryImpl.new)
      ..addLazySingleton<SearchCharactersUseCase>(SearchCharactersUseCase.new)
      ..addLazySingleton<SearchEpisodesUseCase>(SearchEpisodesUseCase.new)
      ..addLazySingleton<SearchLocationsUseCase>(SearchLocationsUseCase.new)
      ..addLazySingleton<GetCharacterUseCase>(GetCharacterUseCase.new)
      ..addLazySingleton<GetEpisodeUseCase>(GetEpisodeUseCase.new)
      ..addLazySingleton<GetLocationUseCase>(GetLocationUseCase.new)
      // Factories: each screen gets a fresh instance; BlocProvider closes it.
      ..add<CharacterSearchBloc>(CharacterSearchBloc.new)
      ..add<EpisodeSearchBloc>(EpisodeSearchBloc.new)
      ..add<LocationSearchBloc>(LocationSearchBloc.new)
      ..add<DetailsCubit>(DetailsCubit.new)
      // "Mais ..." sections get their own data source: it cancels the
      // previous search of the same type, and must not cancel the home page.
      ..add<MoreCharactersCubit>(
        () => MoreCharactersCubit(SearchCharactersUseCase(_isolated(i))),
      )
      ..add<MoreEpisodesCubit>(
        () => MoreEpisodesCubit(SearchEpisodesUseCase(_isolated(i))),
      )
      ..add<MoreLocationsCubit>(
        () => MoreLocationsCubit(SearchLocationsUseCase(_isolated(i))),
      );
  }

  static SearchRepository _isolated(Injector i) =>
      SearchRepositoryImpl(SearchRemoteDataSourceImpl(i.get<Dio>()));

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
        body: const StateView(
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
          ResourceType.character => BlocProvider<MoreItemsCubit<Character>>(
            create: (_) => Modular.get<MoreCharactersCubit>()..load(1),
          ),
          ResourceType.episode => BlocProvider<MoreItemsCubit<Episode>>(
            create: (_) => Modular.get<MoreEpisodesCubit>()..load(1),
          ),
          ResourceType.location => BlocProvider<MoreItemsCubit<Location>>(
            create: (_) => Modular.get<MoreLocationsCubit>()..load(1),
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
