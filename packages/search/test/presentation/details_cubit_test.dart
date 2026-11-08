import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/domain/entities/episode.dart';
import 'package:search/src/domain/entities/location.dart';
import 'package:search/src/domain/usecases/details_usecases.dart';
import 'package:search/src/presentation/bloc/details_cubit.dart';

import '../test_data.dart';

class _MockGetCharacter extends Mock implements GetCharacterUseCase {}

class _MockGetEpisode extends Mock implements GetEpisodeUseCase {}

class _MockGetLocation extends Mock implements GetLocationUseCase {}

void main() {
  late _MockGetCharacter getCharacter;
  late _MockGetEpisode getEpisode;
  late _MockGetLocation getLocation;

  const episode = Episode(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    code: 'S01E01',
    characterCount: 19,
  );
  const location = Location(
    id: 1,
    name: 'Earth (C-137)',
    type: 'Planet',
    dimension: 'Dimension C-137',
    residentCount: 27,
  );

  setUp(() {
    getCharacter = _MockGetCharacter();
    getEpisode = _MockGetEpisode();
    getLocation = _MockGetLocation();
  });

  DetailsCubit build() => DetailsCubit(getCharacter, getEpisode, getLocation);

  blocTest<DetailsCubit, DetailsState>(
    'loads a character',
    setUp: () =>
        when(() => getCharacter(1)).thenAnswer((_) async => const Right(rick)),
    build: build,
    act: (cubit) => cubit.load(ResourceType.character, 1),
    expect: () => const [DetailsState.loading(), DetailsState.character(rick)],
  );

  blocTest<DetailsCubit, DetailsState>(
    'loads an episode',
    setUp: () =>
        when(() => getEpisode(1)).thenAnswer((_) async => const Right(episode)),
    build: build,
    act: (cubit) => cubit.load(ResourceType.episode, 1),
    expect: () => const [DetailsState.loading(), DetailsState.episode(episode)],
  );

  blocTest<DetailsCubit, DetailsState>(
    'loads a location',
    setUp: () => when(
      () => getLocation(1),
    ).thenAnswer((_) async => const Right(location)),
    build: build,
    act: (cubit) => cubit.load(ResourceType.location, 1),
    expect: () => const [
      DetailsState.loading(),
      DetailsState.location(location),
    ],
  );

  blocTest<DetailsCubit, DetailsState>(
    '404 becomes notFound',
    setUp: () => when(
      () => getCharacter(9999),
    ).thenAnswer((_) async => const Left(Failure.notFound())),
    build: build,
    act: (cubit) => cubit.load(ResourceType.character, 9999),
    expect: () => const [DetailsState.loading(), DetailsState.notFound()],
  );

  blocTest<DetailsCubit, DetailsState>(
    'other failures become error',
    setUp: () => when(
      () => getCharacter(1),
    ).thenAnswer((_) async => const Left(Failure.network())),
    build: build,
    act: (cubit) => cubit.load(ResourceType.character, 1),
    expect: () => [
      const DetailsState.loading(),
      DetailsState.error(const Failure.network().message),
    ],
  );
}
