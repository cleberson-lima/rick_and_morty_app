import 'package:core/core.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/favorites_storage.dart';
import 'presentation/cubit/favorites_cubit.dart';
import 'presentation/pages/favorites_page.dart';

/// Favorites storage and the app-wide [FavoritesCubit]. Imported by the app
/// root, which provides the cubit above the router.
class FavoritesDataModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void exportedBinds(Injector i) {
    i
      ..addLazySingleton<FavoritesStorage>(FavoritesStorage.new)
      ..addLazySingleton<FavoritesCubit>(FavoritesCubit.new);
  }
}

/// Routes of the favorites feature, mounted at [AppRoutes.favorites].
class FavoritesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (_) => FavoritesPage(
        onOpen: (item) =>
            Modular.to.pushNamed(AppRoutes.details(item.type, item.id)),
      ),
    );
  }
}
