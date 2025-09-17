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

  static void updateCachePrivate(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject parent$record,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;
    final RecordID? this$normalizedID_temp = data["idOptional"] as RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = this$fieldName;
      this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
    } else {
      this$normalizedID = this$normalizedID_temp as String;
      parent$record[this$fieldName] = this$normalizedID;
      ctx.addDependantRecord(this$normalizedID);
      this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
    }
    // TODO: handle arguments
    final idOptionalNormalized$Key = "idOptional";
    final idOptional$cached = this$NormalizedRecord[idOptionalNormalized$Key];
    final idOptional$raw = data["idOptional"];
    if (idOptional$raw != null) {
      if (idOptional$cached != idOptional$raw) {
        ctx.addChangedRecord(this$normalizedID, idOptionalNormalized$Key);
      }
      this$NormalizedRecord[idOptionalNormalized$Key] = idOptional$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("idOptional") && idOptional$cached != null) {
        this$NormalizedRecord[idOptionalNormalized$Key] = null;

        ctx.addChangedRecord(this$normalizedID, idOptionalNormalized$Key);
      }
    }
  }

  static GetIDOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final idOptional$raw = data["idOptional"];
    final String? idOptional$value = idOptional$raw as String?;
    return GetIDOptionalResponse(idOptional: idOptional$value);
  }

  static GetIDOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}) {
    // if ctx not provider we create dummy one
    ctx ??= ShalomCtx.withCapacity();
    // first update the cache
    final CacheUpdateContext updateCtx = CacheUpdateContext(
      shalomContext: ctx!,
    );
    // TODO: handle arguments
    updateCachePrivate(
      data,
      updateCtx,
      this$fieldName: "idOptional",
      parent$record: getOrCreateObject(
        updateCtx.getCachedObjectRecord("ROOT_QUERY"),
        "idOptional",
      ),
    );
    return fromJsonImpl(data, ctx);
  }

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

  static void updateCachePrivate(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject parent$record,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;
    final RecordID? this$normalizedID_temp = data["idOptional"] as RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = this$fieldName;
      this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
    } else {
      this$normalizedID = this$normalizedID_temp as String;
      parent$record[this$fieldName] = this$normalizedID;
      ctx.addDependantRecord(this$normalizedID);
      this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
    }
    // TODO: handle arguments
    final idOptionalNormalized$Key = "idOptional";
    final idOptional$cached = this$NormalizedRecord[idOptionalNormalized$Key];
    final idOptional$raw = data["idOptional"];
    if (idOptional$raw != null) {
      if (idOptional$cached != idOptional$raw) {
        ctx.addChangedRecord(this$normalizedID, idOptionalNormalized$Key);
      }
      this$NormalizedRecord[idOptionalNormalized$Key] = idOptional$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("idOptional") && idOptional$cached != null) {
        this$NormalizedRecord[idOptionalNormalized$Key] = null;

        ctx.addChangedRecord(this$normalizedID, idOptionalNormalized$Key);
      }
    }
  }

  static GetIDOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final idOptional$raw = data["idOptional"];
    final String? idOptional$value = idOptional$raw as String?;
    return GetIDOptional(idOptional: idOptional$value);
  }

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
