import '../types/resource_type.dart';

/// Route paths shared between feature packages, so no package hardcodes
/// another package's URLs.
abstract final class AppRoutes {
  static const search = '/';
  static const favorites = '/favorites';

  /// Path pattern of the details route; build a link with [details].
  static const detailsPattern = '/details/:type/:id';

  static String details(ResourceType type, int id) =>
      '/details/${type.name}/$id';
}
