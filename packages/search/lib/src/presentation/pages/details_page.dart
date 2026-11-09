import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../bloc/details_cubit.dart';
import '../widgets/cards/cards.dart';
import '../widgets/details/character_details_header.dart';
import '../widgets/details/details_layouts.dart';
import '../widgets/details/details_top_bar.dart';
import '../widgets/details/episode_details_header.dart';
import '../widgets/details/location_details_header.dart';
import '../widgets/details/related_items_section.dart';
import '../widgets/open_details.dart';

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
    final topBar = DetailsTopBar(onOpenFavorites: onOpenFavorites);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) => switch (state) {
            DetailsLoading() => DetailsMessageLayout(
              topBar: topBar,
              child: const Center(child: CircularProgressIndicator()),
            ),
            DetailsNotFound() => DetailsMessageLayout(
              topBar: topBar,
              child: MessageView(
                icon: Icons.search_off,
                title: context.l10n.notFoundTitle,
                message: context.l10n.notFoundMessage,
              ),
            ),
            DetailsError(:final failure) => DetailsMessageLayout(
              topBar: topBar,
              child: MessageView.failure(failure: failure, onRetry: onRetry),
            ),
            DetailsCharacter(:final character) => DetailsContentLayout(
              topBar: topBar,
              header: CharacterDetailsHeader(
                character: character,
                onOpenDetails: onOpenDetails,
              ),
              related: RelatedItemsSection<Character>(
                title: context.l10n.moreCharacters,
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
            DetailsEpisode(:final episode) => DetailsContentLayout(
              topBar: topBar,
              header: EpisodeDetailsHeader(episode: episode),
              related: RelatedItemsSection<Episode>(
                title: context.l10n.moreEpisodes,
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
            DetailsLocation(:final location) => DetailsContentLayout(
              topBar: topBar,
              header: LocationDetailsHeader(location: location),
              related: RelatedItemsSection<Location>(
                title: context.l10n.moreLocations,
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
