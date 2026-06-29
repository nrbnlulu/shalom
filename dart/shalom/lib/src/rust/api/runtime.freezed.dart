// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'runtime.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent()';
}


}

/// @nodoc
class $SubscriptionEventCopyWith<$Res>  {
$SubscriptionEventCopyWith(SubscriptionEvent _, $Res Function(SubscriptionEvent) __);
}


/// Adds pattern-matching-related methods to [SubscriptionEvent].
extension SubscriptionEventPatterns on SubscriptionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SubscriptionEvent_Data value)?  data,TResult Function( SubscriptionEvent_GraphQlError value)?  graphQlError,TResult Function( SubscriptionEvent_TransportError value)?  transportError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SubscriptionEvent_Data() when data != null:
return data(_that);case SubscriptionEvent_GraphQlError() when graphQlError != null:
return graphQlError(_that);case SubscriptionEvent_TransportError() when transportError != null:
return transportError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SubscriptionEvent_Data value)  data,required TResult Function( SubscriptionEvent_GraphQlError value)  graphQlError,required TResult Function( SubscriptionEvent_TransportError value)  transportError,}){
final _that = this;
switch (_that) {
case SubscriptionEvent_Data():
return data(_that);case SubscriptionEvent_GraphQlError():
return graphQlError(_that);case SubscriptionEvent_TransportError():
return transportError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SubscriptionEvent_Data value)?  data,TResult? Function( SubscriptionEvent_GraphQlError value)?  graphQlError,TResult? Function( SubscriptionEvent_TransportError value)?  transportError,}){
final _that = this;
switch (_that) {
case SubscriptionEvent_Data() when data != null:
return data(_that);case SubscriptionEvent_GraphQlError() when graphQlError != null:
return graphQlError(_that);case SubscriptionEvent_TransportError() when transportError != null:
return transportError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String dataJson)?  data,TResult Function( String errorsJson,  String? extensionsJson)?  graphQlError,TResult Function( String code,  String message,  String? detailsJson)?  transportError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SubscriptionEvent_Data() when data != null:
return data(_that.dataJson);case SubscriptionEvent_GraphQlError() when graphQlError != null:
return graphQlError(_that.errorsJson,_that.extensionsJson);case SubscriptionEvent_TransportError() when transportError != null:
return transportError(_that.code,_that.message,_that.detailsJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String dataJson)  data,required TResult Function( String errorsJson,  String? extensionsJson)  graphQlError,required TResult Function( String code,  String message,  String? detailsJson)  transportError,}) {final _that = this;
switch (_that) {
case SubscriptionEvent_Data():
return data(_that.dataJson);case SubscriptionEvent_GraphQlError():
return graphQlError(_that.errorsJson,_that.extensionsJson);case SubscriptionEvent_TransportError():
return transportError(_that.code,_that.message,_that.detailsJson);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String dataJson)?  data,TResult? Function( String errorsJson,  String? extensionsJson)?  graphQlError,TResult? Function( String code,  String message,  String? detailsJson)?  transportError,}) {final _that = this;
switch (_that) {
case SubscriptionEvent_Data() when data != null:
return data(_that.dataJson);case SubscriptionEvent_GraphQlError() when graphQlError != null:
return graphQlError(_that.errorsJson,_that.extensionsJson);case SubscriptionEvent_TransportError() when transportError != null:
return transportError(_that.code,_that.message,_that.detailsJson);case _:
  return null;

}
}

}

/// @nodoc


class SubscriptionEvent_Data extends SubscriptionEvent {
  const SubscriptionEvent_Data({required this.dataJson}): super._();
  

 final  String dataJson;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEvent_DataCopyWith<SubscriptionEvent_Data> get copyWith => _$SubscriptionEvent_DataCopyWithImpl<SubscriptionEvent_Data>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent_Data&&(identical(other.dataJson, dataJson) || other.dataJson == dataJson));
}


@override
int get hashCode => Object.hash(runtimeType,dataJson);

