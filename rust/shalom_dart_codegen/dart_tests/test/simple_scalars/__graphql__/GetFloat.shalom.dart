// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatResponse {
  /// class members

  final double float;

  // keywordargs constructor
  GetFloatResponse({required this.float});

  static (GetFloatResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final double float$value;
    // TODO: handle arguments
    final floatNormalized$Key = "float";

    final float$raw = data["float"];

    float$value = float$raw as double;
    current$NormalizedRecord[floatNormalized$Key] = float$raw;

    return (GetFloatResponse(float: float$value), current$NormalizedRecord);
  }

  static GetFloatResponse fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatResponse && other.float == float);
  }

  @override
  int get hashCode => float.hashCode;

  JsonObject toJson() {
    return {'float': this.float};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetFloat {
  /// class members

  final double float;

  // keywordargs constructor
  GetFloat({required this.float});

  static (GetFloat, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final double float$value;
    // TODO: handle arguments
    final floatNormalized$Key = "float";

    final float$raw = data["float"];

    float$value = float$raw as double;
    current$NormalizedRecord[floatNormalized$Key] = float$raw;

    return (GetFloat(float: float$value), current$NormalizedRecord);
  }

  static GetFloat fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloat && other.float == float);
  }

  @override
  int get hashCode => float.hashCode;

  JsonObject toJson() {
    return {'float': this.float};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloat extends Requestable {
  RequestGetFloat();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloat {
  float
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetFloat',
    );
  }
}
