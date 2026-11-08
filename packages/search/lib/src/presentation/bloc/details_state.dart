part of 'details_cubit.dart';

@freezed
sealed class DetailsState with _$DetailsState {
  const factory DetailsState.loading() = DetailsLoading;
  const factory DetailsState.character(Character character) = DetailsCharacter;
  const factory DetailsState.episode(Episode episode) = DetailsEpisode;
  const factory DetailsState.location(Location location) = DetailsLocation;
  const factory DetailsState.notFound() = DetailsNotFound;
  const factory DetailsState.error(String message) = DetailsError;
}
