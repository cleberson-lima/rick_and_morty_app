import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../bloc/details_cubit.dart';
import '../widgets/result_cards.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) => switch (state) {
        DetailsLoading() => const _Shell(
          body: Center(child: CircularProgressIndicator()),
        ),
        DetailsNotFound() => const _Shell(
          body: StateView(
            icon: Icons.search_off,
            title: 'Não encontrado',
            message: 'Este item não existe ou foi removido da API.',
          ),
        ),
        DetailsError(:final message) => _Shell(
          body: StateView.error(message: message, onRetry: onRetry),
        ),
        DetailsCharacter(:final character) => _Shell(
          title: character.name,
          favorite: character.toFavorite(),
          imageUrl: character.imageUrl,
          badge: StatusChip(
            label: character.status.label,
            color: statusColor(character.status),
          ),
          facts: _characterFacts(character),
        ),
        DetailsEpisode(:final episode) => _Shell(
          title: episode.name,
          favorite: episode.toFavorite(),
          icon: Icons.movie_outlined,
          facts: _episodeFacts(episode),
        ),
        DetailsLocation(:final location) => _Shell(
          title: location.name,
          favorite: location.toFavorite(),
          icon: Icons.public,
          facts: _locationFacts(location),
        ),
      },
    );
  }

  static List<_Fact> _characterFacts(Character c) => [
    _Fact(Icons.biotech_outlined, 'Espécie', c.species),
    if (c.type.isNotEmpty) _Fact(Icons.category_outlined, 'Tipo', c.type),
    _Fact(Icons.wc_outlined, 'Gênero', c.gender),
    _Fact(Icons.home_outlined, 'Origem', c.originName),
    _Fact(Icons.place_outlined, 'Última localização', c.locationName),
    _Fact(Icons.movie_outlined, 'Episódios', '${c.episodeCount}'),
  ];

  static List<_Fact> _episodeFacts(Episode e) => [
    _Fact(Icons.tag, 'Código', e.code),
    _Fact(Icons.event_outlined, 'Exibição', e.airDate),
    _Fact(Icons.groups_outlined, 'Personagens', '${e.characterCount}'),
  ];

  static List<_Fact> _locationFacts(Location l) => [
    if (l.type.isNotEmpty) _Fact(Icons.category_outlined, 'Tipo', l.type),
    if (l.dimension.isNotEmpty) _Fact(Icons.blur_on, 'Dimensão', l.dimension),
    _Fact(Icons.groups_outlined, 'Residentes', '${l.residentCount}'),
  ];
}

class _Fact {
  const _Fact(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

/// Scaffold shared by every state; on wide screens the hero sits beside the
/// facts instead of above them.
class _Shell extends StatelessWidget {
  const _Shell({
    this.title,
    this.favorite,
    this.imageUrl,
    this.icon,
    this.badge,
    this.facts = const [],
    this.body,
  });

  final String? title;
  final FavoriteItem? favorite;
  final String? imageUrl;
  final IconData? icon;
  final Widget? badge;
  final List<_Fact> facts;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Detalhes'),
        actions: [if (favorite != null) FavoriteButton(item: favorite!)],
      ),
      body:
          body ??
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= Breakpoints.compact;
              final hero = _Hero(imageUrl: imageUrl, icon: icon);
              final info = _Info(title: title!, badge: badge, facts: facts);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 320, child: hero),
                              const SizedBox(width: 32),
                              Expanded(child: info),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [hero, const SizedBox(height: 24), info],
                          ),
                  ),
                ),
              );
            },
          ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({this.imageUrl, this.icon});

  final String? imageUrl;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: imageUrl != null
                ? AppNetworkImage(url: imageUrl!, width: 320)
                : ColoredBox(
                    color: scheme.primaryContainer,
                    child: Icon(
                      icon ?? Icons.info_outline,
                      size: 96,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.title, required this.facts, this.badge});

  final String title;
  final Widget? badge;
  final List<_Fact> facts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (badge != null) ...[const SizedBox(height: 8), badge!],
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (final fact in facts)
                ListTile(
                  leading: Icon(fact.icon),
                  title: Text(fact.label),
                  subtitle: Text(fact.value),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
