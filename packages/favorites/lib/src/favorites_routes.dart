import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import 'presentation/pages/favorites_page.dart';

/// The favorites list at [AppRoutes.favorites]. It reads the app-wide
/// `FavoritesCubit`, which the app root provides above the router.
GoRoute favoritesRoute() => GoRoute(
  path: AppRoutes.favorites,
  builder: (context, state) => FavoritesPage(
    onOpen: (item) => context.push(AppRoutes.details(item.type, item.id)),
  ),
);
