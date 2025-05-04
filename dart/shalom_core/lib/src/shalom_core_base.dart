typedef JsonObject = Map<String, dynamic>;

class GraphQLResult<T> {
  final T? data;
  final List<List<JsonObject>>? errors;

  GraphQLResult._({this.data, this.errors});

  factory GraphQLResult.fromJson(JsonObject json, T Function(JsonObject) fromJson) {
    return GraphQLResult._(
        data: json['data'] != null ? fromJson(json['data']) : null,
        errors: json['errors'] != null
            ? (json['errors'] as List)
                .map((e) => (e as List).map((e) => e as JsonObject).toList())
                .toList()
            : null);
  }
}

enum OperationType {
    Query,
    Mutation,
    Subscription
}

class Request {
    final String query;
    final JsonObject variables;
    final OperationType opType;
    final String StringopName;

    Request ({
        required this.query,
        required this.variables,
        required this.opType,
        required this.StringopName
    });

    JsonObject toJson() {
      return {
          "query": query,
          "variables": variables,
          "op": StringopName 
      };
    }
    
}

class Response {
    final JsonObject data;
    final String opName;

    Response({
        required this.data,
        required this.opName
    });

    JsonObject toJson() {
      return {
        "data": data,
        "opName": opName
      };
    }
} 


abstract class Requestable {
    Request toRequest();
}

