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
  final String StringopName;

  Request({
    required this.query,
    required this.variables,
    required this.opType,
    required this.StringopName,
  });

  JsonObject toJson() {
    return {
      "query": query,
      "variables": variables,
      "operationName": StringopName,
    };
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
  T? some() => null;
  isSome() => false;
  inspect(void Function(T)) => null;
}

class Some<T> implements Option<T> {
  final T value;

  const Some(this.value);

  T? some() => value;
  isSome() => true;
  inspect(void Function(T) fn) => fn(value);
}
