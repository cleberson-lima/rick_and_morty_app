// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteItemModel _$FavoriteItemModelFromJson(Map<String, dynamic> json) =>
    _FavoriteItemModel(
      type: $enumDecode(_$ResourceTypeEnumMap, json['type']),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$FavoriteItemModelToJson(_FavoriteItemModel instance) =>
    <String, dynamic>{
      'type': _$ResourceTypeEnumMap[instance.type]!,
      'id': instance.id,
      'name': instance.name,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.character: 'character',
  ResourceType.episode: 'episode',
  ResourceType.location: 'location',
};
