import 'package:freezed_annotation/freezed_annotation.dart';

import 'resource_type.dart';

part 'favorite_item.freezed.dart';
part 'favorite_item.g.dart';

/// Minimal snapshot of a favorited resource: enough to render it in the
/// favorites list without hitting the API, plus (type, id) to open details.
///
/// Lives in `core` so features can mark items as favorites (through
/// `FavoriteSlot`) without depending on the `favorites` package, which
/// stores these snapshots as JSON.
@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    required ResourceType type,
    required int id,
    required String name,
    String? subtitle,
    String? imageUrl,
  }) = _FavoriteItem;

  factory FavoriteItem.fromJson(Map<String, Object?> json) =>
      _$FavoriteItemFromJson(json);
}

extension FavoriteItemListX on List<FavoriteItem> {
  bool containsResource(ResourceType type, int id) =>
      any((item) => item.type == type && item.id == id);
}
