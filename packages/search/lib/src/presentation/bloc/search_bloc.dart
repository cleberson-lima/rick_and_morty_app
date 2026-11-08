import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/search_usecases.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

/// Waits for [duration] of silence, then runs only the latest event,
/// abandoning a handler that is still awaiting an older one.
EventTransformer<E> debounceRestartable<E>(Duration duration) =>
    (events, mapper) =>
        restartable<E>().call(events.debounce(duration), mapper);

/// Search + infinite scroll for one resource type.
///
/// Stale results are discarded twice over: the data source cancels the
/// previous HTTP request, and [_generation] drops any response that arrives
/// after a newer search started (e.g. a submit racing a debounced keystroke).
class SearchBloc<T> extends Bloc<SearchEvent, SearchState<T>> {
  SearchBloc(this._search, {Duration debounce = defaultDebounce})
    : super(SearchState<T>.initial()) {
    on<SearchQueryChanged>(
      (event, emit) => _runSearch(event.query, emit),
      transformer: debounceRestartable(debounce),
    );
    on<SearchSubmitted>(
      (event, emit) => _runSearch(event.query, emit, force: true),
      transformer: restartable(),
    );
    on<SearchNextPageRequested>(_onNextPage, transformer: droppable());
  }

  static const defaultDebounce = Duration(milliseconds: 400);

  final SearchUseCase<T> _search;
  int _generation = 0;

  Future<void> _runSearch(
    String rawQuery,
    Emitter<SearchState<T>> emit, {
    bool force = false,
  }) async {
    final query = rawQuery.trim();
    // Typing "rick" → "rick " shouldn't fire a second identical request.
    if (!force && query == state.currentQuery && state is! SearchError<T>) {
      return;
    }

    final generation = ++_generation;
    emit(SearchState<T>.loading(query: query));
    final result = await _search(query);
    if (generation != _generation || emit.isDone) return;

    result.fold(
      (failure) {
        switch (failure) {
          case CancelledFailure():
            return;
          case NotFoundFailure():
            emit(SearchState<T>.notFound(query: query));
          default:
            emit(SearchState<T>.error(query: query, message: failure.message));
        }
      },
      (page) => emit(
        page.items.isEmpty
            ? SearchState<T>.empty(query: query)
            : SearchState<T>.success(
                query: query,
                items: page.items,
                totalCount: page.totalCount,
                nextPage: page.nextPage,
              ),
      ),
    );
  }

  Future<void> _onNextPage(
    SearchNextPageRequested event,
    Emitter<SearchState<T>> emit,
  ) async {
    final current = state;
    if (current is! SearchSuccess<T> ||
        current.nextPage == null ||
        current.isLoadingMore ||
        (current.loadMoreError != null && !event.retry)) {
      return;
    }

    final generation = _generation;
    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));
    final result = await _search(current.query, page: current.nextPage!);
    if (generation != _generation) return;

    result.fold(
      (failure) {
        if (failure is CancelledFailure) return;
        emit(
          current.copyWith(
            isLoadingMore: false,
            loadMoreError: failure.message,
          ),
        );
      },
      (page) => emit(
        current.copyWith(
          items: [...current.items, ...page.items],
          nextPage: page.nextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}

// Concrete types so the DI container can build each tab's Bloc.

class CharacterSearchBloc extends SearchBloc<Character> {
  CharacterSearchBloc(SearchCharactersUseCase super.search);
}

class EpisodeSearchBloc extends SearchBloc<Episode> {
  EpisodeSearchBloc(SearchEpisodesUseCase super.search);
}

class LocationSearchBloc extends SearchBloc<Location> {
  LocationSearchBloc(SearchLocationsUseCase super.search);
}
