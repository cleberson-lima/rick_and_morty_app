import 'package:core/core.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Provides the app-wide cubits (theme, favorites) above the router so every
/// page reaches them through `context`.
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: Modular.get<ThemeCubit>()),
        BlocProvider<FavoritesCubit>(
          create: (_) => Modular.get<FavoritesCubit>()..load(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          title: 'Rick and Morty',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: Modular.routerConfig,
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
