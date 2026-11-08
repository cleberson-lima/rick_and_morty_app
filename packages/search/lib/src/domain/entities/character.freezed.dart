// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Character {

 int get id; String get name; CharacterStatus get status; String get species; String get type; String get gender; String get originName; String get locationName;/// Ids of the origin / last location, or `null` when unknown.
 int? get originId; int? get locationId; String get imageUrl; int get episodeCount;
/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterCopyWith<Character> get copyWith => _$CharacterCopyWithImpl<Character>(this as Character, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Character;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Character&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.species, _this.species) || other.species == _this.species)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.originName, _this.originName) || other.originName == _this.originName)&&(identical(other.locationName, _this.locationName) || other.locationName == _this.locationName)&&(identical(other.originId, _this.originId) || other.originId == _this.originId)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.episodeCount, _this.episodeCount) || other.episodeCount == _this.episodeCount));
}


@override
int get hashCode {
  final _this = this as Character;
  return Object.hash(runtimeType,_this.id,_this.name,_this.status,_this.species,_this.type,_this.gender,_this.originName,_this.locationName,_this.originId,_this.locationId,_this.imageUrl,_this.episodeCount);
}

@override
String toString() {
  final _this = this as Character;
  return 'Character(id: ${_this.id}, name: ${_this.name}, status: ${_this.status}, species: ${_this.species}, type: ${_this.type}, gender: ${_this.gender}, originName: ${_this.originName}, locationName: ${_this.locationName}, originId: ${_this.originId}, locationId: ${_this.locationId}, imageUrl: ${_this.imageUrl}, episodeCount: ${_this.episodeCount})';
}


}

/// @nodoc
abstract mixin class $CharacterCopyWith<$Res>  {
  factory $CharacterCopyWith(Character value, $Res Function(Character) _then) = _$CharacterCopyWithImpl;
@useResult
$Res call({
 int id, String name, CharacterStatus status, String species, String type, String gender, String originName, String locationName, int? originId, int? locationId, String imageUrl, int episodeCount
});




}
/// @nodoc
class _$CharacterCopyWithImpl<$Res>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._self, this._then);

  final Character _self;
  final $Res Function(Character) _then;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? species = null,Object? type = null,Object? gender = null,Object? originName = null,Object? locationName = null,Object? originId = freezed,Object? locationId = freezed,Object? imageUrl = null,Object? episodeCount = null,}) {
  return _then(Character(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CharacterStatus,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,originName: null == originName ? _self.originName : originName // ignore: cast_nullable_to_non_nullable
as String,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,originId: freezed == originId ? _self.originId : originId // ignore: cast_nullable_to_non_nullable
as int?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Character].
extension CharacterPatterns on Character {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Character value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Character() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Character value)  $default,){
final _that = this;
switch (_that) {
case _Character():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Character value)?  $default,){
final _that = this;
switch (_that) {
case _Character() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  CharacterStatus status,  String species,  String type,  String gender,  String originName,  String locationName,  int? originId,  int? locationId,  String imageUrl,  int episodeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Character() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.species,_that.type,_that.gender,_that.originName,_that.locationName,_that.originId,_that.locationId,_that.imageUrl,_that.episodeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  CharacterStatus status,  String species,  String type,  String gender,  String originName,  String locationName,  int? originId,  int? locationId,  String imageUrl,  int episodeCount)  $default,) {final _that = this;
switch (_that) {
case _Character():
return $default(_that.id,_that.name,_that.status,_that.species,_that.type,_that.gender,_that.originName,_that.locationName,_that.originId,_that.locationId,_that.imageUrl,_that.episodeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  CharacterStatus status,  String species,  String type,  String gender,  String originName,  String locationName,  int? originId,  int? locationId,  String imageUrl,  int episodeCount)?  $default,) {final _that = this;
switch (_that) {
case _Character() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.species,_that.type,_that.gender,_that.originName,_that.locationName,_that.originId,_that.locationId,_that.imageUrl,_that.episodeCount);case _:
  return null;

}
}

}

/// @nodoc


class _Character implements Character {
  const _Character({required this.id, required this.name, required this.status, required this.species, required this.type, required this.gender, required this.originName, required this.locationName, this.originId, this.locationId, required this.imageUrl, required this.episodeCount});
  

@override final  int id;
@override final  String name;
@override final  CharacterStatus status;
@override final  String species;
@override final  String type;
@override final  String gender;
@override final  String originName;
@override final  String locationName;
/// Ids of the origin / last location, or `null` when unknown.
@override final  int? originId;
@override final  int? locationId;
@override final  String imageUrl;
@override final  int episodeCount;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterCopyWith<_Character> get copyWith => __$CharacterCopyWithImpl<_Character>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Character&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.species, species) || other.species == species)&&(identical(other.type, type) || other.type == type)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.originName, originName) || other.originName == originName)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.originId, originId) || other.originId == originId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,status,species,type,gender,originName,locationName,originId,locationId,imageUrl,episodeCount);
}

@override
String toString() {
    return 'Character(id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, originName: $originName, locationName: $locationName, originId: $originId, locationId: $locationId, imageUrl: $imageUrl, episodeCount: $episodeCount)';
}


}

/// @nodoc
abstract mixin class _$CharacterCopyWith<$Res> implements $CharacterCopyWith<$Res> {
  factory _$CharacterCopyWith(_Character value, $Res Function(_Character) _then) = __$CharacterCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, CharacterStatus status, String species, String type, String gender, String originName, String locationName, int? originId, int? locationId, String imageUrl, int episodeCount
});




}
/// @nodoc
class __$CharacterCopyWithImpl<$Res>
    implements _$CharacterCopyWith<$Res> {
  __$CharacterCopyWithImpl(this._self, this._then);

  final _Character _self;
  final $Res Function(_Character) _then;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? species = null,Object? type = null,Object? gender = null,Object? originName = null,Object? locationName = null,Object? originId = freezed,Object? locationId = freezed,Object? imageUrl = null,Object? episodeCount = null,}) {
  return _then(_Character(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CharacterStatus,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,originName: null == originName ? _self.originName : originName // ignore: cast_nullable_to_non_nullable
as String,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,originId: freezed == originId ? _self.originId : originId // ignore: cast_nullable_to_non_nullable
as int?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
