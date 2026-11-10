import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:search/search.dart';

/// App root: the router with every feature's routes, and the app-wide cubits
/// (theme, favorites) above it so every page reaches them through `context`.
class AppWidget extends StatefulWidget {
  const AppWidget({required this.core, this.initialLocation, super.key});

  final CoreDependencies core;

  /// First route to show; `/` (the home page) when `null`.
  final String? initialLocation;

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final GoRouter _router = GoRouter(
    initialLocation: widget.initialLocation ?? AppRoutes.search,
    routes: [...searchRoutes(widget.core), favoritesRoute()],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = widget.core.preferences;
    // Both global cubits are created and closed by their BlocProvider.
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(preferences)),
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit(FavoritesStorage(preferences))..load(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          // The app's texts are in AppStrings (pt-BR); these delegates put
          // Material's own strings (back tooltip, etc.) in Portuguese too.
          locale: const Locale('pt'),
          supportedLocales: const [Locale('pt')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: _router,
          // Features show a FavoriteSlot; here it becomes the real button.
          builder: (context, child) => FavoriteButtonProvider(
            child: BottomSafeArea(
              child: FavoritesErrorListener(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
