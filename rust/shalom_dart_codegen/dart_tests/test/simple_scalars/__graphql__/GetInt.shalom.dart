// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntResponse {
  /// class members

  final int intField;

  // keywordargs constructor
  GetIntResponse({required this.intField});

  static (GetIntResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final int intField$value;
    // TODO: handle arguments
    final intFieldNormalized$Key = "intField";

    final intField$raw = data["intField"];

    intField$value = intField$raw as int;
    current$NormalizedRecord[intFieldNormalized$Key] = intField$raw;

    return (GetIntResponse(intField: intField$value), current$NormalizedRecord);
  }

  static GetIntResponse fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntResponse && other.intField == intField);
  }

  @override
  int get hashCode => intField.hashCode;

  JsonObject toJson() {
    return {'intField': this.intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetInt {
  /// class members

  final int intField;

  // keywordargs constructor
  GetInt({required this.intField});

  static (GetInt, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final int intField$value;
    // TODO: handle arguments
    final intFieldNormalized$Key = "intField";

    final intField$raw = data["intField"];

    intField$value = intField$raw as int;
    current$NormalizedRecord[intFieldNormalized$Key] = intField$raw;

    return (GetInt(intField: intField$value), current$NormalizedRecord);
  }

  static GetInt fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetInt && other.intField == intField);
  }

  @override
  int get hashCode => intField.hashCode;

  JsonObject toJson() {
    return {'intField': this.intField};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetInt extends Requestable {
  RequestGetInt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetInt {
  intField
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetInt',
    );
  }
}
