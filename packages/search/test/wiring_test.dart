import 'package:auto_injector/auto_injector.dart';
import 'package:core/core.dart';
import 'package:flutter_modular/flutter_modular.dart' show Module;
import 'package:flutter_test/flutter_test.dart';
import 'package:search/search.dart';
import 'package:search/src/presentation/bloc/details_cubit.dart';
import 'package:search/src/presentation/bloc/more_items_cubit.dart';
import 'package:search/src/presentation/bloc/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
