import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../bloc/details_cubit.dart';
import '../widgets/home_hero.dart';
import '../widgets/related_items_section.dart';
import '../widgets/result_cards.dart';

typedef OpenDetails = void Function(ResourceType type, int id);

/// Details pages from the prototype ("Tela 02 - Personagens",
/// "Tela 03 - Episódios", "Tela 04 - Localizações"): header with the item,
/// a cyan rule and a paginated "Mais ..." section of the same type.
class DetailsPage extends StatelessWidget {
  const DetailsPage({
    required this.onRetry,
    this.onOpenDetails,
    this.onOpenFavorites,
    super.key,
  });

  final VoidCallback onRetry;
  final OpenDetails? onOpenDetails;
  final VoidCallback? onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    final topBar = _TopBar(onOpenFavorites: onOpenFavorites);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) => switch (state) {
            DetailsLoading() => _Message(
              topBar: topBar,
              child: const Center(child: CircularProgressIndicator()),
            ),
            DetailsNotFound() => _Message(
              topBar: topBar,
              child: const MessageView(
                icon: Icons.search_off,
                title: 'Não encontrado',
                message: 'Este item não existe ou foi removido da API.',
              ),
            ),
            DetailsError(:final failure) => _Message(
              topBar: topBar,
              child: MessageView.failure(failure: failure, onRetry: onRetry),
            ),
            DetailsCharacter(:final character) => _Content<Character>(
              topBar: topBar,
              header: _CharacterHeader(
                character: character,
                onOpenDetails: onOpenDetails,
              ),
              more: RelatedItemsSection<Character>(
                title: 'Mais personagens',
                icon: PhosphorIconsRegular.smiley,
                tileHeight: CardSizes.characterHeight,
                maxTileWidth: CardSizes.characterMaxWidth,
                itemBuilder: (_, item) => CharacterCard(
                  character: item,
                  onTap: () =>
                      onOpenDetails?.call(ResourceType.character, item.id),
                ),
              ),
            ),
            DetailsEpisode(:final episode) => _Content<Episode>(
              topBar: topBar,
              header: _EpisodeHeader(episode: episode),
              more: RelatedItemsSection<Episode>(
                title: 'Mais episódios',
                icon: PhosphorIconsRegular.monitorPlay,
                tileHeight: CardSizes.episodeHeight,
                maxTileWidth: CardSizes.episodeMaxWidth,
                itemBuilder: (_, item) => EpisodeCard(
                  episode: item,
                  onTap: () =>
                      onOpenDetails?.call(ResourceType.episode, item.id),
                ),
              ),
            ),
            DetailsLocation(:final location) => _Content<Location>(
              topBar: topBar,
              header: _LocationHeader(location: location),
              more: RelatedItemsSection<Location>(
                title: 'Mais localizações',
                icon: PhosphorIconsRegular.planet,
                tileHeight: CardSizes.locationHeight,
                maxTileWidth: CardSizes.locationMaxWidth,
                itemBuilder: (_, item) => LocationCard(
                  location: item,
                  onTap: () =>
                      onOpenDetails?.call(ResourceType.location, item.id),
                ),
              ),
            ),
          },
        ),
      ),
    );
  }
}

/// Back arrow, logo and "Lista de favoritos" (same as the home hero row).
class _TopBar extends StatelessWidget {
  const _TopBar({this.onOpenFavorites});

  final VoidCallback? onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Voltar',
            icon: const Icon(PhosphorIconsRegular.caretLeft),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: AppLogo()),
          const SizedBox(width: 12),
          PillButton(
            label: 'Lista de favoritos',
            icon: PhosphorIconsRegular.heart,
            onPressed: onOpenFavorites,
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.topBar, required this.child});

  final Widget topBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar,
        Expanded(child: child),
      ],
    );
  }
}

class _Content<T> extends StatelessWidget {
  const _Content({
    required this.topBar,
    required this.header,
    required this.more,
  });

  final Widget topBar;
  final Widget header;
  final Widget more;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: topBar),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: header,
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SliverToBoxAdapter(child: more),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

