import '../shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GraphQLResult<T> {
  final T? data;
  final List<List<JsonObject>>? errors;

  GraphQLResult._({this.data, this.errors});

  factory GraphQLResult.fromJson(
    JsonObject json,
    T Function(JsonObject) fromJson,
  ) {
    return GraphQLResult._(
      data: json['data'] != null ? fromJson(json['data']) : null,
      errors:
          json['errors'] != null
              ? (json['errors'] as List)
                  .map((e) => (e as List).map((e) => e as JsonObject).toList())
                  .toList()
              : null,
    );
  }
}

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

class Response {
  final JsonObject data;
  final String opName;

  Response({required this.data, required this.opName});

  JsonObject toJson() {
    return {"data": data, "operationName": opName};
  }
}

abstract class Requestable {
  Request toRequest();
}

sealed class Option<T> {
  T? some();
  bool isSome();
  void inspect(void Function(T));
}

class None<T> implements Option<T> {
  const None();

  @override
  T? some() => null;

  @override
  bool isSome() => false;

  @override
  void inspect(void Function(T) _) => null;

  @override
  bool operator ==(Object other) {
    return other is None<T>;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class Some<T> implements Option<T> {
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
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}

class OperationContext<TVars> {
  final TVars? variables;
  final ShalomCtx shalomCtx;
  const OperationContext({this.variables, required this.shalomCtx});
}
