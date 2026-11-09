import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:search/search.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), FavoritesBindingsModule()];

  @override
  void routes(RouteManager r) {
    r
      ..module(AppRoutes.search, module: SearchModule())
      ..module('/favorites', module: FavoritesRoutesModule());
  }
}
