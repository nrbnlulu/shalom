import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show PlatformInt64Util;
import 'package:shalom/src/rust/api/json.dart' as rs_json;

typedef HeadersType = List<(String, String)>;
typedef JsonObject = Map<String, dynamic>;
typedef ShalomJsonValue = rs_json.ShalomJsonValue;

ShalomJsonValue shalomJsonValue(Object? value) => switch (value) {
  null => const rs_json.ShalomJsonValue.null_(),
  bool value => rs_json.ShalomJsonValue.boolean(value),
  int value => rs_json.ShalomJsonValue.integer(PlatformInt64Util.from(value)),
  double value => rs_json.ShalomJsonValue.float(value),
  String value => rs_json.ShalomJsonValue.string(value),
  List<Object?> value => rs_json.ShalomJsonValue.array(
    value.map(shalomJsonValue).toList(growable: false),
  ),
  Map<Object?, Object?> value => rs_json.ShalomJsonValue.object(
    value.map((key, value) {
      if (key is! String) {
        throw ArgumentError.value(
          key,
          'key',
          'JSON object keys must be strings',
        );
      }
      return MapEntry(key, shalomJsonValue(value));
    }),
  ),
  _ => throw ArgumentError.value(value, 'value', 'Not a JSON value'),
};

ShalomJsonValue shalomJsonObject(Map<String, ShalomJsonValue> fields) =>
    rs_json.ShalomJsonValue.object(fields);

ShalomJsonValue shalomJsonArray(Iterable<ShalomJsonValue> values) =>
    rs_json.ShalomJsonValue.array(values.toList(growable: false));

extension ShalomJsonValueAccess on ShalomJsonValue {
  bool get isNull => this is rs_json.ShalomJsonValue_Null;

  ShalomJsonValue? field(String name) => switch (this) {
    rs_json.ShalomJsonValue_Object(:final field0) => field0[name],
    _ => throw const FormatException('Expected a JSON object'),
  };

  List<ShalomJsonValue> get listValue => switch (this) {
    rs_json.ShalomJsonValue_Array(:final field0) => field0,
    _ => throw const FormatException('Expected a JSON array'),
  };

  String get stringValue => switch (this) {
    rs_json.ShalomJsonValue_String(:final field0) => field0,
    _ => throw const FormatException('Expected a JSON string'),
  };

  bool get boolValue => switch (this) {
    rs_json.ShalomJsonValue_Boolean(:final field0) => field0,
    _ => throw const FormatException('Expected a JSON boolean'),
  };

  int get intValue => switch (this) {
    rs_json.ShalomJsonValue_Integer(:final field0) => field0.toInt(),
    _ => throw const FormatException('Expected a JSON integer'),
  };

  double get doubleValue => switch (this) {
    rs_json.ShalomJsonValue_Float(:final field0) => field0,
    rs_json.ShalomJsonValue_Integer() => intValue.toDouble(),
    _ => throw const FormatException('Expected a JSON number'),
  };

  Object? toJsonValue() => switch (this) {
    rs_json.ShalomJsonValue_Null() => null,
    rs_json.ShalomJsonValue_Boolean(:final field0) => field0,
    rs_json.ShalomJsonValue_Integer() => intValue,
    rs_json.ShalomJsonValue_Float(:final field0) => field0,
    rs_json.ShalomJsonValue_String(:final field0) => field0,
    rs_json.ShalomJsonValue_Array(:final field0) =>
      field0.map((value) => value.toJsonValue()).toList(growable: false),
    rs_json.ShalomJsonValue_Object(:final field0) => field0.map(
      (key, value) => MapEntry(key, value.toJsonValue()),
    ),
  };
}

abstract interface class OperationInterface {
  String operation$Name();
  JsonObject toJson();
  ShalomJsonValue toShalomValue();
}

