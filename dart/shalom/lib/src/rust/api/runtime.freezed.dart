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
mixin _$GraphQlResponseInput {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphQlResponseInput);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GraphQlResponseInput()';
}


}

/// @nodoc
class $GraphQlResponseInputCopyWith<$Res>  {
$GraphQlResponseInputCopyWith(GraphQlResponseInput _, $Res Function(GraphQlResponseInput) __);
}


/// Adds pattern-matching-related methods to [GraphQlResponseInput].
extension GraphQlResponseInputPatterns on GraphQlResponseInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GraphQlResponseInput_Data value)?  data,TResult Function( GraphQlResponseInput_Error value)?  error,TResult Function( GraphQlResponseInput_TransportError value)?  transportError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GraphQlResponseInput_Data() when data != null:
return data(_that);case GraphQlResponseInput_Error() when error != null:
return error(_that);case GraphQlResponseInput_TransportError() when transportError != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GraphQlResponseInput_Data value)  data,required TResult Function( GraphQlResponseInput_Error value)  error,required TResult Function( GraphQlResponseInput_TransportError value)  transportError,}){
final _that = this;
switch (_that) {
case GraphQlResponseInput_Data():
return data(_that);case GraphQlResponseInput_Error():
return error(_that);case GraphQlResponseInput_TransportError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GraphQlResponseInput_Data value)?  data,TResult? Function( GraphQlResponseInput_Error value)?  error,TResult? Function( GraphQlResponseInput_TransportError value)?  transportError,}){
final _that = this;
switch (_that) {
case GraphQlResponseInput_Data() when data != null:
return data(_that);case GraphQlResponseInput_Error() when error != null:
return error(_that);case GraphQlResponseInput_TransportError() when transportError != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ShalomJsonValue data,  List<ShalomJsonValue>? errors,  ShalomJsonValue? extensions)?  data,TResult Function( List<ShalomJsonValue> errors,  ShalomJsonValue? extensions)?  error,TResult Function( String message,  String code,  ShalomJsonValue? details)?  transportError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GraphQlResponseInput_Data() when data != null:
return data(_that.data,_that.errors,_that.extensions);case GraphQlResponseInput_Error() when error != null:
return error(_that.errors,_that.extensions);case GraphQlResponseInput_TransportError() when transportError != null:
return transportError(_that.message,_that.code,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ShalomJsonValue data,  List<ShalomJsonValue>? errors,  ShalomJsonValue? extensions)  data,required TResult Function( List<ShalomJsonValue> errors,  ShalomJsonValue? extensions)  error,required TResult Function( String message,  String code,  ShalomJsonValue? details)  transportError,}) {final _that = this;
switch (_that) {
case GraphQlResponseInput_Data():
return data(_that.data,_that.errors,_that.extensions);case GraphQlResponseInput_Error():
return error(_that.errors,_that.extensions);case GraphQlResponseInput_TransportError():
return transportError(_that.message,_that.code,_that.details);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ShalomJsonValue data,  List<ShalomJsonValue>? errors,  ShalomJsonValue? extensions)?  data,TResult? Function( List<ShalomJsonValue> errors,  ShalomJsonValue? extensions)?  error,TResult? Function( String message,  String code,  ShalomJsonValue? details)?  transportError,}) {final _that = this;
switch (_that) {
case GraphQlResponseInput_Data() when data != null:
return data(_that.data,_that.errors,_that.extensions);case GraphQlResponseInput_Error() when error != null:
return error(_that.errors,_that.extensions);case GraphQlResponseInput_TransportError() when transportError != null:
return transportError(_that.message,_that.code,_that.details);case _:
  return null;

}
}

}

/// @nodoc


class GraphQlResponseInput_Data extends GraphQlResponseInput {
  const GraphQlResponseInput_Data({required this.data, final  List<ShalomJsonValue>? errors, this.extensions}): _errors = errors,super._();


