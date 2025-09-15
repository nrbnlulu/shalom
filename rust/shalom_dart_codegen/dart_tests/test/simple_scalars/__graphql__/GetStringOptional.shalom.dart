// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringOptionalResponse {
  /// class members

  final String? stringOptional;

  // keywordargs constructor
  GetStringOptionalResponse({this.stringOptional});

  static (GetStringOptionalResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    DeserializationContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final String? stringOptional$value;
    // TODO: handle arguments
    final stringOptionalNormalized$Key = "stringOptional";

    final stringOptional$raw = data["stringOptional"];

    stringOptional$value = stringOptional$raw as String?;
    current$NormalizedRecord[stringOptionalNormalized$Key] = stringOptional$raw;

    return (
      GetStringOptionalResponse(stringOptional: stringOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetStringOptionalResponse fromJson(JsonObject data) =>
      fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringOptionalResponse &&
            other.stringOptional == stringOptional);
  }

  @override
  int get hashCode => stringOptional.hashCode;

  JsonObject toJson() {
    return {'stringOptional': this.stringOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetStringOptional {
  /// class members

  final String? stringOptional;

  // keywordargs constructor
  GetStringOptional({this.stringOptional});

  static (GetStringOptional, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    DeserializationContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final String? stringOptional$value;
    // TODO: handle arguments
    final stringOptionalNormalized$Key = "stringOptional";

    final stringOptional$raw = data["stringOptional"];

    stringOptional$value = stringOptional$raw as String?;
    current$NormalizedRecord[stringOptionalNormalized$Key] = stringOptional$raw;

    return (
      GetStringOptional(stringOptional: stringOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetStringOptional fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringOptional && other.stringOptional == stringOptional);
  }

  @override
  int get hashCode => stringOptional.hashCode;

  JsonObject toJson() {
    return {'stringOptional': this.stringOptional};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetStringOptional extends Requestable {
  RequestGetStringOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetStringOptional {
  stringOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetStringOptional',
    );
  }
}
