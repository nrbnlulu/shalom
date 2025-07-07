// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetMultipleFieldsResponse {
  /// class members

  final String id;

  final int intField;

  // keywordargs constructor
  GetMultipleFieldsResponse({required this.id, required this.intField});
  static GetMultipleFieldsResponse fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final int intField_value;

    intField_value = data['intField'];

    return GetMultipleFieldsResponse(id: id_value, intField: intField_value);
  }

  GetMultipleFieldsResponse updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'];
    } else {
      intField_value = intField;
    }

    return GetMultipleFieldsResponse(id: id_value, intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetMultipleFieldsResponse &&
            other.id == id &&
            other.intField == intField);
  }

  @override
  int get hashCode => Object.hashAll([id, intField]);

  JsonObject toJson() {
    return {'id': id, 'intField': intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetMultipleFields extends Requestable {
  RequestGetMultipleFields();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetMultipleFields {
  id
  intField
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetMultipleFields',
    );
  }
}
