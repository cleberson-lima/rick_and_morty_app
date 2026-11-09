// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedList<T> {

 List<T> get items; int get totalCount;/// Number of the next page, or `null` when this is the last one.
 int? get nextPage;
/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedListCopyWith<T, PaginatedList<T>> get copyWith => _$PaginatedListCopyWithImpl<T, PaginatedList<T>>(this as PaginatedList<T>, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaginatedList<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedList<T>&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.nextPage, _this.nextPage) || other.nextPage == _this.nextPage));
}


@override
int get hashCode {
  final _this = this as PaginatedList<T>;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.totalCount,_this.nextPage);
}

@override
String toString() {
  final _this = this as PaginatedList<T>;
  return 'PaginatedList<$T>(items: ${_this.items}, totalCount: ${_this.totalCount}, nextPage: ${_this.nextPage})';
}


}

/// @nodoc
abstract mixin class $PaginatedListCopyWith<T,$Res>  {
  factory $PaginatedListCopyWith(PaginatedList<T> value, $Res Function(PaginatedList<T>) _then) = _$PaginatedListCopyWithImpl;
@useResult
$Res call({
 List<T> items, int totalCount, int? nextPage
});




}
/// @nodoc
class _$PaginatedListCopyWithImpl<T,$Res>
    implements $PaginatedListCopyWith<T, $Res> {
  _$PaginatedListCopyWithImpl(this._self, this._then);

  final PaginatedList<T> _self;
  final $Res Function(PaginatedList<T>) _then;

/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? totalCount = null,Object? nextPage = freezed,}) {
  return _then(PaginatedList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedList].
extension PaginatedListPatterns<T> on PaginatedList<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedList<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedList<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedList<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items,  int totalCount,  int? nextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
return $default(_that.items,_that.totalCount,_that.nextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items,  int totalCount,  int? nextPage)  $default,) {final _that = this;
switch (_that) {
case _PaginatedList():
return $default(_that.items,_that.totalCount,_that.nextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items,  int totalCount,  int? nextPage)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
return $default(_that.items,_that.totalCount,_that.nextPage);case _:
  return null;

}
}

}

/// @nodoc


class _PaginatedList<T> extends PaginatedList<T> {
  const _PaginatedList({required  List<T> items, required this.totalCount, this.nextPage}): _items = items,super._();
  

 final  List<T> _items;
@override List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int totalCount;
/// Number of the next page, or `null` when this is the last one.
@override final  int? nextPage;

/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedListCopyWith<T, _PaginatedList<T>> get copyWith => __$PaginatedListCopyWithImpl<T, _PaginatedList<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedList<T>&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),totalCount,nextPage);
}

@override
String toString() {
    return 'PaginatedList<$T>(items: $items, totalCount: $totalCount, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class _$PaginatedListCopyWith<T,$Res> implements $PaginatedListCopyWith<T, $Res> {
  factory _$PaginatedListCopyWith(_PaginatedList<T> value, $Res Function(_PaginatedList<T>) _then) = __$PaginatedListCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, int totalCount, int? nextPage
});




}
/// @nodoc
class __$PaginatedListCopyWithImpl<T,$Res>
    implements _$PaginatedListCopyWith<T, $Res> {
  __$PaginatedListCopyWithImpl(this._self, this._then);

  final _PaginatedList<T> _self;
  final $Res Function(_PaginatedList<T>) _then;

/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? totalCount = null,Object? nextPage = freezed,}) {
  return _then(_PaginatedList<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
