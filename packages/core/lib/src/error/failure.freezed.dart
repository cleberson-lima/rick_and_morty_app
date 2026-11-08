// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotFoundFailure value)?  notFound,TResult Function( NetworkFailure value)?  network,TResult Function( TooManyRequestsFailure value)?  tooManyRequests,TResult Function( ServerFailure value)?  server,TResult Function( CancelledFailure value)?  cancelled,TResult Function( CacheFailure value)?  cache,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotFoundFailure() when notFound != null:
return notFound(_that);case NetworkFailure() when network != null:
return network(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case ServerFailure() when server != null:
return server(_that);case CancelledFailure() when cancelled != null:
return cancelled(_that);case CacheFailure() when cache != null:
return cache(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotFoundFailure value)  notFound,required TResult Function( NetworkFailure value)  network,required TResult Function( TooManyRequestsFailure value)  tooManyRequests,required TResult Function( ServerFailure value)  server,required TResult Function( CancelledFailure value)  cancelled,required TResult Function( CacheFailure value)  cache,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case NotFoundFailure():
return notFound(_that);case NetworkFailure():
return network(_that);case TooManyRequestsFailure():
return tooManyRequests(_that);case ServerFailure():
return server(_that);case CancelledFailure():
return cancelled(_that);case CacheFailure():
return cache(_that);case UnexpectedFailure():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( NetworkFailure value)?  network,TResult? Function( TooManyRequestsFailure value)?  tooManyRequests,TResult? Function( ServerFailure value)?  server,TResult? Function( CancelledFailure value)?  cancelled,TResult? Function( CacheFailure value)?  cache,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case NotFoundFailure() when notFound != null:
return notFound(_that);case NetworkFailure() when network != null:
return network(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case ServerFailure() when server != null:
return server(_that);case CancelledFailure() when cancelled != null:
return cancelled(_that);case CacheFailure() when cache != null:
return cache(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  notFound,TResult Function()?  network,TResult Function()?  tooManyRequests,TResult Function( int? statusCode)?  server,TResult Function()?  cancelled,TResult Function()?  cache,TResult Function()?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotFoundFailure() when notFound != null:
return notFound();case NetworkFailure() when network != null:
return network();case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests();case ServerFailure() when server != null:
return server(_that.statusCode);case CancelledFailure() when cancelled != null:
return cancelled();case CacheFailure() when cache != null:
return cache();case UnexpectedFailure() when unexpected != null:
return unexpected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  notFound,required TResult Function()  network,required TResult Function()  tooManyRequests,required TResult Function( int? statusCode)  server,required TResult Function()  cancelled,required TResult Function()  cache,required TResult Function()  unexpected,}) {final _that = this;
switch (_that) {
case NotFoundFailure():
return notFound();case NetworkFailure():
return network();case TooManyRequestsFailure():
return tooManyRequests();case ServerFailure():
return server(_that.statusCode);case CancelledFailure():
return cancelled();case CacheFailure():
return cache();case UnexpectedFailure():
return unexpected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  notFound,TResult? Function()?  network,TResult? Function()?  tooManyRequests,TResult? Function( int? statusCode)?  server,TResult? Function()?  cancelled,TResult? Function()?  cache,TResult? Function()?  unexpected,}) {final _that = this;
switch (_that) {
case NotFoundFailure() when notFound != null:
return notFound();case NetworkFailure() when network != null:
return network();case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests();case ServerFailure() when server != null:
return server(_that.statusCode);case CancelledFailure() when cancelled != null:
return cancelled();case CacheFailure() when cache != null:
return cache();case UnexpectedFailure() when unexpected != null:
return unexpected();case _:
  return null;

}
}

}

/// @nodoc


class NotFoundFailure extends Failure {
  const NotFoundFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure.notFound()';
}


}




/// @nodoc


class NetworkFailure extends Failure {
  const NetworkFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure.network()';
}


}




/// @nodoc


class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyRequestsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure.tooManyRequests()';
}


}




/// @nodoc


class ServerFailure extends Failure {
  const ServerFailure({this.statusCode}): super._();
  

 final  int? statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,statusCode);
}

@override
String toString() {
    return 'Failure.server(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(ServerFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class CancelledFailure extends Failure {
  const CancelledFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelledFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure.cancelled()';
}


}




/// @nodoc


class CacheFailure extends Failure {
  const CacheFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure.cache()';
}


}




/// @nodoc


class UnexpectedFailure extends Failure {
  const UnexpectedFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Failure.unexpected()';
}


}




// dart format on
