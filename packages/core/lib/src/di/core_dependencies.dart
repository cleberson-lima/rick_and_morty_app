import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_factory.dart';
import '../network/offline_status.dart';

/// Shared infrastructure, created once in `main()` and handed to the app and
/// to every feature's routes.
///
/// There is no DI container: each screen builds what it needs from these two
/// objects (e.g. `SearchApi(core.dio)`) in its `BlocProvider.create`, and
/// `BlocProvider` closes it with the screen.
class CoreDependencies {
  CoreDependencies({
    required this.preferences,
    Dio? dio,
    OfflineStatus? offlineStatus,
  }) : dio = dio ?? createDio(),
       offlineStatus = offlineStatus ?? OfflineStatus();

  /// Reads storage before `runApp`, so the theme and favorites start from
  /// their saved values without a flicker, and keeps the API's offline cache
  /// in the app's cache directory (the OS may clear it when space is low).
  ///
  /// [cacheRoot] finds the base directory; tests pass a temporary one.
  static Future<CoreDependencies> load({
    Future<Directory> Function() cacheRoot = getApplicationCacheDirectory,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final root = await cacheRoot();
    final offlineStatus = OfflineStatus();
    return CoreDependencies(
      preferences: preferences,
      offlineStatus: offlineStatus,
      dio: createDio(
        cacheDirectory: Directory('${root.path}/api'),
        offlineStatus: offlineStatus,
      ),
    );
  }

  final SharedPreferences preferences;

  /// API client (`createDio`); with the offline cache when built by [load].
  final Dio dio;

  /// `true` while the screens show saved data; [load] wires it to the cache.
  final OfflineStatus offlineStatus;
}
