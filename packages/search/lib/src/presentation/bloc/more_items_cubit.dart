import 'dart:math' as math;

import 'package:core/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/search_usecases.dart';

part 'more_items_cubit.freezed.dart';
part 'more_items_state.dart';

/// "Mais personagens / episódios / localizações" on the details pages: the
/// unfiltered list, one numbered page at a time.
class MoreItemsCubit<T> extends Cubit<MoreItemsState<T>> {
  MoreItemsCubit(this._search) : super(MoreItemsState<T>.loading(page: 1));

  /// The API always returns 20 items per page.
  static const pageSize = 20;

  final SearchUseCase<T> _search;
  int _request = 0;

  Future<void> load(int page) async {
    final request = ++_request;
    emit(MoreItemsState<T>.loading(page: page));
    final result = await _search('', page: page);
    // Tapping 2 then 3 quickly must not end on page 2.
    if (isClosed || request != _request) return;
    result.fold(
      (failure) {
        if (failure is CancelledFailure) return;
        emit(MoreItemsState<T>.error(failure: failure, page: page));
      },
      (result) => emit(
        MoreItemsState<T>.success(
          items: result.items,
          page: page,
          totalPages: math.max(1, (result.totalCount / pageSize).ceil()),
        ),
      ),
    );
  }

  Future<void> retry() => load(switch (state) {
    MoreItemsLoading(:final page) ||
    MoreItemsSuccess(:final page) ||
    MoreItemsError(:final page) => page,
  });
}

// Concrete types for the DI container.

class MoreCharactersCubit extends MoreItemsCubit<Character> {
  MoreCharactersCubit(SearchCharactersUseCase super.search);
}

class MoreEpisodesCubit extends MoreItemsCubit<Episode> {
  MoreEpisodesCubit(SearchEpisodesUseCase super.search);
}

class MoreLocationsCubit extends MoreItemsCubit<Location> {
  MoreLocationsCubit(SearchLocationsUseCase super.search);
}
