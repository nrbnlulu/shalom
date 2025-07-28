// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetMultipleFieldsResponse {
  /// class members

  String id;

  int intField;

  // keywordargs constructor
  GetMultipleFieldsResponse({required this.id, required this.intField});
  static GetMultipleFieldsResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final int intField_value;
    final intField$raw = data["intField"];
    intField_value = intField$raw as int;

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
    return {'id': this.id, 'intField': this.intField};
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
      opName: 'GetMultipleFields',
    );
  }
}
