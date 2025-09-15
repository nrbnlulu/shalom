// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDOptionalResponse {
  /// class members

  final String? idOptional;

  // keywordargs constructor
  GetIDOptionalResponse({this.idOptional});

  static (GetIDOptionalResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final normalized$ID = data["idOptional"] as RecordID?;
    if (normalized$ID != null) {
      ctx?.addReachableRecord("Query:${normalized$ID}");
    }

    final NormalizedRecordData current$NormalizedRecord = {};

    final String? idOptional$value;
    // TODO: handle arguments
    final idOptionalNormalized$Key = "idOptional";

    final idOptional$raw = data["idOptional"];

    idOptional$value = idOptional$raw as String?;
    current$NormalizedRecord[idOptionalNormalized$Key] = idOptional$raw;

    return (
      GetIDOptionalResponse(idOptional: idOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetIDOptionalResponse fromJson(JsonObject data) =>
      fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIDOptionalResponse && other.idOptional == idOptional);
  }

  @override
  int get hashCode => idOptional.hashCode;

  JsonObject toJson() {
    return {'idOptional': this.idOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetIDOptional {
  /// class members

  final String? idOptional;

  // keywordargs constructor
  GetIDOptional({this.idOptional});

  static (GetIDOptional, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final normalized$ID = data["idOptional"] as RecordID?;
    if (normalized$ID != null) {
      ctx?.addReachableRecord("Query:${normalized$ID}");
    }

    final NormalizedRecordData current$NormalizedRecord = {};

    final String? idOptional$value;
    // TODO: handle arguments
    final idOptionalNormalized$Key = "idOptional";

    final idOptional$raw = data["idOptional"];

    idOptional$value = idOptional$raw as String?;
    current$NormalizedRecord[idOptionalNormalized$Key] = idOptional$raw;

    return (
      GetIDOptional(idOptional: idOptional$value),
      current$NormalizedRecord,
    );
  }

  static GetIDOptional fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIDOptional && other.idOptional == idOptional);
  }

  @override
  int get hashCode => idOptional.hashCode;

  JsonObject toJson() {
    return {'idOptional': this.idOptional};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIDOptional extends Requestable {
  RequestGetIDOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIDOptional {
  idOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetIDOptional',
    );
  }
}