/// Marker for operation/fragment data types that can be safely observed
/// through a long-lived reactive [Stream] subscription ([ShalomRuntimeClient.request],
/// [ShalomRuntimeClient.subscribeToFragment]).
///
/// Mutation response types are intentionally excluded: routing a mutation
/// through the reactive subscription registry lets an unrelated concurrent
/// cache write resolve it with stale data before its own network response
/// arrives. See [MutationInterface] and [ShalomRuntimeClient.mutate], which
/// executes a mutation directly instead.
abstract interface class StreamCompat {}

/// Marker for mutation response types, used with [ShalomRuntimeClient.mutate]
/// and [ShalomRuntimeClient.writeOptimistic]. Deliberately does *not*
/// implement [StreamCompat] — see its doc comment for why.
abstract interface class MutationInterface extends OperationInterface {}

abstract interface class FragmentInterface implements StreamCompat {
  String fragment$Name();

  String entity$Type();

  /// The normalized cache id of this fragment's root entity (the value of
  /// its selected `id` field). Combined with [entity$Type] this gives the
  /// cache key `'$entity$Type:$entity$Id'`.
  String entity$Id();

  JsonObject toJson();
  ShalomJsonValue toShalomValue();
}

// ignore: constant_identifier_names
enum OperationType { Query, Mutation, Subscription }

class Request {
  final String query;
  final JsonObject variables;
  final OperationType opType;
  final String opName;

  Request({
    required this.query,
    required this.variables,
    required this.opType,
    required this.opName,
  });
  JsonObject toJson() {
    return {"query": query, "variables": variables, "operationName": opName};
  }
}

class RequestMeta<T> {
  final Request request;
  final T Function(JsonObject data) parseFn;
  const RequestMeta({required this.request, required this.parseFn});
}

class Response {
  final JsonObject data;
  final String opName;

  Response({required this.data, required this.opName});

  JsonObject toJson() {
    return {"data": data, "operationName": opName};
  }
}

abstract class Requestable<T> {
  const Requestable();
  RequestMeta<T> getRequestMeta();
  Request toRequest() => getRequestMeta().request;
}

sealed class Maybe<T> {
  T? some();
  bool isSome();
  void inspect(void Function(T) _);
}

class None<T> implements Maybe<T> {
  const None();

  @override
  T? some() => null;

  @override
  bool isSome() => false;

  @override
  void inspect(void Function(T) _) {}

  @override
  bool operator ==(Object other) {
    return other is None<T>;
  }

  @override
  String toString() => "None";

  @override
  int get hashCode => runtimeType.hashCode;
}

class Some<T> implements Maybe<T> {
  final T value;

  const Some(this.value);

  @override
  T? some() => value;

  @override
  bool isSome() => true;

  @override
  void inspect(void Function(T) fn) => fn(value);

  @override
  bool operator ==(Object other) {
    if (other is Some<T>) {
      return value == other.value;
    }
    return false;
  }

  @override
  String toString() => "Some(${value.toString()})";
  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}

class OperationContext<TVars> {
  final TVars? variables;

  const OperationContext({this.variables});
}

class ShalomTransportException implements Exception {
  final String message;
  final String code;
  final JsonObject? details;

  const ShalomTransportException({
    required this.message,
    required this.code,
    this.details,
  });

  @override
  String toString() {
    return 'ShalomTransportException: $message (code: $code)';
  }
}

sealed class GraphQLResponse<T> {
  const GraphQLResponse();
}

class LinkExceptionResponse<T> extends GraphQLResponse<T> {
  final List<Exception> errors;
  const LinkExceptionResponse(this.errors);
}

class GraphQLData<T> extends GraphQLResponse<T> {
  final T data;
  final List<JsonObject>? errors;
  final JsonObject? extensions;

  const GraphQLData({required this.data, this.errors, this.extensions});
}

class GraphQLError<T> extends GraphQLResponse<T> {
  final List<JsonObject> errors;
  final JsonObject? extensions;

  const GraphQLError({required this.errors, this.extensions});
}
