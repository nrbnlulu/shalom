import 'normelized_cache.dart' show RecordID;

import 'shalom_ctx.dart' show ShalomCtx;

typedef JsonObject = Map<String, dynamic>;

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

  /// if success returns the deserialized data + set of cache keys to subscribe to
  final (T, Set<RecordID>) Function({
    required JsonObject data,
    required ShalomCtx ctx,
  }) loadFn;
  final (T, Set<RecordID>) Function(ShalomCtx ctx) fromCacheFn;
  const RequestMeta({
    required this.request,
    required this.loadFn,
    required this.fromCacheFn,
  });
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
  final ShalomCtx shalomCtx;
  const OperationContext({this.variables, required this.shalomCtx});
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
