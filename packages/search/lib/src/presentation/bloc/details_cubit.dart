import 'package:core/types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/models.dart';
import '../../data/search_api.dart';

part 'details_cubit.freezed.dart';
part 'details_state.dart';

/// Loads one resource by (type, id), so the details route works the same from
/// search results, favorites or a deep link.
class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this._api) : super(const DetailsState.loading());

  final SearchApi _api;

  Future<void> load(ResourceType type, int id) async {
    emit(const DetailsState.loading());
    final loaded = switch (type) {
      ResourceType.character => _toState(
        await _api.getCharacter(id),
        DetailsState.character,
      ),
      ResourceType.episode => _toState(
        await _api.getEpisode(id),
        DetailsState.episode,
      ),
      ResourceType.location => _toState(
        await _api.getLocation(id),
        DetailsState.location,
      ),
    };
    if (!isClosed) emit(loaded);
  }

  static DetailsState _toState<T>(
    Result<T> result,
    DetailsState Function(T data) onSuccess,
  ) => switch (result) {
    Success(:final data) => onSuccess(data),
    Failed(failure: NotFoundFailure()) => const DetailsState.notFound(),
    Failed(:final failure) => DetailsState.error(failure),
  };
}
