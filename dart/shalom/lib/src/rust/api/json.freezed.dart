// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'json.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShalomJsonValue {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShalomJsonValue()';
}


}

/// @nodoc
class $ShalomJsonValueCopyWith<$Res>  {
$ShalomJsonValueCopyWith(ShalomJsonValue _, $Res Function(ShalomJsonValue) __);
}


/// Adds pattern-matching-related methods to [ShalomJsonValue].
extension ShalomJsonValuePatterns on ShalomJsonValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShalomJsonValue_Null value)?  null_,TResult Function( ShalomJsonValue_Boolean value)?  boolean,TResult Function( ShalomJsonValue_Integer value)?  integer,TResult Function( ShalomJsonValue_Float value)?  float,TResult Function( ShalomJsonValue_String value)?  string,TResult Function( ShalomJsonValue_Array value)?  array,TResult Function( ShalomJsonValue_Object value)?  object,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShalomJsonValue_Null() when null_ != null:
return null_(_that);case ShalomJsonValue_Boolean() when boolean != null:
return boolean(_that);case ShalomJsonValue_Integer() when integer != null:
return integer(_that);case ShalomJsonValue_Float() when float != null:
return float(_that);case ShalomJsonValue_String() when string != null:
return string(_that);case ShalomJsonValue_Array() when array != null:
return array(_that);case ShalomJsonValue_Object() when object != null:
return object(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShalomJsonValue_Null value)  null_,required TResult Function( ShalomJsonValue_Boolean value)  boolean,required TResult Function( ShalomJsonValue_Integer value)  integer,required TResult Function( ShalomJsonValue_Float value)  float,required TResult Function( ShalomJsonValue_String value)  string,required TResult Function( ShalomJsonValue_Array value)  array,required TResult Function( ShalomJsonValue_Object value)  object,}){
final _that = this;
switch (_that) {
case ShalomJsonValue_Null():
return null_(_that);case ShalomJsonValue_Boolean():
return boolean(_that);case ShalomJsonValue_Integer():
return integer(_that);case ShalomJsonValue_Float():
return float(_that);case ShalomJsonValue_String():
return string(_that);case ShalomJsonValue_Array():
return array(_that);case ShalomJsonValue_Object():
return object(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShalomJsonValue_Null value)?  null_,TResult? Function( ShalomJsonValue_Boolean value)?  boolean,TResult? Function( ShalomJsonValue_Integer value)?  integer,TResult? Function( ShalomJsonValue_Float value)?  float,TResult? Function( ShalomJsonValue_String value)?  string,TResult? Function( ShalomJsonValue_Array value)?  array,TResult? Function( ShalomJsonValue_Object value)?  object,}){
final _that = this;
switch (_that) {
case ShalomJsonValue_Null() when null_ != null:
return null_(_that);case ShalomJsonValue_Boolean() when boolean != null:
return boolean(_that);case ShalomJsonValue_Integer() when integer != null:
return integer(_that);case ShalomJsonValue_Float() when float != null:
return float(_that);case ShalomJsonValue_String() when string != null:
return string(_that);case ShalomJsonValue_Array() when array != null:
return array(_that);case ShalomJsonValue_Object() when object != null:
return object(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  null_,TResult Function( bool field0)?  boolean,TResult Function( PlatformInt64 field0)?  integer,TResult Function( double field0)?  float,TResult Function( String field0)?  string,TResult Function( List<ShalomJsonValue> field0)?  array,TResult Function( Map<String, ShalomJsonValue> field0)?  object,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShalomJsonValue_Null() when null_ != null:
return null_();case ShalomJsonValue_Boolean() when boolean != null:
return boolean(_that.field0);case ShalomJsonValue_Integer() when integer != null:
return integer(_that.field0);case ShalomJsonValue_Float() when float != null:
return float(_that.field0);case ShalomJsonValue_String() when string != null:
return string(_that.field0);case ShalomJsonValue_Array() when array != null:
return array(_that.field0);case ShalomJsonValue_Object() when object != null:
return object(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  null_,required TResult Function( bool field0)  boolean,required TResult Function( PlatformInt64 field0)  integer,required TResult Function( double field0)  float,required TResult Function( String field0)  string,required TResult Function( List<ShalomJsonValue> field0)  array,required TResult Function( Map<String, ShalomJsonValue> field0)  object,}) {final _that = this;
switch (_that) {
case ShalomJsonValue_Null():
return null_();case ShalomJsonValue_Boolean():
return boolean(_that.field0);case ShalomJsonValue_Integer():
return integer(_that.field0);case ShalomJsonValue_Float():
return float(_that.field0);case ShalomJsonValue_String():
return string(_that.field0);case ShalomJsonValue_Array():
return array(_that.field0);case ShalomJsonValue_Object():
return object(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  null_,TResult? Function( bool field0)?  boolean,TResult? Function( PlatformInt64 field0)?  integer,TResult? Function( double field0)?  float,TResult? Function( String field0)?  string,TResult? Function( List<ShalomJsonValue> field0)?  array,TResult? Function( Map<String, ShalomJsonValue> field0)?  object,}) {final _that = this;
switch (_that) {
case ShalomJsonValue_Null() when null_ != null:
return null_();case ShalomJsonValue_Boolean() when boolean != null:
return boolean(_that.field0);case ShalomJsonValue_Integer() when integer != null:
return integer(_that.field0);case ShalomJsonValue_Float() when float != null:
return float(_that.field0);case ShalomJsonValue_String() when string != null:
return string(_that.field0);case ShalomJsonValue_Array() when array != null:
return array(_that.field0);case ShalomJsonValue_Object() when object != null:
return object(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ShalomJsonValue_Null extends ShalomJsonValue {
  const ShalomJsonValue_Null(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_Null);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShalomJsonValue.null_()';
}


}




/// @nodoc


class ShalomJsonValue_Boolean extends ShalomJsonValue {
  const ShalomJsonValue_Boolean(this.field0): super._();
  

 final  bool field0;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalomJsonValue_BooleanCopyWith<ShalomJsonValue_Boolean> get copyWith => _$ShalomJsonValue_BooleanCopyWithImpl<ShalomJsonValue_Boolean>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_Boolean&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ShalomJsonValue.boolean(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ShalomJsonValue_BooleanCopyWith<$Res> implements $ShalomJsonValueCopyWith<$Res> {
  factory $ShalomJsonValue_BooleanCopyWith(ShalomJsonValue_Boolean value, $Res Function(ShalomJsonValue_Boolean) _then) = _$ShalomJsonValue_BooleanCopyWithImpl;
@useResult
$Res call({
 bool field0
});




}
/// @nodoc
class _$ShalomJsonValue_BooleanCopyWithImpl<$Res>
    implements $ShalomJsonValue_BooleanCopyWith<$Res> {
  _$ShalomJsonValue_BooleanCopyWithImpl(this._self, this._then);

  final ShalomJsonValue_Boolean _self;
  final $Res Function(ShalomJsonValue_Boolean) _then;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ShalomJsonValue_Boolean(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ShalomJsonValue_Integer extends ShalomJsonValue {
  const ShalomJsonValue_Integer(this.field0): super._();
  

 final  PlatformInt64 field0;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalomJsonValue_IntegerCopyWith<ShalomJsonValue_Integer> get copyWith => _$ShalomJsonValue_IntegerCopyWithImpl<ShalomJsonValue_Integer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_Integer&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ShalomJsonValue.integer(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ShalomJsonValue_IntegerCopyWith<$Res> implements $ShalomJsonValueCopyWith<$Res> {
  factory $ShalomJsonValue_IntegerCopyWith(ShalomJsonValue_Integer value, $Res Function(ShalomJsonValue_Integer) _then) = _$ShalomJsonValue_IntegerCopyWithImpl;
@useResult
$Res call({
 PlatformInt64 field0
});




}
/// @nodoc
class _$ShalomJsonValue_IntegerCopyWithImpl<$Res>
    implements $ShalomJsonValue_IntegerCopyWith<$Res> {
  _$ShalomJsonValue_IntegerCopyWithImpl(this._self, this._then);

  final ShalomJsonValue_Integer _self;
  final $Res Function(ShalomJsonValue_Integer) _then;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ShalomJsonValue_Integer(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class ShalomJsonValue_Float extends ShalomJsonValue {
  const ShalomJsonValue_Float(this.field0): super._();
  

 final  double field0;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalomJsonValue_FloatCopyWith<ShalomJsonValue_Float> get copyWith => _$ShalomJsonValue_FloatCopyWithImpl<ShalomJsonValue_Float>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_Float&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ShalomJsonValue.float(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ShalomJsonValue_FloatCopyWith<$Res> implements $ShalomJsonValueCopyWith<$Res> {
  factory $ShalomJsonValue_FloatCopyWith(ShalomJsonValue_Float value, $Res Function(ShalomJsonValue_Float) _then) = _$ShalomJsonValue_FloatCopyWithImpl;
@useResult
$Res call({
 double field0
});




}
/// @nodoc
class _$ShalomJsonValue_FloatCopyWithImpl<$Res>
    implements $ShalomJsonValue_FloatCopyWith<$Res> {
  _$ShalomJsonValue_FloatCopyWithImpl(this._self, this._then);

  final ShalomJsonValue_Float _self;
  final $Res Function(ShalomJsonValue_Float) _then;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ShalomJsonValue_Float(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ShalomJsonValue_String extends ShalomJsonValue {
  const ShalomJsonValue_String(this.field0): super._();
  

 final  String field0;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalomJsonValue_StringCopyWith<ShalomJsonValue_String> get copyWith => _$ShalomJsonValue_StringCopyWithImpl<ShalomJsonValue_String>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_String&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ShalomJsonValue.string(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ShalomJsonValue_StringCopyWith<$Res> implements $ShalomJsonValueCopyWith<$Res> {
  factory $ShalomJsonValue_StringCopyWith(ShalomJsonValue_String value, $Res Function(ShalomJsonValue_String) _then) = _$ShalomJsonValue_StringCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$ShalomJsonValue_StringCopyWithImpl<$Res>
    implements $ShalomJsonValue_StringCopyWith<$Res> {
  _$ShalomJsonValue_StringCopyWithImpl(this._self, this._then);

  final ShalomJsonValue_String _self;
  final $Res Function(ShalomJsonValue_String) _then;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ShalomJsonValue_String(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ShalomJsonValue_Array extends ShalomJsonValue {
  const ShalomJsonValue_Array(final  List<ShalomJsonValue> field0): _field0 = field0,super._();
  

 final  List<ShalomJsonValue> _field0;
 List<ShalomJsonValue> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalomJsonValue_ArrayCopyWith<ShalomJsonValue_Array> get copyWith => _$ShalomJsonValue_ArrayCopyWithImpl<ShalomJsonValue_Array>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_Array&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'ShalomJsonValue.array(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ShalomJsonValue_ArrayCopyWith<$Res> implements $ShalomJsonValueCopyWith<$Res> {
  factory $ShalomJsonValue_ArrayCopyWith(ShalomJsonValue_Array value, $Res Function(ShalomJsonValue_Array) _then) = _$ShalomJsonValue_ArrayCopyWithImpl;
@useResult
$Res call({
 List<ShalomJsonValue> field0
});




}
/// @nodoc
class _$ShalomJsonValue_ArrayCopyWithImpl<$Res>
    implements $ShalomJsonValue_ArrayCopyWith<$Res> {
  _$ShalomJsonValue_ArrayCopyWithImpl(this._self, this._then);

  final ShalomJsonValue_Array _self;
  final $Res Function(ShalomJsonValue_Array) _then;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ShalomJsonValue_Array(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<ShalomJsonValue>,
  ));
}


}

/// @nodoc


class ShalomJsonValue_Object extends ShalomJsonValue {
  const ShalomJsonValue_Object(final  Map<String, ShalomJsonValue> field0): _field0 = field0,super._();
  

 final  Map<String, ShalomJsonValue> _field0;
 Map<String, ShalomJsonValue> get field0 {
  if (_field0 is EqualUnmodifiableMapView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_field0);
}


/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalomJsonValue_ObjectCopyWith<ShalomJsonValue_Object> get copyWith => _$ShalomJsonValue_ObjectCopyWithImpl<ShalomJsonValue_Object>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalomJsonValue_Object&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'ShalomJsonValue.object(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ShalomJsonValue_ObjectCopyWith<$Res> implements $ShalomJsonValueCopyWith<$Res> {
  factory $ShalomJsonValue_ObjectCopyWith(ShalomJsonValue_Object value, $Res Function(ShalomJsonValue_Object) _then) = _$ShalomJsonValue_ObjectCopyWithImpl;
@useResult
$Res call({
 Map<String, ShalomJsonValue> field0
});




}
/// @nodoc
class _$ShalomJsonValue_ObjectCopyWithImpl<$Res>
    implements $ShalomJsonValue_ObjectCopyWith<$Res> {
  _$ShalomJsonValue_ObjectCopyWithImpl(this._self, this._then);

  final ShalomJsonValue_Object _self;
  final $Res Function(ShalomJsonValue_Object) _then;

/// Create a copy of ShalomJsonValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ShalomJsonValue_Object(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as Map<String, ShalomJsonValue>,
  ));
}


}

// dart format on
