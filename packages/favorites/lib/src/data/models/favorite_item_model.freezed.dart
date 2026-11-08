// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteItemModel {

 ResourceType get type; int get id; String get name; String? get subtitle; String? get imageUrl;
/// Create a copy of FavoriteItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteItemModelCopyWith<FavoriteItemModel> get copyWith => _$FavoriteItemModelCopyWithImpl<FavoriteItemModel>(this as FavoriteItemModel, _$identity);

  /// Serializes this FavoriteItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FavoriteItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteItemModel&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FavoriteItemModel;
  return Object.hash(runtimeType,_this.type,_this.id,_this.name,_this.subtitle,_this.imageUrl);
}

@override
String toString() {
  final _this = this as FavoriteItemModel;
  return 'FavoriteItemModel(type: ${_this.type}, id: ${_this.id}, name: ${_this.name}, subtitle: ${_this.subtitle}, imageUrl: ${_this.imageUrl})';
}


}

/// @nodoc
abstract mixin class $FavoriteItemModelCopyWith<$Res>  {
  factory $FavoriteItemModelCopyWith(FavoriteItemModel value, $Res Function(FavoriteItemModel) _then) = _$FavoriteItemModelCopyWithImpl;
@useResult
$Res call({
 ResourceType type, int id, String name, String? subtitle, String? imageUrl
});




}
/// @nodoc
class _$FavoriteItemModelCopyWithImpl<$Res>
    implements $FavoriteItemModelCopyWith<$Res> {
  _$FavoriteItemModelCopyWithImpl(this._self, this._then);

  final FavoriteItemModel _self;
  final $Res Function(FavoriteItemModel) _then;

/// Create a copy of FavoriteItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? name = null,Object? subtitle = freezed,Object? imageUrl = freezed,}) {
  return _then(FavoriteItemModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ResourceType,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteItemModel].
extension FavoriteItemModelPatterns on FavoriteItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteItemModel value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ResourceType type,  int id,  String name,  String? subtitle,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteItemModel() when $default != null:
return $default(_that.type,_that.id,_that.name,_that.subtitle,_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ResourceType type,  int id,  String name,  String? subtitle,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _FavoriteItemModel():
return $default(_that.type,_that.id,_that.name,_that.subtitle,_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ResourceType type,  int id,  String name,  String? subtitle,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteItemModel() when $default != null:
return $default(_that.type,_that.id,_that.name,_that.subtitle,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteItemModel extends FavoriteItemModel {
  const _FavoriteItemModel({required this.type, required this.id, required this.name, this.subtitle, this.imageUrl}): super._();
  factory _FavoriteItemModel.fromJson(Map<String, dynamic> json) => _$FavoriteItemModelFromJson(json);

@override final  ResourceType type;
@override final  int id;
@override final  String name;
@override final  String? subtitle;
@override final  String? imageUrl;

/// Create a copy of FavoriteItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteItemModelCopyWith<_FavoriteItemModel> get copyWith => __$FavoriteItemModelCopyWithImpl<_FavoriteItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteItemModel&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,id,name,subtitle,imageUrl);
}

@override
String toString() {
    return 'FavoriteItemModel(type: $type, id: $id, name: $name, subtitle: $subtitle, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$FavoriteItemModelCopyWith<$Res> implements $FavoriteItemModelCopyWith<$Res> {
  factory _$FavoriteItemModelCopyWith(_FavoriteItemModel value, $Res Function(_FavoriteItemModel) _then) = __$FavoriteItemModelCopyWithImpl;
@override @useResult
$Res call({
 ResourceType type, int id, String name, String? subtitle, String? imageUrl
});




}
/// @nodoc
class __$FavoriteItemModelCopyWithImpl<$Res>
    implements _$FavoriteItemModelCopyWith<$Res> {
  __$FavoriteItemModelCopyWithImpl(this._self, this._then);

  final _FavoriteItemModel _self;
  final $Res Function(_FavoriteItemModel) _then;

/// Create a copy of FavoriteItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? name = null,Object? subtitle = freezed,Object? imageUrl = freezed,}) {
  return _then(_FavoriteItemModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ResourceType,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