/// Name (headline) + heart.
class _Title extends StatelessWidget {
  const _Title({required this.text, required this.favorite});

  final String text;
  final FavoriteItem favorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        FavoriteButton(item: favorite),
      ],
    );
  }
}

/// Icon + text, e.g. "♡ Vivo", "📅 January 13, 2014".
class _Attribute extends StatelessWidget {
  const _Attribute({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _CharacterHeader extends StatelessWidget {
  const _CharacterHeader({required this.character, this.onOpenDetails});

  final Character character;
  final OpenDetails? onOpenDetails;

  IconData get _genderIcon => switch (character.gender.toLowerCase()) {
    'male' => PhosphorIconsRegular.genderMale,
    'female' => PhosphorIconsRegular.genderFemale,
    'genderless' => PhosphorIconsRegular.genderIntersex,
    _ => PhosphorIconsRegular.question,
  };

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AppNetworkImage(url: character.imageUrl, width: 220, height: 220),
    );
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(text: character.name, favorite: character.toFavorite()),
        _Attribute(
          icon: PhosphorIconsRegular.monitorPlay,
          text: 'Participou de ${character.episodeCount} episódios',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _Attribute(
              icon: PhosphorIconsRegular.heartbeat,
              color: statusColor(character.status),
              text: character.status.label,
            ),
            _Attribute(
              icon: PhosphorIconsRegular.alien,
              text: speciesLabel(character.species),
            ),
            _Attribute(icon: _genderIcon, text: character.gender),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _PlaceCard(
              icon: PhosphorIconsRegular.planet,
              caption: 'Origem',
              name: character.originName,
              id: character.originId,
              onOpenDetails: onOpenDetails,
            ),
            _PlaceCard(
              icon: PhosphorIconsRegular.mapPin,
              caption: 'Última localização',
              name: character.locationName,
              id: character.locationId,
              onOpenDetails: onOpenDetails,
            ),
          ],
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth >= Breakpoints.compact
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image,
                const SizedBox(width: 24),
                Expanded(child: info),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [image, const SizedBox(height: 16), info],
            ),
    );
  }
}

/// Small origin / last-location card on the character page.
class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.icon,
    required this.caption,
    required this.name,
    required this.id,
    this.onOpenDetails,
  });

  final IconData icon;
  final String caption;
  final String name;
  final int? id;
  final OpenDetails? onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final id = this.id;
    return SizedBox(
      width: 150,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
          child: Column(
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 4),
              Text(caption, style: theme.textTheme.labelMedium),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              if (id != null) ...[
                DetailsChipButton(
                  onPressed: () =>
                      onOpenDetails?.call(ResourceType.location, id),
                ),
                FavoriteButton(
                  compact: true,
                  item: FavoriteItem(
                    type: ResourceType.location,
                    id: id,
                    name: name,
                  ),
                ),
              ] else
                const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodeHeader extends StatelessWidget {
  const _EpisodeHeader({required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(PhosphorIconsRegular.monitorPlay, size: 32),
        const SizedBox(height: 8),
        _Title(text: episode.name, favorite: episode.toFavorite()),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _Attribute(
              icon: PhosphorIconsRegular.calendarBlank,
              text: episode.airDate,
            ),
            _Attribute(icon: PhosphorIconsRegular.queue, text: episode.code),
          ],
        ),
        const SizedBox(height: 12),
        _Attribute(
          icon: PhosphorIconsRegular.users,
          text:
              '${episode.characterCount} personagens participaram deste episódio',
        ),
      ],
    );
  }
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader({required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(PhosphorIconsRegular.planet, size: 32),
        const SizedBox(height: 8),
        _Title(text: location.name, favorite: location.toFavorite()),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (location.type.isNotEmpty)
              _Attribute(
                icon: PhosphorIconsRegular.planet,
                text: location.type,
              ),
            if (location.dimension.isNotEmpty)
              _Attribute(
                icon: PhosphorIconsRegular.mapPin,
                text: location.dimension,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _Attribute(
          icon: PhosphorIconsRegular.users,
          text: '${location.residentCount} residentes',
        ),
      ],
    );
  }
}
