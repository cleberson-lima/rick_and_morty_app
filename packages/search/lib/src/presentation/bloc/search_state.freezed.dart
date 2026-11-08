// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState<T> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchState<$T>()';
}


}

/// @nodoc
class $SearchStateCopyWith<T,$Res>  {
$SearchStateCopyWith(SearchState<T> _, $Res Function(SearchState<T>) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns<T> on SearchState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchInitial<T> value)?  initial,TResult Function( SearchLoading<T> value)?  loading,TResult Function( SearchSuccess<T> value)?  success,TResult Function( SearchEmpty<T> value)?  empty,TResult Function( SearchNotFound<T> value)?  notFound,TResult Function( SearchError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchSuccess() when success != null:
return success(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchNotFound() when notFound != null:
return notFound(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchInitial<T> value)  initial,required TResult Function( SearchLoading<T> value)  loading,required TResult Function( SearchSuccess<T> value)  success,required TResult Function( SearchEmpty<T> value)  empty,required TResult Function( SearchNotFound<T> value)  notFound,required TResult Function( SearchError<T> value)  error,}){
final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that);case SearchLoading():
return loading(_that);case SearchSuccess():
return success(_that);case SearchEmpty():
return empty(_that);case SearchNotFound():
return notFound(_that);case SearchError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchInitial<T> value)?  initial,TResult? Function( SearchLoading<T> value)?  loading,TResult? Function( SearchSuccess<T> value)?  success,TResult? Function( SearchEmpty<T> value)?  empty,TResult? Function( SearchNotFound<T> value)?  notFound,TResult? Function( SearchError<T> value)?  error,}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchSuccess() when success != null:
return success(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchNotFound() when notFound != null:
return notFound(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String query)?  loading,TResult Function( String query,  List<T> items,  int totalCount,  int? nextPage,  bool isLoadingMore,  String? loadMoreError)?  success,TResult Function( String query)?  empty,TResult Function( String query)?  notFound,TResult Function( String query,  String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial();case SearchLoading() when loading != null:
return loading(_that.query);case SearchSuccess() when success != null:
return success(_that.query,_that.items,_that.totalCount,_that.nextPage,_that.isLoadingMore,_that.loadMoreError);case SearchEmpty() when empty != null:
return empty(_that.query);case SearchNotFound() when notFound != null:
return notFound(_that.query);case SearchError() when error != null:
return error(_that.query,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String query)  loading,required TResult Function( String query,  List<T> items,  int totalCount,  int? nextPage,  bool isLoadingMore,  String? loadMoreError)  success,required TResult Function( String query)  empty,required TResult Function( String query)  notFound,required TResult Function( String query,  String message)  error,}) {final _that = this;
switch (_that) {
case SearchInitial():
return initial();case SearchLoading():
return loading(_that.query);case SearchSuccess():
return success(_that.query,_that.items,_that.totalCount,_that.nextPage,_that.isLoadingMore,_that.loadMoreError);case SearchEmpty():
return empty(_that.query);case SearchNotFound():
return notFound(_that.query);case SearchError():
return error(_that.query,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String query)?  loading,TResult? Function( String query,  List<T> items,  int totalCount,  int? nextPage,  bool isLoadingMore,  String? loadMoreError)?  success,TResult? Function( String query)?  empty,TResult? Function( String query)?  notFound,TResult? Function( String query,  String message)?  error,}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial();case SearchLoading() when loading != null:
return loading(_that.query);case SearchSuccess() when success != null:
return success(_that.query,_that.items,_that.totalCount,_that.nextPage,_that.isLoadingMore,_that.loadMoreError);case SearchEmpty() when empty != null:
return empty(_that.query);case SearchNotFound() when notFound != null:
return notFound(_that.query);case SearchError() when error != null:
return error(_that.query,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SearchInitial<T> extends SearchState<T> {
  const SearchInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchState<$T>.initial()';
}


}




/// @nodoc


class SearchLoading<T> extends SearchState<T> {
  const SearchLoading({required this.query}): super._();
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadingCopyWith<T, SearchLoading<T>> get copyWith => _$SearchLoadingCopyWithImpl<T, SearchLoading<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading<T>&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchState<$T>.loading(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchLoadingCopyWith<T,$Res> implements $SearchStateCopyWith<T, $Res> {
  factory $SearchLoadingCopyWith(SearchLoading<T> value, $Res Function(SearchLoading<T>) _then) = _$SearchLoadingCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchLoadingCopyWithImpl<T,$Res>
    implements $SearchLoadingCopyWith<T, $Res> {
  _$SearchLoadingCopyWithImpl(this._self, this._then);

  final SearchLoading<T> _self;
  final $Res Function(SearchLoading<T>) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchLoading<T>(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchSuccess<T> extends SearchState<T> {
  const SearchSuccess({required this.query, required  List<T> items, required this.totalCount, this.nextPage, this.isLoadingMore = false, this.loadMoreError}): _items = items,super._();
  

 final  String query;
 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int totalCount;
 final  int? nextPage;
@JsonKey() final  bool isLoadingMore;
 final  String? loadMoreError;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSuccessCopyWith<T, SearchSuccess<T>> get copyWith => _$SearchSuccessCopyWithImpl<T, SearchSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSuccess<T>&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_items),totalCount,nextPage,isLoadingMore,loadMoreError);
}

@override
String toString() {
    return 'SearchState<$T>.success(query: $query, items: $items, totalCount: $totalCount, nextPage: $nextPage, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $SearchSuccessCopyWith<T,$Res> implements $SearchStateCopyWith<T, $Res> {
  factory $SearchSuccessCopyWith(SearchSuccess<T> value, $Res Function(SearchSuccess<T>) _then) = _$SearchSuccessCopyWithImpl;
@useResult
$Res call({
 String query, List<T> items, int totalCount, int? nextPage, bool isLoadingMore, String? loadMoreError
});




}
/// @nodoc
class _$SearchSuccessCopyWithImpl<T,$Res>
    implements $SearchSuccessCopyWith<T, $Res> {
  _$SearchSuccessCopyWithImpl(this._self, this._then);

  final SearchSuccess<T> _self;
  final $Res Function(SearchSuccess<T>) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? items = null,Object? totalCount = null,Object? nextPage = freezed,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(SearchSuccess<T>(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SearchEmpty<T> extends SearchState<T> {
  const SearchEmpty({required this.query}): super._();
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchEmptyCopyWith<T, SearchEmpty<T>> get copyWith => _$SearchEmptyCopyWithImpl<T, SearchEmpty<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEmpty<T>&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchState<$T>.empty(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchEmptyCopyWith<T,$Res> implements $SearchStateCopyWith<T, $Res> {
  factory $SearchEmptyCopyWith(SearchEmpty<T> value, $Res Function(SearchEmpty<T>) _then) = _$SearchEmptyCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchEmptyCopyWithImpl<T,$Res>
    implements $SearchEmptyCopyWith<T, $Res> {
  _$SearchEmptyCopyWithImpl(this._self, this._then);

  final SearchEmpty<T> _self;
  final $Res Function(SearchEmpty<T>) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchEmpty<T>(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchNotFound<T> extends SearchState<T> {
  const SearchNotFound({required this.query}): super._();
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchNotFoundCopyWith<T, SearchNotFound<T>> get copyWith => _$SearchNotFoundCopyWithImpl<T, SearchNotFound<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchNotFound<T>&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchState<$T>.notFound(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchNotFoundCopyWith<T,$Res> implements $SearchStateCopyWith<T, $Res> {
  factory $SearchNotFoundCopyWith(SearchNotFound<T> value, $Res Function(SearchNotFound<T>) _then) = _$SearchNotFoundCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchNotFoundCopyWithImpl<T,$Res>
    implements $SearchNotFoundCopyWith<T, $Res> {
  _$SearchNotFoundCopyWithImpl(this._self, this._then);

  final SearchNotFound<T> _self;
  final $Res Function(SearchNotFound<T>) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchNotFound<T>(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchError<T> extends SearchState<T> {
  const SearchError({required this.query, required this.message}): super._();
  

 final  String query;
 final  String message;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchErrorCopyWith<T, SearchError<T>> get copyWith => _$SearchErrorCopyWithImpl<T, SearchError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchError<T>&&(identical(other.query, query) || other.query == query)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,message);
}

@override
String toString() {
    return 'SearchState<$T>.error(query: $query, message: $message)';
}


}

/// @nodoc
abstract mixin class $SearchErrorCopyWith<T,$Res> implements $SearchStateCopyWith<T, $Res> {
  factory $SearchErrorCopyWith(SearchError<T> value, $Res Function(SearchError<T>) _then) = _$SearchErrorCopyWithImpl;
@useResult
$Res call({
 String query, String message
});




}
/// @nodoc
class _$SearchErrorCopyWithImpl<T,$Res>
    implements $SearchErrorCopyWith<T, $Res> {
  _$SearchErrorCopyWithImpl(this._self, this._then);

  final SearchError<T> _self;
  final $Res Function(SearchError<T>) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? message = null,}) {
  return _then(SearchError<T>(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
