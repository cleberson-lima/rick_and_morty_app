import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_factory.dart';
import '../theme/theme_cubit.dart';

/// Shared infrastructure, imported by every feature module.
class CoreModule extends Module {
  static SharedPreferences? _prefs;

  /// Must be awaited in `main()` before `runApp`, so that synchronous
  /// consumers (theme, favorites) can read storage on startup without flicker.
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  void exportedBinds(Injector i) {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('Call CoreModule.initialize() before runApp().');
    }
    i
      ..addInstance<SharedPreferences>(prefs)
      ..addSingleton<Dio>(createDio)
      ..addSingleton<ThemeCubit>(ThemeCubit.new);
  }
}
