// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntOptionalResponse {
  /// class members

  final int? intOptional;

  // keywordargs constructor
  GetIntOptionalResponse({this.intOptional});

  static (GetIntOptionalResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final int? intOptional$value;
    // TODO: handle arguments
    final intOptionalNormalized$Key = "intOptional";

    final intOptional$raw = data["intOptional"];

    intOptional$value = intOptional$raw as int?;
    current$NormalizedRecord[intOptionalNormalized$Key] = intOptional$raw;

    return (
      GetIntOptionalResponse(intOptional: intOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetIntOptionalResponse fromJson(JsonObject data) =>
      fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntOptionalResponse && other.intOptional == intOptional);
  }

  @override
  int get hashCode => intOptional.hashCode;

  JsonObject toJson() {
    return {'intOptional': this.intOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetIntOptional {
  /// class members

  final int? intOptional;

  // keywordargs constructor
  GetIntOptional({this.intOptional});

  static (GetIntOptional, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final NormalizedRecordData current$NormalizedRecord = {};

    final int? intOptional$value;
    // TODO: handle arguments
    final intOptionalNormalized$Key = "intOptional";

    final intOptional$raw = data["intOptional"];

    intOptional$value = intOptional$raw as int?;
    current$NormalizedRecord[intOptionalNormalized$Key] = intOptional$raw;

    return (
      GetIntOptional(intOptional: intOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetIntOptional fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntOptional && other.intOptional == intOptional);
  }

  @override
  int get hashCode => intOptional.hashCode;

  JsonObject toJson() {
    return {'intOptional': this.intOptional};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIntOptional extends Requestable {
  RequestGetIntOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIntOptional {
  intOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetIntOptional',
    );
  }
}
