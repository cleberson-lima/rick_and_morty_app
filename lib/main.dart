// coverage:ignore-file
// Only loads storage and calls runApp; test/app_widget_test.dart covers the
// AppWidget it builds.

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.registerFontLicenses();
  final core = await CoreDependencies.load();
  runApp(AppWidget(core: core));
}
