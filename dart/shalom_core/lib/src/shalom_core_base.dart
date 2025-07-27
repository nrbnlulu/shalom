typedef JsonObject = Map<String, dynamic>;

extension JsonMapComparison on JsonObject {
  bool deepEquals(JsonObject? other) {
    if (other == null) {
      return false;
    }

    if (length != other.length) {
      return false;
    }

    for (final key in keys) {
      if (!other.containsKey(key)) {
        return false;
      }

      final dynamic thisValue = this[key];
      final dynamic otherValue = other[key];

      if (thisValue is Map<String, dynamic> &&
          otherValue is Map<String, dynamic>) {
        if (!thisValue.deepEquals(otherValue)) {
          return false;
        }
      } else if (thisValue is List && otherValue is List) {
        if (!_deepListEquals(thisValue, otherValue)) {
          return false;
        }
      } else if (thisValue != otherValue) {
        return false;
      }
    }

    return true;
  }

  bool _deepListEquals(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      final dynamic item1 = list1[i];
      final dynamic item2 = list2[i];

      if (item1 is JsonObject && item2 is JsonObject) {
        if (!item1.deepEquals(item2)) {
          return false;
        }
      } else if (item1 is List && item2 is List) {
        if (!_deepListEquals(item1, item2)) {
          return false;
        }
      } else if (item1 != item2) {
        return false;
      }
    }

    return true;
  }
}

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
