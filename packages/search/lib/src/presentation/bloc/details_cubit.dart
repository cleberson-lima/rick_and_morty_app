import 'package:core/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/details_usecases.dart';

part 'details_cubit.freezed.dart';
part 'details_state.dart';

/// Loads one resource by (type, id), so the details route works the same from
/// search results, favorites or a deep link.
class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this._getCharacter, this._getEpisode, this._getLocation)
    : super(const DetailsState.loading());

  final GetCharacterUseCase _getCharacter;
  final GetEpisodeUseCase _getEpisode;
  final GetLocationUseCase _getLocation;

  Future<void> load(ResourceType type, int id) async {
    emit(const DetailsState.loading());
    final result = switch (type) {
      ResourceType.character => (await _getCharacter(
        id,
      )).map(DetailsState.character),
      ResourceType.episode => (await _getEpisode(id)).map(DetailsState.episode),
      ResourceType.location => (await _getLocation(
        id,
      )).map(DetailsState.location),
    };
    if (isClosed) return;
    emit(
      result.fold(
        (failure) => failure is NotFoundFailure
            ? const DetailsState.notFound()
            : DetailsState.error(failure),
        (state) => state,
      ),
    );
  }
}
