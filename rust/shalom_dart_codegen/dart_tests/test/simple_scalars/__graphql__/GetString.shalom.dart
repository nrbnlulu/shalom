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
    final stringNormalized$Key = "string";
    final string$cached = this$NormalizedRecord[stringNormalized$Key];
    final string$raw = data["string"];
    if (string$raw != null) {
      if (string$cached != string$raw) {}
      this$NormalizedRecord[stringNormalized$Key] = string$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("string") && string$cached != null) {
        this$NormalizedRecord[stringNormalized$Key] = null;
      }
    }
  }

  static GetStringResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final string$raw = data["string"];
    final String string$value = string$raw as String;
    return GetStringResponse(string: string$value);
  }

  static GetStringResponse fromJson(JsonObject data, {ShalomCtx? ctx}) {
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
      this$fieldName: "string",
      parent$record: getOrCreateObject(
        updateCtx.getCachedObjectRecord("ROOT_QUERY"),
        "string",
      ),
    );
    return fromJsonImpl(data, ctx);
  }

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
    final stringNormalized$Key = "string";
    final string$cached = this$NormalizedRecord[stringNormalized$Key];
    final string$raw = data["string"];
    if (string$raw != null) {
      if (string$cached != string$raw) {}
      this$NormalizedRecord[stringNormalized$Key] = string$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("string") && string$cached != null) {
        this$NormalizedRecord[stringNormalized$Key] = null;
      }
    }
  }

  static GetString fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final string$raw = data["string"];
    final String string$value = string$raw as String;
    return GetString(string: string$value);
  }

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
