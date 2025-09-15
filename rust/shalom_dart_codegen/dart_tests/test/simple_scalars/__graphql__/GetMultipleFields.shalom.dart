// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetMultipleFieldsResponse {
  /// class members

  final String id;

  final int intField;

  // keywordargs constructor
  GetMultipleFieldsResponse({required this.id, required this.intField});

  static (GetMultipleFieldsResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    DeserializationContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final normalized$ID = data["id"] as RecordID?;
    if (normalized$ID != null) {
      ctx?.addReachableRecord("Query:${normalized$ID}");
    }

    final NormalizedRecordData current$NormalizedRecord = {};

    final String id$value;

    final int intField$value;
    // TODO: handle arguments
    final idNormalized$Key = "id";

    final id$raw = data["id"];

    id$value = id$raw as String;
    current$NormalizedRecord[idNormalized$Key] = id$raw;

    // TODO: handle arguments
    final intFieldNormalized$Key = "intField";

    final intField$raw = data["intField"];

    intField$value = intField$raw as int;
    current$NormalizedRecord[intFieldNormalized$Key] = intField$raw;

    return (
      GetMultipleFieldsResponse(id: id$value, intField: intField$value),
      current$NormalizedRecord,
    );
  }

  static GetMultipleFieldsResponse fromJson(JsonObject data) =>
      fromJsonImpl(data).$1;

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

class GetMultipleFields {
  /// class members

  final String id;

  final int intField;

  // keywordargs constructor
  GetMultipleFields({required this.id, required this.intField});

  static (GetMultipleFields, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    DeserializationContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final normalized$ID = data["id"] as RecordID?;
    if (normalized$ID != null) {
      ctx?.addReachableRecord("Query:${normalized$ID}");
    }

    final NormalizedRecordData current$NormalizedRecord = {};

    final String id$value;

    final int intField$value;
    // TODO: handle arguments
    final idNormalized$Key = "id";

    final id$raw = data["id"];

    id$value = id$raw as String;
    current$NormalizedRecord[idNormalized$Key] = id$raw;

    // TODO: handle arguments
    final intFieldNormalized$Key = "intField";

    final intField$raw = data["intField"];

    intField$value = intField$raw as int;
    current$NormalizedRecord[intFieldNormalized$Key] = intField$raw;

    return (
      GetMultipleFields(id: id$value, intField: intField$value),
      current$NormalizedRecord,
    );
  }

  static GetMultipleFields fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetMultipleFields &&
            other.id == id &&
            other.intField == intField);
  }

  @override
  int get hashCode => Object.hashAll([id, intField]);

  JsonObject toJson() {
    return {'id': this.id, 'intField': this.intField};
  }
}

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
