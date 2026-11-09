import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../cards/cards.dart';
import '../open_details.dart';
import 'search_results_view.dart';

/// Search mode of the home page: back arrow, search field, filters and the
/// full, paginated results of the selected type.
class SearchResultsPanel extends StatelessWidget {
  const SearchResultsPanel({
    required this.searchField,
    required this.filters,
    required this.filter,
    required this.onBack,
    required this.onOpen,
    super.key,
  });

  final Widget searchField;
  final Widget filters;
  final ResourceType filter;
  final VoidCallback onBack;
  final OpenDetails onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                tooltip: context.l10n.backToHome,
                icon: const Icon(PhosphorIconsRegular.caretLeft),
                onPressed: onBack,
              ),
              Expanded(child: searchField),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: filters,
        ),
        Expanded(
          child: switch (filter) {
            ResourceType.character => SearchResultsView<Character>(
              key: const ValueKey(ResourceType.character),
              type: ResourceType.character,
              itemBuilder: (_, character) => CharacterCard(
                character: character,
                onTap: () => onOpen(ResourceType.character, character.id),
              ),
            ),
            ResourceType.episode => SearchResultsView<Episode>(
              key: const ValueKey(ResourceType.episode),
              type: ResourceType.episode,
              itemBuilder: (_, episode) => EpisodeCard(
                episode: episode,
                onTap: () => onOpen(ResourceType.episode, episode.id),
              ),
            ),
            ResourceType.location => SearchResultsView<Location>(
              key: const ValueKey(ResourceType.location),
              type: ResourceType.location,
              itemBuilder: (_, location) => LocationCard(
                location: location,
                onTap: () => onOpen(ResourceType.location, location.id),
              ),
            ),
          },
        ),
      ],
    );
  }
}
