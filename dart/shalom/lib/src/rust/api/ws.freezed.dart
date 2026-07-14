// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ws.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WsLinkEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsLinkEvent()';
}


}

/// @nodoc
class $WsLinkEventCopyWith<$Res>  {
$WsLinkEventCopyWith(WsLinkEvent _, $Res Function(WsLinkEvent) __);
}


/// Adds pattern-matching-related methods to [WsLinkEvent].
extension WsLinkEventPatterns on WsLinkEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WsLinkEvent_Connected value)?  connected,TResult Function( WsLinkEvent_PingReceived value)?  pingReceived,TResult Function( WsLinkEvent_PongReceived value)?  pongReceived,TResult Function( WsLinkEvent_OperationResponse value)?  operationResponse,TResult Function( WsLinkEvent_OperationComplete value)?  operationComplete,TResult Function( WsLinkEvent_ProtocolError value)?  protocolError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WsLinkEvent_Connected() when connected != null:
return connected(_that);case WsLinkEvent_PingReceived() when pingReceived != null:
return pingReceived(_that);case WsLinkEvent_PongReceived() when pongReceived != null:
return pongReceived(_that);case WsLinkEvent_OperationResponse() when operationResponse != null:
return operationResponse(_that);case WsLinkEvent_OperationComplete() when operationComplete != null:
return operationComplete(_that);case WsLinkEvent_ProtocolError() when protocolError != null:
return protocolError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WsLinkEvent_Connected value)  connected,required TResult Function( WsLinkEvent_PingReceived value)  pingReceived,required TResult Function( WsLinkEvent_PongReceived value)  pongReceived,required TResult Function( WsLinkEvent_OperationResponse value)  operationResponse,required TResult Function( WsLinkEvent_OperationComplete value)  operationComplete,required TResult Function( WsLinkEvent_ProtocolError value)  protocolError,}){
final _that = this;
switch (_that) {
case WsLinkEvent_Connected():
return connected(_that);case WsLinkEvent_PingReceived():
return pingReceived(_that);case WsLinkEvent_PongReceived():
return pongReceived(_that);case WsLinkEvent_OperationResponse():
return operationResponse(_that);case WsLinkEvent_OperationComplete():
return operationComplete(_that);case WsLinkEvent_ProtocolError():
return protocolError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WsLinkEvent_Connected value)?  connected,TResult? Function( WsLinkEvent_PingReceived value)?  pingReceived,TResult? Function( WsLinkEvent_PongReceived value)?  pongReceived,TResult? Function( WsLinkEvent_OperationResponse value)?  operationResponse,TResult? Function( WsLinkEvent_OperationComplete value)?  operationComplete,TResult? Function( WsLinkEvent_ProtocolError value)?  protocolError,}){
final _that = this;
switch (_that) {
case WsLinkEvent_Connected() when connected != null:
return connected(_that);case WsLinkEvent_PingReceived() when pingReceived != null:
return pingReceived(_that);case WsLinkEvent_PongReceived() when pongReceived != null:
return pongReceived(_that);case WsLinkEvent_OperationResponse() when operationResponse != null:
return operationResponse(_that);case WsLinkEvent_OperationComplete() when operationComplete != null:
return operationComplete(_that);case WsLinkEvent_ProtocolError() when protocolError != null:
return protocolError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connected,TResult Function( ShalomJsonValue? payload)?  pingReceived,TResult Function( ShalomJsonValue? payload)?  pongReceived,TResult Function( String opId,  GraphQlResponseInput response)?  operationResponse,TResult Function( String opId)?  operationComplete,TResult Function( int code,  String reason)?  protocolError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WsLinkEvent_Connected() when connected != null:
return connected();case WsLinkEvent_PingReceived() when pingReceived != null:
return pingReceived(_that.payload);case WsLinkEvent_PongReceived() when pongReceived != null:
return pongReceived(_that.payload);case WsLinkEvent_OperationResponse() when operationResponse != null:
return operationResponse(_that.opId,_that.response);case WsLinkEvent_OperationComplete() when operationComplete != null:
return operationComplete(_that.opId);case WsLinkEvent_ProtocolError() when protocolError != null:
return protocolError(_that.code,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connected,required TResult Function( ShalomJsonValue? payload)  pingReceived,required TResult Function( ShalomJsonValue? payload)  pongReceived,required TResult Function( String opId,  GraphQlResponseInput response)  operationResponse,required TResult Function( String opId)  operationComplete,required TResult Function( int code,  String reason)  protocolError,}) {final _that = this;
switch (_that) {
case WsLinkEvent_Connected():
return connected();case WsLinkEvent_PingReceived():
return pingReceived(_that.payload);case WsLinkEvent_PongReceived():
return pongReceived(_that.payload);case WsLinkEvent_OperationResponse():
return operationResponse(_that.opId,_that.response);case WsLinkEvent_OperationComplete():
return operationComplete(_that.opId);case WsLinkEvent_ProtocolError():
return protocolError(_that.code,_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connected,TResult? Function( ShalomJsonValue? payload)?  pingReceived,TResult? Function( ShalomJsonValue? payload)?  pongReceived,TResult? Function( String opId,  GraphQlResponseInput response)?  operationResponse,TResult? Function( String opId)?  operationComplete,TResult? Function( int code,  String reason)?  protocolError,}) {final _that = this;
switch (_that) {
case WsLinkEvent_Connected() when connected != null:
return connected();case WsLinkEvent_PingReceived() when pingReceived != null:
return pingReceived(_that.payload);case WsLinkEvent_PongReceived() when pongReceived != null:
return pongReceived(_that.payload);case WsLinkEvent_OperationResponse() when operationResponse != null:
return operationResponse(_that.opId,_that.response);case WsLinkEvent_OperationComplete() when operationComplete != null:
return operationComplete(_that.opId);case WsLinkEvent_ProtocolError() when protocolError != null:
return protocolError(_that.code,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class WsLinkEvent_Connected extends WsLinkEvent {
  const WsLinkEvent_Connected(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent_Connected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsLinkEvent.connected()';
}


}




/// @nodoc


class WsLinkEvent_PingReceived extends WsLinkEvent {
  const WsLinkEvent_PingReceived({this.payload}): super._();


 final  ShalomJsonValue? payload;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsLinkEvent_PingReceivedCopyWith<WsLinkEvent_PingReceived> get copyWith => _$WsLinkEvent_PingReceivedCopyWithImpl<WsLinkEvent_PingReceived>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent_PingReceived&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode => Object.hash(runtimeType,payload);

@override
String toString() {
  return 'WsLinkEvent.pingReceived(payload: $payload)';
}


}

/// @nodoc
abstract mixin class $WsLinkEvent_PingReceivedCopyWith<$Res> implements $WsLinkEventCopyWith<$Res> {
  factory $WsLinkEvent_PingReceivedCopyWith(WsLinkEvent_PingReceived value, $Res Function(WsLinkEvent_PingReceived) _then) = _$WsLinkEvent_PingReceivedCopyWithImpl;
@useResult
$Res call({
 ShalomJsonValue? payload
});


$ShalomJsonValueCopyWith<$Res>? get payload;

}
/// @nodoc
class _$WsLinkEvent_PingReceivedCopyWithImpl<$Res>
    implements $WsLinkEvent_PingReceivedCopyWith<$Res> {
  _$WsLinkEvent_PingReceivedCopyWithImpl(this._self, this._then);

  final WsLinkEvent_PingReceived _self;
  final $Res Function(WsLinkEvent_PingReceived) _then;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? payload = freezed,}) {
  return _then(WsLinkEvent_PingReceived(
payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get payload {
    if (_self.payload == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.payload!, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}

/// @nodoc


class WsLinkEvent_PongReceived extends WsLinkEvent {
  const WsLinkEvent_PongReceived({this.payload}): super._();


 final  ShalomJsonValue? payload;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsLinkEvent_PongReceivedCopyWith<WsLinkEvent_PongReceived> get copyWith => _$WsLinkEvent_PongReceivedCopyWithImpl<WsLinkEvent_PongReceived>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent_PongReceived&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode => Object.hash(runtimeType,payload);

@override
String toString() {
  return 'WsLinkEvent.pongReceived(payload: $payload)';
}


}

/// @nodoc
abstract mixin class $WsLinkEvent_PongReceivedCopyWith<$Res> implements $WsLinkEventCopyWith<$Res> {
  factory $WsLinkEvent_PongReceivedCopyWith(WsLinkEvent_PongReceived value, $Res Function(WsLinkEvent_PongReceived) _then) = _$WsLinkEvent_PongReceivedCopyWithImpl;
@useResult
$Res call({
 ShalomJsonValue? payload
});


$ShalomJsonValueCopyWith<$Res>? get payload;

}
/// @nodoc
class _$WsLinkEvent_PongReceivedCopyWithImpl<$Res>
    implements $WsLinkEvent_PongReceivedCopyWith<$Res> {
  _$WsLinkEvent_PongReceivedCopyWithImpl(this._self, this._then);

  final WsLinkEvent_PongReceived _self;
  final $Res Function(WsLinkEvent_PongReceived) _then;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? payload = freezed,}) {
  return _then(WsLinkEvent_PongReceived(
payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get payload {
    if (_self.payload == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.payload!, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}

/// @nodoc


class WsLinkEvent_OperationResponse extends WsLinkEvent {
  const WsLinkEvent_OperationResponse({required this.opId, required this.response}): super._();


 final  String opId;
 final  GraphQlResponseInput response;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsLinkEvent_OperationResponseCopyWith<WsLinkEvent_OperationResponse> get copyWith => _$WsLinkEvent_OperationResponseCopyWithImpl<WsLinkEvent_OperationResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent_OperationResponse&&(identical(other.opId, opId) || other.opId == opId)&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,opId,response);

@override
String toString() {
  return 'WsLinkEvent.operationResponse(opId: $opId, response: $response)';
}


}

/// @nodoc
abstract mixin class $WsLinkEvent_OperationResponseCopyWith<$Res> implements $WsLinkEventCopyWith<$Res> {
  factory $WsLinkEvent_OperationResponseCopyWith(WsLinkEvent_OperationResponse value, $Res Function(WsLinkEvent_OperationResponse) _then) = _$WsLinkEvent_OperationResponseCopyWithImpl;
@useResult
$Res call({
 String opId, GraphQlResponseInput response
});


$GraphQlResponseInputCopyWith<$Res> get response;

}
/// @nodoc
class _$WsLinkEvent_OperationResponseCopyWithImpl<$Res>
    implements $WsLinkEvent_OperationResponseCopyWith<$Res> {
  _$WsLinkEvent_OperationResponseCopyWithImpl(this._self, this._then);

  final WsLinkEvent_OperationResponse _self;
  final $Res Function(WsLinkEvent_OperationResponse) _then;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? opId = null,Object? response = null,}) {
  return _then(WsLinkEvent_OperationResponse(
opId: null == opId ? _self.opId : opId // ignore: cast_nullable_to_non_nullable
as String,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as GraphQlResponseInput,
  ));
}

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GraphQlResponseInputCopyWith<$Res> get response {

  return $GraphQlResponseInputCopyWith<$Res>(_self.response, (value) {
    return _then(_self.copyWith(response: value));
  });
}
}

/// @nodoc


class WsLinkEvent_OperationComplete extends WsLinkEvent {
  const WsLinkEvent_OperationComplete({required this.opId}): super._();


 final  String opId;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsLinkEvent_OperationCompleteCopyWith<WsLinkEvent_OperationComplete> get copyWith => _$WsLinkEvent_OperationCompleteCopyWithImpl<WsLinkEvent_OperationComplete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent_OperationComplete&&(identical(other.opId, opId) || other.opId == opId));
}


@override
int get hashCode => Object.hash(runtimeType,opId);

@override
String toString() {
  return 'WsLinkEvent.operationComplete(opId: $opId)';
}


}

/// @nodoc
abstract mixin class $WsLinkEvent_OperationCompleteCopyWith<$Res> implements $WsLinkEventCopyWith<$Res> {
  factory $WsLinkEvent_OperationCompleteCopyWith(WsLinkEvent_OperationComplete value, $Res Function(WsLinkEvent_OperationComplete) _then) = _$WsLinkEvent_OperationCompleteCopyWithImpl;
@useResult
$Res call({
 String opId
});




}
/// @nodoc
class _$WsLinkEvent_OperationCompleteCopyWithImpl<$Res>
    implements $WsLinkEvent_OperationCompleteCopyWith<$Res> {
  _$WsLinkEvent_OperationCompleteCopyWithImpl(this._self, this._then);

  final WsLinkEvent_OperationComplete _self;
  final $Res Function(WsLinkEvent_OperationComplete) _then;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? opId = null,}) {
  return _then(WsLinkEvent_OperationComplete(
opId: null == opId ? _self.opId : opId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WsLinkEvent_ProtocolError extends WsLinkEvent {
  const WsLinkEvent_ProtocolError({required this.code, required this.reason}): super._();


 final  int code;
 final  String reason;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsLinkEvent_ProtocolErrorCopyWith<WsLinkEvent_ProtocolError> get copyWith => _$WsLinkEvent_ProtocolErrorCopyWithImpl<WsLinkEvent_ProtocolError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsLinkEvent_ProtocolError&&(identical(other.code, code) || other.code == code)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,code,reason);

@override
String toString() {
  return 'WsLinkEvent.protocolError(code: $code, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $WsLinkEvent_ProtocolErrorCopyWith<$Res> implements $WsLinkEventCopyWith<$Res> {
  factory $WsLinkEvent_ProtocolErrorCopyWith(WsLinkEvent_ProtocolError value, $Res Function(WsLinkEvent_ProtocolError) _then) = _$WsLinkEvent_ProtocolErrorCopyWithImpl;
@useResult
$Res call({
 int code, String reason
});




}
/// @nodoc
class _$WsLinkEvent_ProtocolErrorCopyWithImpl<$Res>
    implements $WsLinkEvent_ProtocolErrorCopyWith<$Res> {
  _$WsLinkEvent_ProtocolErrorCopyWithImpl(this._self, this._then);

  final WsLinkEvent_ProtocolError _self;
  final $Res Function(WsLinkEvent_ProtocolError) _then;

/// Create a copy of WsLinkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? reason = null,}) {
  return _then(WsLinkEvent_ProtocolError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
