import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/data/models/models.dart';
import 'package:search/src/data/search_api.dart';
import 'package:search/src/presentation/bloc/details_cubit.dart';

import '../test_data.dart';

class _MockApi extends Mock implements SearchApi {}

void main() {
  late _MockApi api;

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

  setUp(() => api = _MockApi());

  DetailsCubit build() => DetailsCubit(api);

  blocTest<DetailsCubit, DetailsState>(
    'loads a character',
    setUp: () => when(
      () => api.getCharacter(1),
    ).thenAnswer((_) async => const Success(rick)),
    build: build,
    act: (cubit) => cubit.load(ResourceType.character, 1),
    expect: () => const [DetailsState.loading(), DetailsState.character(rick)],
  );

  blocTest<DetailsCubit, DetailsState>(
    'loads an episode',
    setUp: () => when(
      () => api.getEpisode(1),
    ).thenAnswer((_) async => const Success(episode)),
    build: build,
    act: (cubit) => cubit.load(ResourceType.episode, 1),
    expect: () => const [DetailsState.loading(), DetailsState.episode(episode)],
  );

  blocTest<DetailsCubit, DetailsState>(
    'loads a location',
    setUp: () => when(
      () => api.getLocation(1),
    ).thenAnswer((_) async => const Success(location)),
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
      () => api.getCharacter(9999),
    ).thenAnswer((_) async => const Failed(Failure.notFound())),
    build: build,
    act: (cubit) => cubit.load(ResourceType.character, 9999),
    expect: () => const [DetailsState.loading(), DetailsState.notFound()],
  );

  blocTest<DetailsCubit, DetailsState>(
    'other failures become error',
    setUp: () => when(
      () => api.getCharacter(1),
    ).thenAnswer((_) async => const Failed(Failure.network())),
    build: build,
    act: (cubit) => cubit.load(ResourceType.character, 1),
    expect: () => [
      const DetailsState.loading(),
      const DetailsState.error(Failure.network()),
    ],
  );
}
