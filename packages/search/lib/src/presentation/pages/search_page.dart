import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../widgets/result_cards.dart';
import '../widgets/search_results_view.dart';

/// One search field shared by three tabs (characters, episodes, locations).
/// Only the visible tab searches; switching tabs re-runs the current query
/// there if it is stale.
class SearchPage extends StatefulWidget {
  const SearchPage({this.onOpenDetails, this.onOpenFavorites, super.key});

  final void Function(ResourceType type, int id)? onOpenDetails;
  final VoidCallback? onOpenFavorites;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  static const _types = ResourceType.values;

  late final TabController _tabs = TabController(
    length: _types.length,
    vsync: this,
  )..addListener(_onTabChanged);
  final _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeBloc.add(const SearchSubmitted(''));
  }

  @override
  void dispose() {
    _tabs.dispose();
    _queryController.dispose();
    super.dispose();
  }

  SearchBloc<Object?> get _activeBloc => _blocFor(_types[_tabs.index]);

  SearchBloc<Object?> _blocFor(ResourceType type) => switch (type) {
    ResourceType.character => context.read<SearchBloc<Character>>(),
    ResourceType.episode => context.read<SearchBloc<Episode>>(),
    ResourceType.location => context.read<SearchBloc<Location>>(),
  };

  void _onTabChanged() {
    if (_tabs.indexIsChanging) return;
    final bloc = _activeBloc;
    final query = _queryController.text.trim();
    if (bloc.state.currentQuery != query) bloc.add(SearchSubmitted(query));
  }

  void _onQueryChanged(String value) {
    setState(() {}); // toggles the clear button
    _activeBloc.add(SearchQueryChanged(value));
  }

  void _clear() {
    _queryController.clear();
    _onQueryChanged('');
  }

  void _open(ResourceType type, int id) => widget.onOpenDetails?.call(type, id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            icon: const Icon(Icons.favorite_outline),
            onPressed: widget.onOpenFavorites,
          ),
          const ThemeToggleButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  controller: _queryController,
                  onChanged: _onQueryChanged,
                  onSubmitted: (value) =>
                      _activeBloc.add(SearchSubmitted(value)),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _queryController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar',
                            icon: const Icon(Icons.close),
                            onPressed: _clear,
                          ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabs,
                tabs: [for (final type in _types) Tab(text: type.pluralLabel)],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          SearchResultsView<Character>(
            type: ResourceType.character,
            itemBuilder: (_, character) => CharacterCard(
              character: character,
              onTap: () => _open(ResourceType.character, character.id),
            ),
          ),
          SearchResultsView<Episode>(
            type: ResourceType.episode,
            itemBuilder: (_, episode) => EpisodeCard(
              episode: episode,
              onTap: () => _open(ResourceType.episode, episode.id),
            ),
          ),
          SearchResultsView<Location>(
            type: ResourceType.location,
            itemBuilder: (_, location) => LocationCard(
              location: location,
              onTap: () => _open(ResourceType.location, location.id),
            ),
          ),
        ],
      ),
    );
  }
}
