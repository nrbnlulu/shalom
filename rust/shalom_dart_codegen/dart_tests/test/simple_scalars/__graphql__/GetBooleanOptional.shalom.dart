// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetBooleanOptionalResponse {
  /// class members

  final bool? booleanOptional;

  // keywordargs constructor
  GetBooleanOptionalResponse({this.booleanOptional});

  static (GetBooleanOptionalResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final bool? booleanOptional$value;
    // TODO: handle arguments
    final booleanOptionalNormalized$Key = "booleanOptional";

    final booleanOptional$raw = data["booleanOptional"];

    booleanOptional$value = booleanOptional$raw as bool?;
    current$NormalizedRecord[booleanOptionalNormalized$Key] =
        booleanOptional$raw;

    return (
      GetBooleanOptionalResponse(booleanOptional: booleanOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetBooleanOptionalResponse fromJson(JsonObject data) =>
      fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetBooleanOptionalResponse &&
            other.booleanOptional == booleanOptional);
  }

  @override
  int get hashCode => booleanOptional.hashCode;

  JsonObject toJson() {
    return {'booleanOptional': this.booleanOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetBooleanOptional {
  /// class members

  final bool? booleanOptional;

  // keywordargs constructor
  GetBooleanOptional({this.booleanOptional});

  static (GetBooleanOptional, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final bool? booleanOptional$value;
    // TODO: handle arguments
    final booleanOptionalNormalized$Key = "booleanOptional";

    final booleanOptional$raw = data["booleanOptional"];

    booleanOptional$value = booleanOptional$raw as bool?;
    current$NormalizedRecord[booleanOptionalNormalized$Key] =
        booleanOptional$raw;

    return (
      GetBooleanOptional(booleanOptional: booleanOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetBooleanOptional fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetBooleanOptional &&
            other.booleanOptional == booleanOptional);
  }

  @override
  int get hashCode => booleanOptional.hashCode;

  JsonObject toJson() {
    return {'booleanOptional': this.booleanOptional};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBooleanOptional extends Requestable {
  RequestGetBooleanOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetBooleanOptional {
  booleanOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetBooleanOptional',
    );
  }
}
