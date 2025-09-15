// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringResponse {
  /// class members

  final String string;

  // keywordargs constructor
  GetStringResponse({required this.string});

  static (GetStringResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final String string$value;
    // TODO: handle arguments
    final stringNormalized$Key = "string";

    final string$raw = data["string"];

    string$value = string$raw as String;
    current$NormalizedRecord[stringNormalized$Key] = string$raw;

    return (GetStringResponse(string: string$value), current$NormalizedRecord);
  }

  static GetStringResponse fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringResponse && other.string == string);
  }

  @override
  int get hashCode => string.hashCode;

  JsonObject toJson() {
    return {'string': this.string};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetString {
  /// class members

  final String string;

  // keywordargs constructor
  GetString({required this.string});

  static (GetString, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final String string$value;
    // TODO: handle arguments
    final stringNormalized$Key = "string";

    final string$raw = data["string"];

    string$value = string$raw as String;
    current$NormalizedRecord[stringNormalized$Key] = string$raw;

    return (GetString(string: string$value), current$NormalizedRecord);
  }

  static GetString fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetString && other.string == string);
  }

  @override
  int get hashCode => string.hashCode;

  JsonObject toJson() {
    return {'string': this.string};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetString extends Requestable {
  RequestGetString();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetString {
  string
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetString',
    );
  }
}
