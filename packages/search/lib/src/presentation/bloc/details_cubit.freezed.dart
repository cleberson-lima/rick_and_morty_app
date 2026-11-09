// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DetailsState()';
}


}

/// @nodoc
class $DetailsStateCopyWith<$Res>  {
$DetailsStateCopyWith(DetailsState _, $Res Function(DetailsState) __);
}


/// Adds pattern-matching-related methods to [DetailsState].
extension DetailsStatePatterns on DetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DetailsLoading value)?  loading,TResult Function( DetailsCharacter value)?  character,TResult Function( DetailsEpisode value)?  episode,TResult Function( DetailsLocation value)?  location,TResult Function( DetailsNotFound value)?  notFound,TResult Function( DetailsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DetailsLoading() when loading != null:
return loading(_that);case DetailsCharacter() when character != null:
return character(_that);case DetailsEpisode() when episode != null:
return episode(_that);case DetailsLocation() when location != null:
return location(_that);case DetailsNotFound() when notFound != null:
return notFound(_that);case DetailsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DetailsLoading value)  loading,required TResult Function( DetailsCharacter value)  character,required TResult Function( DetailsEpisode value)  episode,required TResult Function( DetailsLocation value)  location,required TResult Function( DetailsNotFound value)  notFound,required TResult Function( DetailsError value)  error,}){
final _that = this;
switch (_that) {
case DetailsLoading():
return loading(_that);case DetailsCharacter():
return character(_that);case DetailsEpisode():
return episode(_that);case DetailsLocation():
return location(_that);case DetailsNotFound():
return notFound(_that);case DetailsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DetailsLoading value)?  loading,TResult? Function( DetailsCharacter value)?  character,TResult? Function( DetailsEpisode value)?  episode,TResult? Function( DetailsLocation value)?  location,TResult? Function( DetailsNotFound value)?  notFound,TResult? Function( DetailsError value)?  error,}){
final _that = this;
switch (_that) {
case DetailsLoading() when loading != null:
return loading(_that);case DetailsCharacter() when character != null:
return character(_that);case DetailsEpisode() when episode != null:
return episode(_that);case DetailsLocation() when location != null:
return location(_that);case DetailsNotFound() when notFound != null:
return notFound(_that);case DetailsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Character character)?  character,TResult Function( Episode episode)?  episode,TResult Function( Location location)?  location,TResult Function()?  notFound,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DetailsLoading() when loading != null:
return loading();case DetailsCharacter() when character != null:
return character(_that.character);case DetailsEpisode() when episode != null:
return episode(_that.episode);case DetailsLocation() when location != null:
return location(_that.location);case DetailsNotFound() when notFound != null:
return notFound();case DetailsError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Character character)  character,required TResult Function( Episode episode)  episode,required TResult Function( Location location)  location,required TResult Function()  notFound,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case DetailsLoading():
return loading();case DetailsCharacter():
return character(_that.character);case DetailsEpisode():
return episode(_that.episode);case DetailsLocation():
return location(_that.location);case DetailsNotFound():
return notFound();case DetailsError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Character character)?  character,TResult? Function( Episode episode)?  episode,TResult? Function( Location location)?  location,TResult? Function()?  notFound,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case DetailsLoading() when loading != null:
return loading();case DetailsCharacter() when character != null:
return character(_that.character);case DetailsEpisode() when episode != null:
return episode(_that.episode);case DetailsLocation() when location != null:
return location(_that.location);case DetailsNotFound() when notFound != null:
return notFound();case DetailsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DetailsLoading implements DetailsState {
  const DetailsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DetailsState.loading()';
}


}




/// @nodoc


class DetailsCharacter implements DetailsState {
  const DetailsCharacter(this.character);
  

 final  Character character;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailsCharacterCopyWith<DetailsCharacter> get copyWith => _$DetailsCharacterCopyWithImpl<DetailsCharacter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsCharacter&&(identical(other.character, character) || other.character == character));
}


@override
int get hashCode {
    return Object.hash(runtimeType,character);
}

@override
String toString() {
    return 'DetailsState.character(character: $character)';
}


}

