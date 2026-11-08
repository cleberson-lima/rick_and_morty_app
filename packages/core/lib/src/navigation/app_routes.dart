import '../domain/resource_type.dart';

/// Route paths shared between feature packages, so no package hardcodes
/// another package's URLs.
abstract final class AppRoutes {
  static const search = '/';
  static const favorites = '/favorites/';

  /// Relative to the search module, which is mounted at `/`.
  static const detailsPattern = '/details/:type/:id';

  static String details(ResourceType type, int id) =>
      '/details/${type.name}/$id';
}
