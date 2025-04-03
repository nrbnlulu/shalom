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
