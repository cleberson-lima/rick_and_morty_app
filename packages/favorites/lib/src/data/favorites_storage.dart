import 'dart:convert';

import 'package:core/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/favorite_item.dart';

/// Favorites saved on the device as one JSON array under [storageKey].
///
/// Never throws: every call returns a `Result` with the updated list, or
/// `Failure.cache()` when reading or writing fails.
class FavoritesStorage {
  const FavoritesStorage(this._prefs);

  static const storageKey = 'favorites_v1';

  final SharedPreferences _prefs;

  Future<Result<List<FavoriteItem>>> getAll() => _guard(() async => _read());

  /// Saves [item] at the top, replacing an older entry for the same resource.
  Future<Result<List<FavoriteItem>>> add(FavoriteItem item) => _update(
    (items) => [item, ...items.where((i) => !_same(i, item.type, item.id))],
  );

  Future<Result<List<FavoriteItem>>> remove(ResourceType type, int id) =>
      _update((items) => items.where((i) => !_same(i, type, id)).toList());

  List<FavoriteItem> _read() {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return const [];
    return List.unmodifiable([
      for (final entry in jsonDecode(raw) as List<Object?>)
        FavoriteItem.fromJson(entry! as Map<String, Object?>),
    ]);
  }

  Future<Result<List<FavoriteItem>>> _update(
    List<FavoriteItem> Function(List<FavoriteItem> items) change,
  ) => _guard(() async {
    final updated = List<FavoriteItem>.unmodifiable(change(_read()));
    final saved = await _prefs.setString(
      storageKey,
      jsonEncode([for (final item in updated) item.toJson()]),
    );
    if (!saved) throw StateError('SharedPreferences refused to save');
    return updated;
  });

  static bool _same(FavoriteItem item, ResourceType type, int id) =>
      item.type == type && item.id == id;

  static Future<Result<List<FavoriteItem>>> _guard(
    Future<List<FavoriteItem>> Function() body,
  ) => Result.guard(body, toFailure: (_) => const Failure.cache());
}
