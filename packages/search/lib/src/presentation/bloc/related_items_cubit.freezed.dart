// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'related_items_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RelatedItemsState<T> {

 int get page;
/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelatedItemsStateCopyWith<T, RelatedItemsState<T>> get copyWith => _$RelatedItemsStateCopyWithImpl<T, RelatedItemsState<T>>(this as RelatedItemsState<T>, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RelatedItemsState<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelatedItemsState<T>&&(identical(other.page, _this.page) || other.page == _this.page));
}


@override
int get hashCode {
  final _this = this as RelatedItemsState<T>;
  return Object.hash(runtimeType,_this.page);
}

@override
String toString() {
  final _this = this as RelatedItemsState<T>;
  return 'RelatedItemsState<$T>(page: ${_this.page})';
}


}

/// @nodoc
abstract mixin class $RelatedItemsStateCopyWith<T,$Res>  {
  factory $RelatedItemsStateCopyWith(RelatedItemsState<T> value, $Res Function(RelatedItemsState<T>) _then) = _$RelatedItemsStateCopyWithImpl;
@useResult
$Res call({
 int page
});




}
/// @nodoc
class _$RelatedItemsStateCopyWithImpl<T,$Res>
    implements $RelatedItemsStateCopyWith<T, $Res> {
  _$RelatedItemsStateCopyWithImpl(this._self, this._then);

  final RelatedItemsState<T> _self;
  final $Res Function(RelatedItemsState<T>) _then;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RelatedItemsState].
extension RelatedItemsStatePatterns<T> on RelatedItemsState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RelatedItemsLoading<T> value)?  loading,TResult Function( RelatedItemsSuccess<T> value)?  success,TResult Function( RelatedItemsError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RelatedItemsLoading() when loading != null:
return loading(_that);case RelatedItemsSuccess() when success != null:
return success(_that);case RelatedItemsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RelatedItemsLoading<T> value)  loading,required TResult Function( RelatedItemsSuccess<T> value)  success,required TResult Function( RelatedItemsError<T> value)  error,}){
final _that = this;
switch (_that) {
case RelatedItemsLoading():
return loading(_that);case RelatedItemsSuccess():
return success(_that);case RelatedItemsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RelatedItemsLoading<T> value)?  loading,TResult? Function( RelatedItemsSuccess<T> value)?  success,TResult? Function( RelatedItemsError<T> value)?  error,}){
final _that = this;
switch (_that) {
case RelatedItemsLoading() when loading != null:
return loading(_that);case RelatedItemsSuccess() when success != null:
return success(_that);case RelatedItemsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int page)?  loading,TResult Function( List<T> items,  int page,  int totalPages)?  success,TResult Function( Failure failure,  int page)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RelatedItemsLoading() when loading != null:
return loading(_that.page);case RelatedItemsSuccess() when success != null:
return success(_that.items,_that.page,_that.totalPages);case RelatedItemsError() when error != null:
return error(_that.failure,_that.page);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int page)  loading,required TResult Function( List<T> items,  int page,  int totalPages)  success,required TResult Function( Failure failure,  int page)  error,}) {final _that = this;
switch (_that) {
case RelatedItemsLoading():
return loading(_that.page);case RelatedItemsSuccess():
return success(_that.items,_that.page,_that.totalPages);case RelatedItemsError():
return error(_that.failure,_that.page);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int page)?  loading,TResult? Function( List<T> items,  int page,  int totalPages)?  success,TResult? Function( Failure failure,  int page)?  error,}) {final _that = this;
switch (_that) {
case RelatedItemsLoading() when loading != null:
return loading(_that.page);case RelatedItemsSuccess() when success != null:
return success(_that.items,_that.page,_that.totalPages);case RelatedItemsError() when error != null:
return error(_that.failure,_that.page);case _:
  return null;

}
}

}

/// @nodoc