 final  ShalomJsonValue data;
 final  List<ShalomJsonValue>? _errors;
 List<ShalomJsonValue>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  ShalomJsonValue? extensions;

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphQlResponseInput_DataCopyWith<GraphQlResponseInput_Data> get copyWith => _$GraphQlResponseInput_DataCopyWithImpl<GraphQlResponseInput_Data>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphQlResponseInput_Data&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.extensions, extensions) || other.extensions == extensions));
}


@override
int get hashCode => Object.hash(runtimeType,data,const DeepCollectionEquality().hash(_errors),extensions);

@override
String toString() {
  return 'GraphQlResponseInput.data(data: $data, errors: $errors, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $GraphQlResponseInput_DataCopyWith<$Res> implements $GraphQlResponseInputCopyWith<$Res> {
  factory $GraphQlResponseInput_DataCopyWith(GraphQlResponseInput_Data value, $Res Function(GraphQlResponseInput_Data) _then) = _$GraphQlResponseInput_DataCopyWithImpl;
@useResult
$Res call({
 ShalomJsonValue data, List<ShalomJsonValue>? errors, ShalomJsonValue? extensions
});


$ShalomJsonValueCopyWith<$Res> get data;$ShalomJsonValueCopyWith<$Res>? get extensions;

}
/// @nodoc
class _$GraphQlResponseInput_DataCopyWithImpl<$Res>
    implements $GraphQlResponseInput_DataCopyWith<$Res> {
  _$GraphQlResponseInput_DataCopyWithImpl(this._self, this._then);

  final GraphQlResponseInput_Data _self;
  final $Res Function(GraphQlResponseInput_Data) _then;

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? errors = freezed,Object? extensions = freezed,}) {
  return _then(GraphQlResponseInput_Data(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<ShalomJsonValue>?,extensions: freezed == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res> get data {

  return $ShalomJsonValueCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get extensions {
    if (_self.extensions == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.extensions!, (value) {
    return _then(_self.copyWith(extensions: value));
  });
}
}

/// @nodoc


class GraphQlResponseInput_Error extends GraphQlResponseInput {
  const GraphQlResponseInput_Error({required final  List<ShalomJsonValue> errors, this.extensions}): _errors = errors,super._();


 final  List<ShalomJsonValue> _errors;
 List<ShalomJsonValue> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

 final  ShalomJsonValue? extensions;

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphQlResponseInput_ErrorCopyWith<GraphQlResponseInput_Error> get copyWith => _$GraphQlResponseInput_ErrorCopyWithImpl<GraphQlResponseInput_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphQlResponseInput_Error&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.extensions, extensions) || other.extensions == extensions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_errors),extensions);

@override
String toString() {
  return 'GraphQlResponseInput.error(errors: $errors, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $GraphQlResponseInput_ErrorCopyWith<$Res> implements $GraphQlResponseInputCopyWith<$Res> {
  factory $GraphQlResponseInput_ErrorCopyWith(GraphQlResponseInput_Error value, $Res Function(GraphQlResponseInput_Error) _then) = _$GraphQlResponseInput_ErrorCopyWithImpl;
@useResult
$Res call({
 List<ShalomJsonValue> errors, ShalomJsonValue? extensions
});


$ShalomJsonValueCopyWith<$Res>? get extensions;

}
/// @nodoc
class _$GraphQlResponseInput_ErrorCopyWithImpl<$Res>
    implements $GraphQlResponseInput_ErrorCopyWith<$Res> {
  _$GraphQlResponseInput_ErrorCopyWithImpl(this._self, this._then);

  final GraphQlResponseInput_Error _self;
  final $Res Function(GraphQlResponseInput_Error) _then;

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errors = null,Object? extensions = freezed,}) {
  return _then(GraphQlResponseInput_Error(
errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<ShalomJsonValue>,extensions: freezed == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get extensions {
    if (_self.extensions == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.extensions!, (value) {
    return _then(_self.copyWith(extensions: value));
  });
}
}

/// @nodoc


class GraphQlResponseInput_TransportError extends GraphQlResponseInput {
  const GraphQlResponseInput_TransportError({required this.message, required this.code, this.details}): super._();


 final  String message;
 final  String code;
 final  ShalomJsonValue? details;

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphQlResponseInput_TransportErrorCopyWith<GraphQlResponseInput_TransportError> get copyWith => _$GraphQlResponseInput_TransportErrorCopyWithImpl<GraphQlResponseInput_TransportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphQlResponseInput_TransportError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,details);

@override
String toString() {
  return 'GraphQlResponseInput.transportError(message: $message, code: $code, details: $details)';
}


}

/// @nodoc
abstract mixin class $GraphQlResponseInput_TransportErrorCopyWith<$Res> implements $GraphQlResponseInputCopyWith<$Res> {
  factory $GraphQlResponseInput_TransportErrorCopyWith(GraphQlResponseInput_TransportError value, $Res Function(GraphQlResponseInput_TransportError) _then) = _$GraphQlResponseInput_TransportErrorCopyWithImpl;
@useResult
$Res call({
 String message, String code, ShalomJsonValue? details
});


$ShalomJsonValueCopyWith<$Res>? get details;

}
/// @nodoc
class _$GraphQlResponseInput_TransportErrorCopyWithImpl<$Res>
    implements $GraphQlResponseInput_TransportErrorCopyWith<$Res> {
  _$GraphQlResponseInput_TransportErrorCopyWithImpl(this._self, this._then);

  final GraphQlResponseInput_TransportError _self;
  final $Res Function(GraphQlResponseInput_TransportError) _then;

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = null,Object? details = freezed,}) {
  return _then(GraphQlResponseInput_TransportError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of GraphQlResponseInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

/// @nodoc
mixin _$RetryDelayInput {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetryDelayInput);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RetryDelayInput()';
}


}

