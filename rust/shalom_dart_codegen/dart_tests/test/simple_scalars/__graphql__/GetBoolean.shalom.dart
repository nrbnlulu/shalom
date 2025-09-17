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

  static void updateCachePrivate(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject parent$record,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    this$normalizedID = this$fieldName;
    this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
    // TODO: handle arguments
    final booleanNormalized$Key = "boolean";
    final boolean$cached = this$NormalizedRecord[booleanNormalized$Key];
    final boolean$raw = data["boolean"];
    if (boolean$raw != null) {
      if (boolean$cached != boolean$raw) {}
      this$NormalizedRecord[booleanNormalized$Key] = boolean$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("boolean") && boolean$cached != null) {
        this$NormalizedRecord[booleanNormalized$Key] = null;
      }
    }
  }

  static GetBooleanResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final boolean$raw = data["boolean"];
    final bool boolean$value = boolean$raw as bool;
    return GetBooleanResponse(boolean: boolean$value);
  }

  static GetBooleanResponse fromJson(JsonObject data, {ShalomCtx? ctx}) {
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
      this$fieldName: "boolean",
      parent$record: getOrCreateObject(
        updateCtx.getCachedObjectRecord("ROOT_QUERY"),
        "boolean",
      ),
    );
    return fromJsonImpl(data, ctx);
  }

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

  static void updateCachePrivate(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject parent$record,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    this$normalizedID = this$fieldName;
    this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
    // TODO: handle arguments
    final booleanNormalized$Key = "boolean";
    final boolean$cached = this$NormalizedRecord[booleanNormalized$Key];
    final boolean$raw = data["boolean"];
    if (boolean$raw != null) {
      if (boolean$cached != boolean$raw) {}
      this$NormalizedRecord[booleanNormalized$Key] = boolean$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("boolean") && boolean$cached != null) {
        this$NormalizedRecord[booleanNormalized$Key] = null;
      }
    }
  }

  static GetBoolean fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final boolean$raw = data["boolean"];
    final bool boolean$value = boolean$raw as bool;
    return GetBoolean(boolean: boolean$value);
  }

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