class RelatedItemsLoading<T> implements RelatedItemsState<T> {
  const RelatedItemsLoading({required this.page});
  

@override final  int page;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelatedItemsLoadingCopyWith<T, RelatedItemsLoading<T>> get copyWith => _$RelatedItemsLoadingCopyWithImpl<T, RelatedItemsLoading<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RelatedItemsLoading<T>&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,page);
}

@override
String toString() {
    return 'RelatedItemsState<$T>.loading(page: $page)';
}


}

/// @nodoc
abstract mixin class $RelatedItemsLoadingCopyWith<T,$Res> implements $RelatedItemsStateCopyWith<T, $Res> {
  factory $RelatedItemsLoadingCopyWith(RelatedItemsLoading<T> value, $Res Function(RelatedItemsLoading<T>) _then) = _$RelatedItemsLoadingCopyWithImpl;
@override @useResult
$Res call({
 int page
});




}
/// @nodoc
class _$RelatedItemsLoadingCopyWithImpl<T,$Res>
    implements $RelatedItemsLoadingCopyWith<T, $Res> {
  _$RelatedItemsLoadingCopyWithImpl(this._self, this._then);

  final RelatedItemsLoading<T> _self;
  final $Res Function(RelatedItemsLoading<T>) _then;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,}) {
  return _then(RelatedItemsLoading<T>(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RelatedItemsSuccess<T> implements RelatedItemsState<T> {
  const RelatedItemsSuccess({required  List<T> items, required this.page, required this.totalPages}): _items = items;
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
 final  int totalPages;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelatedItemsSuccessCopyWith<T, RelatedItemsSuccess<T>> get copyWith => _$RelatedItemsSuccessCopyWithImpl<T, RelatedItemsSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RelatedItemsSuccess<T>&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,totalPages);
}

@override
String toString() {
    return 'RelatedItemsState<$T>.success(items: $items, page: $page, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $RelatedItemsSuccessCopyWith<T,$Res> implements $RelatedItemsStateCopyWith<T, $Res> {
  factory $RelatedItemsSuccessCopyWith(RelatedItemsSuccess<T> value, $Res Function(RelatedItemsSuccess<T>) _then) = _$RelatedItemsSuccessCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, int page, int totalPages
});




}
/// @nodoc
class _$RelatedItemsSuccessCopyWithImpl<T,$Res>
    implements $RelatedItemsSuccessCopyWith<T, $Res> {
  _$RelatedItemsSuccessCopyWithImpl(this._self, this._then);

  final RelatedItemsSuccess<T> _self;
  final $Res Function(RelatedItemsSuccess<T>) _then;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? totalPages = null,}) {
  return _then(RelatedItemsSuccess<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RelatedItemsError<T> implements RelatedItemsState<T> {
  const RelatedItemsError({required this.failure, required this.page});
  

 final  Failure failure;
@override final  int page;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelatedItemsErrorCopyWith<T, RelatedItemsError<T>> get copyWith => _$RelatedItemsErrorCopyWithImpl<T, RelatedItemsError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RelatedItemsError<T>&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure,page);
}

@override
String toString() {
    return 'RelatedItemsState<$T>.error(failure: $failure, page: $page)';
}


}

/// @nodoc
abstract mixin class $RelatedItemsErrorCopyWith<T,$Res> implements $RelatedItemsStateCopyWith<T, $Res> {
  factory $RelatedItemsErrorCopyWith(RelatedItemsError<T> value, $Res Function(RelatedItemsError<T>) _then) = _$RelatedItemsErrorCopyWithImpl;
@override @useResult
$Res call({
 Failure failure, int page
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$RelatedItemsErrorCopyWithImpl<T,$Res>
    implements $RelatedItemsErrorCopyWith<T, $Res> {
  _$RelatedItemsErrorCopyWithImpl(this._self, this._then);

  final RelatedItemsError<T> _self;
  final $Res Function(RelatedItemsError<T>) _then;

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? page = null,}) {
  return _then(RelatedItemsError<T>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RelatedItemsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
