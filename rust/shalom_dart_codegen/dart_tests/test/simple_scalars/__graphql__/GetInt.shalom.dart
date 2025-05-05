import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetIntResponse {
  /// class members

  final int intField;

  // keywordargs constructor
  GetIntResponse({required this.intField});
  static GetIntResponse fromJson(JsonObject data) {
    final int intField_value = data['intField'];

    return GetIntResponse(intField: intField_value);
  }

  GetIntResponse updateWithJson(JsonObject data) {
    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'];
    } else {
      intField_value = intField;
    }

    return GetIntResponse(intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntResponse && other.intField == intField);
  }

  @override
  int get hashCode => intField.hashCode;

  JsonObject toJson() {
    return {'intField': intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetInt extends Requestable {
  final GetIntResponse operation;
  final GetIntVariables variables;

  RequestGetInt({required this.operation, required this.variables});

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
    String queryString = "query GetInt($variablesString) $selectionString";
    return queryString;
  }

  @override
  Request toRequest() {
    return Request(
      query: queryString(),
      variables: variables.toJson(),
      opType: OperationType.Query,
      StringopName: 'GetInt',
    );
  }
}

class GetIntVariables {
  GetIntVariables();

  JsonObject toTypes() {
    return {};
  }

  JsonObject toJson() {
    return {};
  }
}