/// @nodoc
abstract mixin class $DetailsCharacterCopyWith<$Res> implements $DetailsStateCopyWith<$Res> {
  factory $DetailsCharacterCopyWith(DetailsCharacter value, $Res Function(DetailsCharacter) _then) = _$DetailsCharacterCopyWithImpl;
@useResult
$Res call({
 Character character
});


$CharacterCopyWith<$Res> get character;

}
/// @nodoc
class _$DetailsCharacterCopyWithImpl<$Res>
    implements $DetailsCharacterCopyWith<$Res> {
  _$DetailsCharacterCopyWithImpl(this._self, this._then);

  final DetailsCharacter _self;
  final $Res Function(DetailsCharacter) _then;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? character = null,}) {
  return _then(DetailsCharacter(
null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as Character,
  ));
}

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterCopyWith<$Res> get character {
  
  return $CharacterCopyWith<$Res>(_self.character, (value) {
    return _then(_self.copyWith(character: value));
  });
}
}

/// @nodoc


class DetailsEpisode implements DetailsState {
  const DetailsEpisode(this.episode);
  

 final  Episode episode;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailsEpisodeCopyWith<DetailsEpisode> get copyWith => _$DetailsEpisodeCopyWithImpl<DetailsEpisode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsEpisode&&(identical(other.episode, episode) || other.episode == episode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,episode);
}

@override
String toString() {
    return 'DetailsState.episode(episode: $episode)';
}


}

/// @nodoc
abstract mixin class $DetailsEpisodeCopyWith<$Res> implements $DetailsStateCopyWith<$Res> {
  factory $DetailsEpisodeCopyWith(DetailsEpisode value, $Res Function(DetailsEpisode) _then) = _$DetailsEpisodeCopyWithImpl;
@useResult
$Res call({
 Episode episode
});


$EpisodeCopyWith<$Res> get episode;

}
/// @nodoc
class _$DetailsEpisodeCopyWithImpl<$Res>
    implements $DetailsEpisodeCopyWith<$Res> {
  _$DetailsEpisodeCopyWithImpl(this._self, this._then);

  final DetailsEpisode _self;
  final $Res Function(DetailsEpisode) _then;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? episode = null,}) {
  return _then(DetailsEpisode(
null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,
  ));
}

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res> get episode {
  
  return $EpisodeCopyWith<$Res>(_self.episode, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}

/// @nodoc


class DetailsLocation implements DetailsState {
  const DetailsLocation(this.location);
  

 final  Location location;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailsLocationCopyWith<DetailsLocation> get copyWith => _$DetailsLocationCopyWithImpl<DetailsLocation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsLocation&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode {
    return Object.hash(runtimeType,location);
}

@override
String toString() {
    return 'DetailsState.location(location: $location)';
}


}

/// @nodoc
abstract mixin class $DetailsLocationCopyWith<$Res> implements $DetailsStateCopyWith<$Res> {
  factory $DetailsLocationCopyWith(DetailsLocation value, $Res Function(DetailsLocation) _then) = _$DetailsLocationCopyWithImpl;
@useResult
$Res call({
 Location location
});


$LocationCopyWith<$Res> get location;

}
/// @nodoc
class _$DetailsLocationCopyWithImpl<$Res>
    implements $DetailsLocationCopyWith<$Res> {
  _$DetailsLocationCopyWithImpl(this._self, this._then);

  final DetailsLocation _self;
  final $Res Function(DetailsLocation) _then;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? location = null,}) {
  return _then(DetailsLocation(
null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,
  ));
}

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res> get location {
  
  return $LocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

/// @nodoc


class DetailsNotFound implements DetailsState {
  const DetailsNotFound();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DetailsState.notFound()';
}


}




/// @nodoc


class DetailsError implements DetailsState {
  const DetailsError(this.failure);
  

 final  Failure failure;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailsErrorCopyWith<DetailsError> get copyWith => _$DetailsErrorCopyWithImpl<DetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'DetailsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DetailsErrorCopyWith<$Res> implements $DetailsStateCopyWith<$Res> {
  factory $DetailsErrorCopyWith(DetailsError value, $Res Function(DetailsError) _then) = _$DetailsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DetailsErrorCopyWithImpl<$Res>
    implements $DetailsErrorCopyWith<$Res> {
  _$DetailsErrorCopyWithImpl(this._self, this._then);

  final DetailsError _self;
  final $Res Function(DetailsError) _then;

/// Create a copy of DetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DetailsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DetailsState
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