/// @nodoc
class $RetryDelayInputCopyWith<$Res>  {
$RetryDelayInputCopyWith(RetryDelayInput _, $Res Function(RetryDelayInput) __);
}


/// Adds pattern-matching-related methods to [RetryDelayInput].
extension RetryDelayInputPatterns on RetryDelayInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RetryDelayInput_Inherit value)?  inherit,TResult Function( RetryDelayInput_Disabled value)?  disabled,TResult Function( RetryDelayInput_Millis value)?  millis,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RetryDelayInput_Inherit() when inherit != null:
return inherit(_that);case RetryDelayInput_Disabled() when disabled != null:
return disabled(_that);case RetryDelayInput_Millis() when millis != null:
return millis(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RetryDelayInput_Inherit value)  inherit,required TResult Function( RetryDelayInput_Disabled value)  disabled,required TResult Function( RetryDelayInput_Millis value)  millis,}){
final _that = this;
switch (_that) {
case RetryDelayInput_Inherit():
return inherit(_that);case RetryDelayInput_Disabled():
return disabled(_that);case RetryDelayInput_Millis():
return millis(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RetryDelayInput_Inherit value)?  inherit,TResult? Function( RetryDelayInput_Disabled value)?  disabled,TResult? Function( RetryDelayInput_Millis value)?  millis,}){
final _that = this;
switch (_that) {
case RetryDelayInput_Inherit() when inherit != null:
return inherit(_that);case RetryDelayInput_Disabled() when disabled != null:
return disabled(_that);case RetryDelayInput_Millis() when millis != null:
return millis(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  inherit,TResult Function()?  disabled,TResult Function( BigInt field0)?  millis,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RetryDelayInput_Inherit() when inherit != null:
return inherit();case RetryDelayInput_Disabled() when disabled != null:
return disabled();case RetryDelayInput_Millis() when millis != null:
return millis(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  inherit,required TResult Function()  disabled,required TResult Function( BigInt field0)  millis,}) {final _that = this;
switch (_that) {
case RetryDelayInput_Inherit():
return inherit();case RetryDelayInput_Disabled():
return disabled();case RetryDelayInput_Millis():
return millis(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  inherit,TResult? Function()?  disabled,TResult? Function( BigInt field0)?  millis,}) {final _that = this;
switch (_that) {
case RetryDelayInput_Inherit() when inherit != null:
return inherit();case RetryDelayInput_Disabled() when disabled != null:
return disabled();case RetryDelayInput_Millis() when millis != null:
return millis(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class RetryDelayInput_Inherit extends RetryDelayInput {
  const RetryDelayInput_Inherit(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetryDelayInput_Inherit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RetryDelayInput.inherit()';
}


}




/// @nodoc


class RetryDelayInput_Disabled extends RetryDelayInput {
  const RetryDelayInput_Disabled(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetryDelayInput_Disabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RetryDelayInput.disabled()';
}


}




/// @nodoc


class RetryDelayInput_Millis extends RetryDelayInput {
  const RetryDelayInput_Millis(this.field0): super._();


 final  BigInt field0;

/// Create a copy of RetryDelayInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetryDelayInput_MillisCopyWith<RetryDelayInput_Millis> get copyWith => _$RetryDelayInput_MillisCopyWithImpl<RetryDelayInput_Millis>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetryDelayInput_Millis&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RetryDelayInput.millis(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RetryDelayInput_MillisCopyWith<$Res> implements $RetryDelayInputCopyWith<$Res> {
  factory $RetryDelayInput_MillisCopyWith(RetryDelayInput_Millis value, $Res Function(RetryDelayInput_Millis) _then) = _$RetryDelayInput_MillisCopyWithImpl;
@useResult
$Res call({
 BigInt field0
});




}
/// @nodoc
class _$RetryDelayInput_MillisCopyWithImpl<$Res>
    implements $RetryDelayInput_MillisCopyWith<$Res> {
  _$RetryDelayInput_MillisCopyWithImpl(this._self, this._then);

  final RetryDelayInput_Millis _self;
  final $Res Function(RetryDelayInput_Millis) _then;

/// Create a copy of RetryDelayInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RetryDelayInput_Millis(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ShalomJsonValue data)?  data,TResult Function( List<ShalomJsonValue> errors,  ShalomJsonValue? extensions)?  graphQlError,TResult Function( String code,  String message,  ShalomJsonValue? details)?  transportError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SubscriptionEvent_Data() when data != null:
return data(_that.data);case SubscriptionEvent_GraphQlError() when graphQlError != null:
return graphQlError(_that.errors,_that.extensions);case SubscriptionEvent_TransportError() when transportError != null:
return transportError(_that.code,_that.message,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ShalomJsonValue data)  data,required TResult Function( List<ShalomJsonValue> errors,  ShalomJsonValue? extensions)  graphQlError,required TResult Function( String code,  String message,  ShalomJsonValue? details)  transportError,}) {final _that = this;
switch (_that) {
case SubscriptionEvent_Data():
return data(_that.data);case SubscriptionEvent_GraphQlError():
return graphQlError(_that.errors,_that.extensions);case SubscriptionEvent_TransportError():
return transportError(_that.code,_that.message,_that.details);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ShalomJsonValue data)?  data,TResult? Function( List<ShalomJsonValue> errors,  ShalomJsonValue? extensions)?  graphQlError,TResult? Function( String code,  String message,  ShalomJsonValue? details)?  transportError,}) {final _that = this;
switch (_that) {
case SubscriptionEvent_Data() when data != null:
return data(_that.data);case SubscriptionEvent_GraphQlError() when graphQlError != null:
return graphQlError(_that.errors,_that.extensions);case SubscriptionEvent_TransportError() when transportError != null:
return transportError(_that.code,_that.message,_that.details);case _:
  return null;

}
}

}

/// @nodoc


class SubscriptionEvent_Data extends SubscriptionEvent {
  const SubscriptionEvent_Data({required this.data}): super._();


 final  ShalomJsonValue data;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEvent_DataCopyWith<SubscriptionEvent_Data> get copyWith => _$SubscriptionEvent_DataCopyWithImpl<SubscriptionEvent_Data>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent_Data&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'SubscriptionEvent.data(data: $data)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEvent_DataCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEvent_DataCopyWith(SubscriptionEvent_Data value, $Res Function(SubscriptionEvent_Data) _then) = _$SubscriptionEvent_DataCopyWithImpl;
@useResult
$Res call({
 ShalomJsonValue data
});


$ShalomJsonValueCopyWith<$Res> get data;

}
/// @nodoc
class _$SubscriptionEvent_DataCopyWithImpl<$Res>
    implements $SubscriptionEvent_DataCopyWith<$Res> {
  _$SubscriptionEvent_DataCopyWithImpl(this._self, this._then);

  final SubscriptionEvent_Data _self;
  final $Res Function(SubscriptionEvent_Data) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(SubscriptionEvent_Data(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue,
  ));
}

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res> get data {

  return $ShalomJsonValueCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class SubscriptionEvent_GraphQlError extends SubscriptionEvent {
  const SubscriptionEvent_GraphQlError({required final  List<ShalomJsonValue> errors, this.extensions}): _errors = errors,super._();


 final  List<ShalomJsonValue> _errors;
 List<ShalomJsonValue> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

 final  ShalomJsonValue? extensions;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEvent_GraphQlErrorCopyWith<SubscriptionEvent_GraphQlError> get copyWith => _$SubscriptionEvent_GraphQlErrorCopyWithImpl<SubscriptionEvent_GraphQlError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent_GraphQlError&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.extensions, extensions) || other.extensions == extensions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_errors),extensions);

@override
String toString() {
  return 'SubscriptionEvent.graphQlError(errors: $errors, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEvent_GraphQlErrorCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEvent_GraphQlErrorCopyWith(SubscriptionEvent_GraphQlError value, $Res Function(SubscriptionEvent_GraphQlError) _then) = _$SubscriptionEvent_GraphQlErrorCopyWithImpl;
@useResult
$Res call({
 List<ShalomJsonValue> errors, ShalomJsonValue? extensions
});


$ShalomJsonValueCopyWith<$Res>? get extensions;

}
/// @nodoc
class _$SubscriptionEvent_GraphQlErrorCopyWithImpl<$Res>
    implements $SubscriptionEvent_GraphQlErrorCopyWith<$Res> {
  _$SubscriptionEvent_GraphQlErrorCopyWithImpl(this._self, this._then);

  final SubscriptionEvent_GraphQlError _self;
  final $Res Function(SubscriptionEvent_GraphQlError) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errors = null,Object? extensions = freezed,}) {
  return _then(SubscriptionEvent_GraphQlError(
errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<ShalomJsonValue>,extensions: freezed == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get extensions {
    if (_self.extensions == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.extensions!, (value) {
    return _then(_self.copyWith(extensions: value));
  });
}
}

/// @nodoc


class SubscriptionEvent_TransportError extends SubscriptionEvent {
  const SubscriptionEvent_TransportError({required this.code, required this.message, this.details}): super._();


 final  String code;
 final  String message;
 final  ShalomJsonValue? details;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEvent_TransportErrorCopyWith<SubscriptionEvent_TransportError> get copyWith => _$SubscriptionEvent_TransportErrorCopyWithImpl<SubscriptionEvent_TransportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent_TransportError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,code,message,details);

@override
String toString() {
  return 'SubscriptionEvent.transportError(code: $code, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEvent_TransportErrorCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEvent_TransportErrorCopyWith(SubscriptionEvent_TransportError value, $Res Function(SubscriptionEvent_TransportError) _then) = _$SubscriptionEvent_TransportErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, ShalomJsonValue? details
});


$ShalomJsonValueCopyWith<$Res>? get details;

}
/// @nodoc
class _$SubscriptionEvent_TransportErrorCopyWithImpl<$Res>
    implements $SubscriptionEvent_TransportErrorCopyWith<$Res> {
  _$SubscriptionEvent_TransportErrorCopyWithImpl(this._self, this._then);

  final SubscriptionEvent_TransportError _self;
  final $Res Function(SubscriptionEvent_TransportError) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? details = freezed,}) {
  return _then(SubscriptionEvent_TransportError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as ShalomJsonValue?,
  ));
}

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShalomJsonValueCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $ShalomJsonValueCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
