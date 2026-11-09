// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'more_items_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MoreItemsState<T> {

 int get page;
/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoreItemsStateCopyWith<T, MoreItemsState<T>> get copyWith => _$MoreItemsStateCopyWithImpl<T, MoreItemsState<T>>(this as MoreItemsState<T>, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MoreItemsState<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoreItemsState<T>&&(identical(other.page, _this.page) || other.page == _this.page));
}


@override
int get hashCode {
  final _this = this as MoreItemsState<T>;
  return Object.hash(runtimeType,_this.page);
}

@override
String toString() {
  final _this = this as MoreItemsState<T>;
  return 'MoreItemsState<$T>(page: ${_this.page})';
}


}

/// @nodoc
abstract mixin class $MoreItemsStateCopyWith<T,$Res>  {
  factory $MoreItemsStateCopyWith(MoreItemsState<T> value, $Res Function(MoreItemsState<T>) _then) = _$MoreItemsStateCopyWithImpl;
@useResult
$Res call({
 int page
});




}
/// @nodoc
class _$MoreItemsStateCopyWithImpl<T,$Res>
    implements $MoreItemsStateCopyWith<T, $Res> {
  _$MoreItemsStateCopyWithImpl(this._self, this._then);

  final MoreItemsState<T> _self;
  final $Res Function(MoreItemsState<T>) _then;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MoreItemsState].
extension MoreItemsStatePatterns<T> on MoreItemsState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MoreItemsLoading<T> value)?  loading,TResult Function( MoreItemsSuccess<T> value)?  success,TResult Function( MoreItemsError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MoreItemsLoading() when loading != null:
return loading(_that);case MoreItemsSuccess() when success != null:
return success(_that);case MoreItemsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MoreItemsLoading<T> value)  loading,required TResult Function( MoreItemsSuccess<T> value)  success,required TResult Function( MoreItemsError<T> value)  error,}){
final _that = this;
switch (_that) {
case MoreItemsLoading():
return loading(_that);case MoreItemsSuccess():
return success(_that);case MoreItemsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MoreItemsLoading<T> value)?  loading,TResult? Function( MoreItemsSuccess<T> value)?  success,TResult? Function( MoreItemsError<T> value)?  error,}){
final _that = this;
switch (_that) {
case MoreItemsLoading() when loading != null:
return loading(_that);case MoreItemsSuccess() when success != null:
return success(_that);case MoreItemsError() when error != null:
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
case MoreItemsLoading() when loading != null:
return loading(_that.page);case MoreItemsSuccess() when success != null:
return success(_that.items,_that.page,_that.totalPages);case MoreItemsError() when error != null:
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
case MoreItemsLoading():
return loading(_that.page);case MoreItemsSuccess():
return success(_that.items,_that.page,_that.totalPages);case MoreItemsError():
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
case MoreItemsLoading() when loading != null:
return loading(_that.page);case MoreItemsSuccess() when success != null:
return success(_that.items,_that.page,_that.totalPages);case MoreItemsError() when error != null:
return error(_that.failure,_that.page);case _:
  return null;

}
}

}

/// @nodoc


class MoreItemsLoading<T> implements MoreItemsState<T> {
  const MoreItemsLoading({required this.page});
  

@override final  int page;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoreItemsLoadingCopyWith<T, MoreItemsLoading<T>> get copyWith => _$MoreItemsLoadingCopyWithImpl<T, MoreItemsLoading<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MoreItemsLoading<T>&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,page);
}

@override
String toString() {
    return 'MoreItemsState<$T>.loading(page: $page)';
}


}

/// @nodoc
abstract mixin class $MoreItemsLoadingCopyWith<T,$Res> implements $MoreItemsStateCopyWith<T, $Res> {
  factory $MoreItemsLoadingCopyWith(MoreItemsLoading<T> value, $Res Function(MoreItemsLoading<T>) _then) = _$MoreItemsLoadingCopyWithImpl;
@override @useResult
$Res call({
 int page
});




}
/// @nodoc
class _$MoreItemsLoadingCopyWithImpl<T,$Res>
    implements $MoreItemsLoadingCopyWith<T, $Res> {
  _$MoreItemsLoadingCopyWithImpl(this._self, this._then);

  final MoreItemsLoading<T> _self;
  final $Res Function(MoreItemsLoading<T>) _then;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,}) {
  return _then(MoreItemsLoading<T>(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MoreItemsSuccess<T> implements MoreItemsState<T> {
  const MoreItemsSuccess({required  List<T> items, required this.page, required this.totalPages}): _items = items;
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
 final  int totalPages;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoreItemsSuccessCopyWith<T, MoreItemsSuccess<T>> get copyWith => _$MoreItemsSuccessCopyWithImpl<T, MoreItemsSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MoreItemsSuccess<T>&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,totalPages);
}

@override
String toString() {
    return 'MoreItemsState<$T>.success(items: $items, page: $page, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $MoreItemsSuccessCopyWith<T,$Res> implements $MoreItemsStateCopyWith<T, $Res> {
  factory $MoreItemsSuccessCopyWith(MoreItemsSuccess<T> value, $Res Function(MoreItemsSuccess<T>) _then) = _$MoreItemsSuccessCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, int page, int totalPages
});




}
/// @nodoc
class _$MoreItemsSuccessCopyWithImpl<T,$Res>
    implements $MoreItemsSuccessCopyWith<T, $Res> {
  _$MoreItemsSuccessCopyWithImpl(this._self, this._then);

  final MoreItemsSuccess<T> _self;
  final $Res Function(MoreItemsSuccess<T>) _then;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? totalPages = null,}) {
  return _then(MoreItemsSuccess<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MoreItemsError<T> implements MoreItemsState<T> {
  const MoreItemsError({required this.failure, required this.page});
  

 final  Failure failure;
@override final  int page;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoreItemsErrorCopyWith<T, MoreItemsError<T>> get copyWith => _$MoreItemsErrorCopyWithImpl<T, MoreItemsError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MoreItemsError<T>&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure,page);
}

@override
String toString() {
    return 'MoreItemsState<$T>.error(failure: $failure, page: $page)';
}


}

/// @nodoc
abstract mixin class $MoreItemsErrorCopyWith<T,$Res> implements $MoreItemsStateCopyWith<T, $Res> {
  factory $MoreItemsErrorCopyWith(MoreItemsError<T> value, $Res Function(MoreItemsError<T>) _then) = _$MoreItemsErrorCopyWithImpl;
@override @useResult
$Res call({
 Failure failure, int page
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$MoreItemsErrorCopyWithImpl<T,$Res>
    implements $MoreItemsErrorCopyWith<T, $Res> {
  _$MoreItemsErrorCopyWithImpl(this._self, this._then);

  final MoreItemsError<T> _self;
  final $Res Function(MoreItemsError<T>) _then;

/// Create a copy of MoreItemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? page = null,}) {
  return _then(MoreItemsError<T>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MoreItemsState
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
