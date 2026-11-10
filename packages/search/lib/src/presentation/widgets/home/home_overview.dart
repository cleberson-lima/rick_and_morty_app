import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../cards/cards.dart';
import '../open_details.dart';
import 'home_footer.dart';
import 'home_section.dart';

/// The home page with an empty search: hero, search field and filters, one
/// preview section per resource type and the footer.
class HomeOverview extends StatelessWidget {
  const HomeOverview({
    required this.scroll,
    required this.hero,
    required this.searchField,
    required this.filters,
    required this.onSeeAll,
    required this.onOpen,
    super.key,
  });

  final ScrollController scroll;
  final Widget hero;
  final Widget searchField;
  final Widget filters;
  final ValueChanged<ResourceType> onSeeAll;
  final OpenDetails onOpen;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scroll,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(child: hero),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [searchField, const SizedBox(height: 12), filters],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HomeSection<Character>(
            title: AppStrings.homeSectionCharacters,
            tileHeight: CardSizes.characterHeight,
            maxTileWidth: CardSizes.characterMaxWidth,
            onSeeAll: () => onSeeAll(ResourceType.character),
            itemBuilder: (_, character) => CharacterCard(
              character: character,
              onTap: () => onOpen(ResourceType.character, character.id),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HomeSection<Episode>(
            title: AppStrings.homeSectionEpisodes,
            tileHeight: CardSizes.episodeHeight,
            maxTileWidth: CardSizes.episodeMaxWidth,
            onSeeAll: () => onSeeAll(ResourceType.episode),
            itemBuilder: (_, episode) => EpisodeCard(
              episode: episode,
              onTap: () => onOpen(ResourceType.episode, episode.id),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HomeSection<Location>(
            title: AppStrings.homeSectionLocations,
            tileHeight: CardSizes.locationHeight,
            maxTileWidth: CardSizes.locationMaxWidth,
            onSeeAll: () => onSeeAll(ResourceType.location),
            itemBuilder: (_, location) => LocationCard(
              location: location,
              onTap: () => onOpen(ResourceType.location, location.id),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HomeFooter(
            onBackToTop: () => scroll.animateTo(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            ),
          ),
        ),
      ],
    );
  }
}
