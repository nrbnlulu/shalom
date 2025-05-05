import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetFloatOptionalResponse {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptionalResponse({this.floatOptional});
  static GetFloatOptionalResponse fromJson(JsonObject data) {
    final double? floatOptional_value = data['floatOptional'];

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  GetFloatOptionalResponse updateWithJson(JsonObject data) {
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
      floatOptional_value = data['floatOptional'];
    } else {
      floatOptional_value = floatOptional;
    }

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptionalResponse &&
            other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
  final GetFloatOptionalResponse operation;
  final GetFloatOptionalVariables variables;

  RequestGetFloatOptional({required this.operation, required this.variables});

  String selectionsJsonToQuery(JsonObject selection) {
    List<String> selectionItems = [];
    for (var entry in selection.entries) {
      if (entry.value is JsonObject) {
        String subSelections = selectionsJsonToQuery(entry.value);
        selectionItems.add("${entry.key} $subSelections");
      } else {
        selectionItems.add(entry.key);
      }
    }
    String selectionItemsString = selectionItems.join(" ");
    return "{$selectionItemsString}";
  }

  String queryString() {
    String selectionString = selectionsJsonToQuery(operation.toJson());
    String variablesString = variables
        .toTypes()
        .entries
        .map((entry) => '\$${entry.key}: ${entry.value}')
        .join(", ");
    String queryString =
        "query GetFloatOptional($variablesString) $selectionString";
    return queryString;
  }

  @override
  Request toRequest() {
    return Request(
      query: queryString(),
      variables: variables.toJson(),
      opType: OperationType.Query,
      StringopName: 'GetFloatOptional',
    );
  }
}

class GetFloatOptionalVariables {
  GetFloatOptionalVariables();

  JsonObject toTypes() {
    return {};
  }

  JsonObject toJson() {
    return {};
  }
}
