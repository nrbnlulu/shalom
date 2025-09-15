// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatOptionalResponse {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptionalResponse({this.floatOptional});

  static (GetFloatOptionalResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final double? floatOptional$value;
    // TODO: handle arguments
    final floatOptionalNormalized$Key = "floatOptional";

    final floatOptional$raw = data["floatOptional"];

    floatOptional$value = floatOptional$raw as double?;
    current$NormalizedRecord[floatOptionalNormalized$Key] = floatOptional$raw;

    return (
      GetFloatOptionalResponse(floatOptional: floatOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetFloatOptionalResponse fromJson(JsonObject data) =>
      fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptionalResponse &&
            other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': this.floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetFloatOptional {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptional({this.floatOptional});

  static (GetFloatOptional, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final double? floatOptional$value;
    // TODO: handle arguments
    final floatOptionalNormalized$Key = "floatOptional";

    final floatOptional$raw = data["floatOptional"];

    floatOptional$value = floatOptional$raw as double?;
    current$NormalizedRecord[floatOptionalNormalized$Key] = floatOptional$raw;

    return (
      GetFloatOptional(floatOptional: floatOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetFloatOptional fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptional && other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': this.floatOptional};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
  RequestGetFloatOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatOptional {
  floatOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetFloatOptional',
    );
  }
}
