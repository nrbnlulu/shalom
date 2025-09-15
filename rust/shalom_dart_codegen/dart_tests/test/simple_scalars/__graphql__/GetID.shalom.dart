// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDResponse {
  /// class members

  final String id;

  // keywordargs constructor
  GetIDResponse({required this.id});

  static (GetIDResponse, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final normalized$ID = data["id"] as RecordID?;
    if (normalized$ID != null) {
      ctx?.addReachableRecord("Query:${normalized$ID}");
    }

    final NormalizedRecordData current$NormalizedRecord = {};

    final String id$value;
    // TODO: handle arguments
    final idNormalized$Key = "id";

    final id$raw = data["id"];

    id$value = id$raw as String;
    current$NormalizedRecord[idNormalized$Key] = id$raw;

    return (GetIDResponse(id: id$value), current$NormalizedRecord);
  }

  static GetIDResponse fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is GetIDResponse && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;

  JsonObject toJson() {
    return {'id': this.id};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetID {
  /// class members

  final String id;

  // keywordargs constructor
  GetID({required this.id});

  static (GetID, NormalizedRecordData) fromJsonImpl(
    JsonObject data, {
    CacheUpdateContext? ctx,
  }) {
    final NormalizedRecordData record$Data = {};
    // define the object fields

    final normalized$ID = data["id"] as RecordID?;
    if (normalized$ID != null) {
      ctx?.addReachableRecord("Query:${normalized$ID}");
    }

    final NormalizedRecordData current$NormalizedRecord = {};

    final String id$value;
    // TODO: handle arguments
    final idNormalized$Key = "id";

    final id$raw = data["id"];

    id$value = id$raw as String;
    current$NormalizedRecord[idNormalized$Key] = id$raw;

    return (GetID(id: id$value), current$NormalizedRecord);
  }

  static GetID fromJson(JsonObject data) => fromJsonImpl(data).$1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is GetID && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;

  JsonObject toJson() {
    return {'id': this.id};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetID extends Requestable {
  RequestGetID();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetID {
  id
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetID',
    );
  }
}
