import 'package:auto_injector/auto_injector.dart';
import 'package:core/core.dart';
import 'package:flutter_modular/flutter_modular.dart' show Module;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:search/src/domain/repositories/search_repository.dart';
import 'package:search/src/domain/usecases/details_usecases.dart';
import 'package:search/src/domain/usecases/search_usecases.dart';
import 'package:search/src/presentation/bloc/details_cubit.dart';
import 'package:search/src/presentation/bloc/more_items_cubit.dart';
import 'package:search/src/presentation/bloc/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_data.dart';

class _MockRepository extends Mock implements SearchRepository {}

void main() {
  group('use cases', () {
    late _MockRepository repository;
    const page = PageResult<Never>(items: [], totalCount: 0);

    setUp(() => repository = _MockRepository());

    test('search use cases trim the query and pass the page', () async {
      when(
        () => repository.searchCharacters('rick', page: 2),
      ).thenAnswer((_) async => const Right(page));
      when(
        () => repository.searchEpisodes('pilot', page: 1),
      ).thenAnswer((_) async => const Right(page));
      when(
        () => repository.searchLocations('earth', page: 1),
      ).thenAnswer((_) async => const Right(page));

      await SearchCharactersUseCase(repository)('  rick ', page: 2);
      await SearchEpisodesUseCase(repository)('pilot ');
      await SearchLocationsUseCase(repository)(' earth');

      verify(() => repository.searchCharacters('rick', page: 2)).called(1);
      verify(() => repository.searchEpisodes('pilot', page: 1)).called(1);
      verify(() => repository.searchLocations('earth', page: 1)).called(1);
    });

    test('details use cases fetch by id', () async {
      when(
        () => repository.getCharacter(1),
      ).thenAnswer((_) async => const Right(rick));
      when(
        () => repository.getEpisode(1),
      ).thenAnswer((_) async => const Left(Failure.notFound()));
      when(
        () => repository.getLocation(1),
      ).thenAnswer((_) async => const Left(Failure.network()));

      expect(
        await GetCharacterUseCase(repository)(1),
        const Right<Failure, Character>(rick),
      );
      expect(
        await GetEpisodeUseCase(repository)(1),
        const Left<Failure, Episode>(Failure.notFound()),
      );
      expect(
        await GetLocationUseCase(repository)(1),
        const Left<Failure, Location>(Failure.network()),
      );
    });
  });

  test('SearchModule resolves every Bloc with its dependencies', () async {
    SharedPreferences.setMockInitialValues({});
    await CoreModule.initialize();

    final injector = AutoInjector();
    final Module module = SearchModule();
    for (final imported in module.imports) {
      imported.exportedBinds(injector);
    }
    module.binds(injector);
    injector.commit();

    final first = injector.get<CharacterSearchBloc>();
    final second = injector.get<CharacterSearchBloc>();
    expect(identical(first, second), isFalse, reason: 'Blocs are factories');
    expect(injector.get<EpisodeSearchBloc>(), isA<SearchBloc<Episode>>());
    expect(injector.get<LocationSearchBloc>(), isA<SearchBloc<Location>>());
    expect(injector.get<DetailsCubit>(), isA<DetailsCubit>());
    expect(
      injector.get<MoreCharactersCubit>(),
      isA<MoreItemsCubit<Character>>(),
    );
    expect(injector.get<MoreEpisodesCubit>(), isA<MoreItemsCubit<Episode>>());
    expect(injector.get<MoreLocationsCubit>(), isA<MoreItemsCubit<Location>>());

    await Future.wait([first.close(), second.close()]);
  });
}
