import 'package:core/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/favorite_item.dart';

part 'favorite_item_model.freezed.dart';
part 'favorite_item_model.g.dart';

@freezed
abstract class FavoriteItemModel with _$FavoriteItemModel {
  const FavoriteItemModel._();

  const factory FavoriteItemModel({
    required ResourceType type,
    required int id,
    required String name,
    String? subtitle,
    String? imageUrl,
  }) = _FavoriteItemModel;

  factory FavoriteItemModel.fromJson(Map<String, Object?> json) =>
      _$FavoriteItemModelFromJson(json);

  factory FavoriteItemModel.fromEntity(FavoriteItem item) => FavoriteItemModel(
    type: item.type,
    id: item.id,
    name: item.name,
    subtitle: item.subtitle,
    imageUrl: item.imageUrl,
  );

  FavoriteItem toEntity() => FavoriteItem(
    type: type,
    id: id,
    name: name,
    subtitle: subtitle,
    imageUrl: imageUrl,
  );
}
