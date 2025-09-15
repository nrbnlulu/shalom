// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetBooleanResponse {
  /// class members

  final bool boolean;

  // keywordargs constructor
  GetBooleanResponse({required this.boolean});

  static (GetBooleanResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    DeserializationContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final bool boolean$value;
    // TODO: handle arguments
    final booleanNormalized$Key = "boolean";

    final boolean$raw = data["boolean"];

    boolean$value = boolean$raw as bool;
    current$NormalizedRecord[booleanNormalized$Key] = boolean$raw;

    return (
      GetBooleanResponse(boolean: boolean$value),
      current$NormalizedRecord,
    );
  }

  static GetBooleanResponse fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetBooleanResponse && other.boolean == boolean);
  }

  @override
  int get hashCode => boolean.hashCode;

  JsonObject toJson() {
    return {'boolean': this.boolean};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetBoolean {
  /// class members

  final bool boolean;

  // keywordargs constructor
  GetBoolean({required this.boolean});

  static (GetBoolean, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    DeserializationContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final bool boolean$value;
    // TODO: handle arguments
    final booleanNormalized$Key = "boolean";

    final boolean$raw = data["boolean"];

    boolean$value = boolean$raw as bool;
    current$NormalizedRecord[booleanNormalized$Key] = boolean$raw;

    return (GetBoolean(boolean: boolean$value), current$NormalizedRecord);
  }

  static GetBoolean fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetBoolean && other.boolean == boolean);
  }

  @override
  int get hashCode => boolean.hashCode;

  JsonObject toJson() {
    return {'boolean': this.boolean};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBoolean extends Requestable {
  RequestGetBoolean();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetBoolean {
  boolean
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetBoolean',
    );
  }
}
