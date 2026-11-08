import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite_item_model.dart';

abstract interface class FavoritesLocalDataSource {
  List<FavoriteItemModel> read();

  Future<void> write(List<FavoriteItemModel> items);
}

/// Stores the favorites as one JSON array under [storageKey].
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  const FavoritesLocalDataSourceImpl(this._prefs);

  static const storageKey = 'favorites_v1';

  final SharedPreferences _prefs;

  @override
  List<FavoriteItemModel> read() {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<Object?>;
    return [
      for (final entry in decoded)
        FavoriteItemModel.fromJson(entry! as Map<String, Object?>),
    ];
  }

  @override
  Future<void> write(List<FavoriteItemModel> items) async {
    final saved = await _prefs.setString(
      storageKey,
      jsonEncode([for (final item in items) item.toJson()]),
    );
    if (!saved) throw StateError('SharedPreferences refused to save');
  }
}
