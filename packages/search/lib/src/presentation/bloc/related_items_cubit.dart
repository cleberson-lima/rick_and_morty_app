import 'dart:math' as math;

import 'package:core/types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/models.dart';
import '../../data/search_api.dart';

part 'related_items_cubit.freezed.dart';
part 'related_items_state.dart';

/// "Mais personagens / episódios / localizações" on the details pages: the
/// unfiltered list, one numbered page at a time.
class RelatedItemsCubit<T> extends Cubit<RelatedItemsState<T>> {
  RelatedItemsCubit(this._search)
    : super(RelatedItemsState<T>.loading(page: 1));

  /// The API always returns 20 items per page.
  static const pageSize = 20;

  final SearchFunction<T> _search;
  int _request = 0;

  Future<void> load(int page) async {
    final request = ++_request;
    emit(RelatedItemsState<T>.loading(page: page));
    final result = await _search('', page: page);
    // Tapping 2 then 3 quickly must not end on page 2.
    if (isClosed || request != _request) return;
    switch (result) {
      case Success(data: final result):
        emit(
          RelatedItemsState<T>.success(
            items: result.items,
            page: page,
            totalPages: math.max(1, (result.totalCount / pageSize).ceil()),
          ),
        );
      case Failed(failure: CancelledFailure()):
        return;
      case Failed(:final failure):
        emit(RelatedItemsState<T>.error(failure: failure, page: page));
    }
  }

  Future<void> retry() => load(switch (state) {
    RelatedItemsLoading(:final page) ||
    RelatedItemsSuccess(:final page) ||
    RelatedItemsError(:final page) => page,
  });
}

// Concrete types for the DI container.

class RelatedCharactersCubit extends RelatedItemsCubit<Character> {
  RelatedCharactersCubit(SearchApi api) : super(api.searchCharacters);
}

class RelatedEpisodesCubit extends RelatedItemsCubit<Episode> {
  RelatedEpisodesCubit(SearchApi api) : super(api.searchEpisodes);
}

class RelatedLocationsCubit extends RelatedItemsCubit<Location> {
  RelatedLocationsCubit(SearchApi api) : super(api.searchLocations);
}