@override
String toString() {
  return 'SubscriptionEvent.data(dataJson: $dataJson)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEvent_DataCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEvent_DataCopyWith(SubscriptionEvent_Data value, $Res Function(SubscriptionEvent_Data) _then) = _$SubscriptionEvent_DataCopyWithImpl;
@useResult
$Res call({
 String dataJson
});




}
/// @nodoc
class _$SubscriptionEvent_DataCopyWithImpl<$Res>
    implements $SubscriptionEvent_DataCopyWith<$Res> {
  _$SubscriptionEvent_DataCopyWithImpl(this._self, this._then);

  final SubscriptionEvent_Data _self;
  final $Res Function(SubscriptionEvent_Data) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dataJson = null,}) {
  return _then(SubscriptionEvent_Data(
dataJson: null == dataJson ? _self.dataJson : dataJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubscriptionEvent_GraphQlError extends SubscriptionEvent {
  const SubscriptionEvent_GraphQlError({required this.errorsJson, this.extensionsJson}): super._();
  

 final  String errorsJson;
 final  String? extensionsJson;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEvent_GraphQlErrorCopyWith<SubscriptionEvent_GraphQlError> get copyWith => _$SubscriptionEvent_GraphQlErrorCopyWithImpl<SubscriptionEvent_GraphQlError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent_GraphQlError&&(identical(other.errorsJson, errorsJson) || other.errorsJson == errorsJson)&&(identical(other.extensionsJson, extensionsJson) || other.extensionsJson == extensionsJson));
}


@override
int get hashCode => Object.hash(runtimeType,errorsJson,extensionsJson);

@override
String toString() {
  return 'SubscriptionEvent.graphQlError(errorsJson: $errorsJson, extensionsJson: $extensionsJson)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEvent_GraphQlErrorCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEvent_GraphQlErrorCopyWith(SubscriptionEvent_GraphQlError value, $Res Function(SubscriptionEvent_GraphQlError) _then) = _$SubscriptionEvent_GraphQlErrorCopyWithImpl;
@useResult
$Res call({
 String errorsJson, String? extensionsJson
});




}
/// @nodoc
class _$SubscriptionEvent_GraphQlErrorCopyWithImpl<$Res>
    implements $SubscriptionEvent_GraphQlErrorCopyWith<$Res> {
  _$SubscriptionEvent_GraphQlErrorCopyWithImpl(this._self, this._then);

  final SubscriptionEvent_GraphQlError _self;
  final $Res Function(SubscriptionEvent_GraphQlError) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorsJson = null,Object? extensionsJson = freezed,}) {
  return _then(SubscriptionEvent_GraphQlError(
errorsJson: null == errorsJson ? _self.errorsJson : errorsJson // ignore: cast_nullable_to_non_nullable
as String,extensionsJson: freezed == extensionsJson ? _self.extensionsJson : extensionsJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SubscriptionEvent_TransportError extends SubscriptionEvent {
  const SubscriptionEvent_TransportError({required this.code, required this.message, this.detailsJson}): super._();
  

 final  String code;
 final  String message;
 final  String? detailsJson;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEvent_TransportErrorCopyWith<SubscriptionEvent_TransportError> get copyWith => _$SubscriptionEvent_TransportErrorCopyWithImpl<SubscriptionEvent_TransportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent_TransportError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.detailsJson, detailsJson) || other.detailsJson == detailsJson));
}


@override
int get hashCode => Object.hash(runtimeType,code,message,detailsJson);

@override
String toString() {
  return 'SubscriptionEvent.transportError(code: $code, message: $message, detailsJson: $detailsJson)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEvent_TransportErrorCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEvent_TransportErrorCopyWith(SubscriptionEvent_TransportError value, $Res Function(SubscriptionEvent_TransportError) _then) = _$SubscriptionEvent_TransportErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, String? detailsJson
});




}
/// @nodoc
class _$SubscriptionEvent_TransportErrorCopyWithImpl<$Res>
    implements $SubscriptionEvent_TransportErrorCopyWith<$Res> {
  _$SubscriptionEvent_TransportErrorCopyWithImpl(this._self, this._then);

  final SubscriptionEvent_TransportError _self;
  final $Res Function(SubscriptionEvent_TransportError) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? detailsJson = freezed,}) {
  return _then(SubscriptionEvent_TransportError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,detailsJson: freezed == detailsJson ? _self.detailsJson : detailsJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
