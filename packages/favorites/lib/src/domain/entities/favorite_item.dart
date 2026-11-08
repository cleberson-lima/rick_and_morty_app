import 'package:core/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_item.freezed.dart';

/// Minimal snapshot of a favorited resource: enough to render it in the
/// favorites list without hitting the API, plus (type, id) to open details.
@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    required ResourceType type,
    required int id,
    required String name,
    String? subtitle,
    String? imageUrl,
  }) = _FavoriteItem;
}

extension FavoriteItemListX on List<FavoriteItem> {
  bool containsResource(ResourceType type, int id) =>
      any((item) => item.type == type && item.id == id);
}
