import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../bloc/search_bloc.dart';
import '../widgets/home_hero.dart';
import '../widgets/home_section.dart';
import '../widgets/result_cards.dart';
import '../widgets/search_results_view.dart';

/// Home page from the prototype ("Tela 01 - Página Inicial").
///
/// * **Overview** (empty search): hero, search field with "Filtrar por"
///   chips, a preview section per resource type and the footer.
/// * **Results**: typing, picking a filter or "Ver todos" shows the full,
///   paginated list of the selected type. Clearing the search or going back
///   returns to the overview.
class SearchPage extends StatefulWidget {
  const SearchPage({
    this.onOpenDetails,
    this.onOpenFavorites,
    this.heroImage,
    super.key,
  });

  final void Function(ResourceType type, int id)? onOpenDetails;
  final VoidCallback? onOpenFavorites;
  final Widget? heroImage;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _query = TextEditingController();
  final _scroll = ScrollController();

  /// Keeps the same text field (and its focus / keyboard) when the page
  /// switches between overview and results.
  final _searchFieldKey = GlobalKey();

  ResourceType _filter = ResourceType.character;
  bool _showAll = false;

  bool get _inResults => _showAll || _query.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final type in ResourceType.values) {
      _blocFor(type).add(const SearchSubmitted(''));
    }
  }

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  SearchBloc<Object?> _blocFor(ResourceType type) => switch (type) {
    ResourceType.character => context.read<SearchBloc<Character>>(),
    ResourceType.episode => context.read<SearchBloc<Episode>>(),
    ResourceType.location => context.read<SearchBloc<Location>>(),
  };

  void _onQueryChanged(String value) {
    setState(() {});
    _blocFor(_filter).add(SearchQueryChanged(value));
  }

  /// "Filtrar por" chip or "Ver todos": show every result of [type] for the
  /// current query.
  void _showType(ResourceType type) {
    setState(() {
      _filter = type;
      _showAll = true;
    });
    final query = _query.text.trim();
    final bloc = _blocFor(type);
    if (bloc.state.currentQuery != query) bloc.add(SearchSubmitted(query));
  }

  void _backToOverview() {
    _query.clear();
    FocusScope.of(context).unfocus();
    setState(() => _showAll = false);
    for (final type in ResourceType.values) {
      final bloc = _blocFor(type);
      if (bloc.state.currentQuery != '') bloc.add(const SearchSubmitted(''));
    }
  }

  void _open(ResourceType type, int id) => widget.onOpenDetails?.call(type, id);

  @override
  Widget build(BuildContext context) {
    final searchField = _SearchField(
      key: _searchFieldKey,
      controller: _query,
      onChanged: _onQueryChanged,
      onSubmitted: (value) => _blocFor(_filter).add(SearchSubmitted(value)),
      onClear: _backToOverview,
    );
    final filters = _FilterChips(selected: _filter, onSelected: _showType);

    return PopScope(
      canPop: !_inResults,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backToOverview();
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: _inResults
              ? _Results(
                  searchField: searchField,
                  filters: filters,
                  filter: _filter,
                  onBack: _backToOverview,
                  onOpen: _open,
                )
              : _Overview(
                  scroll: _scroll,
                  hero: HomeHero(
                    onOpenFavorites: widget.onOpenFavorites,
                    image: widget.heroImage,
                  ),
                  searchField: searchField,
                  filters: filters,
                  onSeeAll: _showType,
                  onOpen: _open,
                ),
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({
    required this.scroll,
    required this.hero,
    required this.searchField,
    required this.filters,
    required this.onSeeAll,
    required this.onOpen,
  });

  final ScrollController scroll;
  final Widget hero;
  final Widget searchField;
  final Widget filters;
  final ValueChanged<ResourceType> onSeeAll;
  final void Function(ResourceType type, int id) onOpen;

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
            title: 'Personagens',
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
            title: 'Episódios',
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
            title: 'Localizações',
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
          child: _Footer(
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

class _Results extends StatelessWidget {
  const _Results({
    required this.searchField,
    required this.filters,
    required this.filter,
    required this.onBack,
    required this.onOpen,
  });

  final Widget searchField;
  final Widget filters;
  final ResourceType filter;
  final VoidCallback onBack;
  final void Function(ResourceType type, int id) onOpen;

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
                tooltip: 'Voltar ao início',
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Personagem, episódio, localização...',
        suffixIcon: controller.text.isEmpty
            ? const Icon(PhosphorIconsRegular.magnifyingGlass)
            : IconButton(
                tooltip: 'Limpar',
                icon: const Icon(Icons.close),
                onPressed: onClear,
              ),
      ),
    );
  }
}

/// "Filtrar por:" Personagens / Localizações / Episódios.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final ResourceType selected;
  final ValueChanged<ResourceType> onSelected;

  static const _options = [
    (ResourceType.character, PhosphorIconsRegular.smiley),
    (ResourceType.location, PhosphorIconsRegular.planet),
    (ResourceType.episode, PhosphorIconsRegular.monitorPlay),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text('Filtrar por:', style: theme.textTheme.labelMedium),
          for (final (type, icon) in _options) ...[
            const SizedBox(width: 8),
            Semantics(
              selected: type == selected,
              button: true,
              child: PillButton(
                key: ValueKey('filter-${type.name}'),
                label: type.pluralLabel,
                icon: icon,
                filled: type == selected,
                onPressed: () => onSelected(type),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onBackToTop});

  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 8, 24),
      child: Row(
        children: [
          const Expanded(child: AppLogo()),
          TextButton.icon(
            onPressed: onBackToTop,
            iconAlignment: IconAlignment.end,
            icon: const Icon(PhosphorIconsRegular.arrowUp, size: 16),
            label: const Text('Voltar ao topo'),
          ),
        ],
      ),
    );
  }
}
