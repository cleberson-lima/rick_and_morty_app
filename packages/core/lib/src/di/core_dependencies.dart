import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_factory.dart';

/// Shared infrastructure, created once in `main()` and handed to the app and
/// to every feature's routes.
///
/// There is no DI container: each screen builds what it needs from these two
/// objects (e.g. `SearchApi(core.dio)`) in its `BlocProvider.create`, and
/// `BlocProvider` closes it with the screen.
class CoreDependencies {
  CoreDependencies({required this.preferences, Dio? dio})
    : dio = dio ?? createDio();

  /// Reads storage before `runApp`, so the theme and favorites start from
  /// their saved values without a flicker.
  static Future<CoreDependencies> load() async =>
      CoreDependencies(preferences: await SharedPreferences.getInstance());

  final SharedPreferences preferences;

  /// API client with the base URL and retry interceptor (`createDio`).
  final Dio dio;
}
