// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetMultipleFieldsResponse {
  /// class members

  final String id;

  final int intField;

  // keywordargs constructor
  GetMultipleFieldsResponse({required this.id, required this.intField});

  static void normalize$inCache(JsonObject data, CacheUpdateContext ctx) {
    // TODO: arguments
    final RecordID this$fieldName = "GetMultipleFields";
    final JsonObject parent$record = ctx.getOrCreateCachedObjectRecord(
      "ROOT_QUERY",
    );
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    this$normalizedID = this$fieldName;

    this$NormalizedRecord = parent$record;
    // TODO: handle arguments
    final idNormalized$Key = "id";
    final id$cached = this$NormalizedRecord[idNormalized$Key];
    final id$raw = data["id"];
    if (id$raw != null) {
      if (id$cached != id$raw) {}
      this$NormalizedRecord[idNormalized$Key] = id$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("id") && id$cached != null) {
        this$NormalizedRecord[idNormalized$Key] = null;
      }
    }

    // TODO: handle arguments
    final intFieldNormalized$Key = "intField";
    final intField$cached = this$NormalizedRecord[intFieldNormalized$Key];
    final intField$raw = data["intField"];
    if (intField$raw != null) {
      if (intField$cached != intField$raw) {}
      this$NormalizedRecord[intFieldNormalized$Key] = intField$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("intField") && intField$cached != null) {
        this$NormalizedRecord[intFieldNormalized$Key] = null;
      }
    }
  }

  static GetMultipleFieldsResponse fromJsonImpl(
    NormalizedRecordData data,
    ShalomCtx ctx,
  ) {
    final id$raw = data["id"];
    final String id$value = id$raw as String;

    final intField$raw = data["intField"];
    final int intField$value = intField$raw as int;
    return GetMultipleFieldsResponse(id: id$value, intField: intField$value);
  }

  static GetMultipleFieldsResponse fromJson(JsonObject data, {ShalomCtx? ctx}) {
    // if ctx not provider we create dummy one
    ctx ??= ShalomCtx.withCapacity();
    // first update the cache
    final CacheUpdateContext updateCtx = CacheUpdateContext(
      shalomContext: ctx!,
    );
    // TODO: handle arguments
    final normalizedRecord = updateCtx.getOrCreateCachedObjectRecord(
      "ROOT_QUERY",
    );
    normalize$inCache(data, updateCtx);
    return fromJsonImpl(normalizedRecord, ctx);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetMultipleFieldsResponse &&
            other.id == id &&
            other.intField == intField);
  }

  @override
  int get hashCode => Object.hashAll([id, intField]);

  JsonObject toJson() {
    return {'id': this.id, 'intField': this.intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetMultipleFields {
  /// class members

  final String id;

  final int intField;

  // keywordargs constructor
  GetMultipleFields({required this.id, required this.intField});

  static void normalize$inCache(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject parent$record,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;
    final RecordID? this$normalizedID_temp = data["id"] as RecordID?;
    if (this$normalizedID_temp == null) {
      throw UnimplementedError("Required ID cannot be null");
    } else {
      this$normalizedID = this$normalizedID_temp!;
      parent$record[this$fieldName] = this$normalizedID;
      ctx.addDependantRecord(this$normalizedID);
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
    }
    // TODO: handle arguments
    final idNormalized$Key = "id";
    final id$cached = this$NormalizedRecord[idNormalized$Key];
    final id$raw = data["id"];
    if (id$raw != null) {
      if (id$cached != id$raw) {
        ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
      }
      this$NormalizedRecord[idNormalized$Key] = id$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("id") && id$cached != null) {
        this$NormalizedRecord[idNormalized$Key] = null;

        ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
      }
    }

    // TODO: handle arguments
    final intFieldNormalized$Key = "intField";
    final intField$cached = this$NormalizedRecord[intFieldNormalized$Key];
    final intField$raw = data["intField"];
    if (intField$raw != null) {
      if (intField$cached != intField$raw) {
        ctx.addChangedRecord(this$normalizedID, intFieldNormalized$Key);
      }
      this$NormalizedRecord[intFieldNormalized$Key] = intField$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("intField") && intField$cached != null) {
        this$NormalizedRecord[intFieldNormalized$Key] = null;

        ctx.addChangedRecord(this$normalizedID, intFieldNormalized$Key);
      }
    }
  }

  static GetMultipleFields fromJsonImpl(
    NormalizedRecordData data,
    ShalomCtx ctx,
  ) {
    final id$raw = data["id"];
    final String id$value = id$raw as String;

    final intField$raw = data["intField"];
    final int intField$value = intField$raw as int;
    return GetMultipleFields(id: id$value, intField: intField$value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetMultipleFields &&
            other.id == id &&
            other.intField == intField);
  }

  @override
  int get hashCode => Object.hashAll([id, intField]);

  JsonObject toJson() {
    return {'id': this.id, 'intField': this.intField};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetMultipleFields extends Requestable {
  RequestGetMultipleFields();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetMultipleFields {
  id
  intField
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetMultipleFields',
    );
  }
}
