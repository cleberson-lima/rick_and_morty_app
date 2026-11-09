import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../bloc/search_bloc.dart';
import '../widgets/home/home_hero.dart';
import '../widgets/home/home_overview.dart';
import '../widgets/open_details.dart';
import '../widgets/search/filter_chips.dart';
import '../widgets/search/search_field.dart';
import '../widgets/search/search_results_panel.dart';

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

  final OpenDetails? onOpenDetails;
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
    final searchField = SearchField(
      key: _searchFieldKey,
      controller: _query,
      onChanged: _onQueryChanged,
      onSubmitted: (value) => _blocFor(_filter).add(SearchSubmitted(value)),
      onClear: _backToOverview,
    );
    final filters = FilterChips(selected: _filter, onSelected: _showType);

    return PopScope(
      canPop: !_inResults,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backToOverview();
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: _inResults
              ? SearchResultsPanel(
                  searchField: searchField,
                  filters: filters,
                  filter: _filter,
                  onBack: _backToOverview,
                  onOpen: _open,
                )
              : HomeOverview(
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
