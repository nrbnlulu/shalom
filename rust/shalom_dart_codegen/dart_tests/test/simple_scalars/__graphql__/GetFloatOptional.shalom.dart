// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatOptionalResponse {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptionalResponse({this.floatOptional});

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
    final floatOptionalNormalized$Key = "floatOptional";
    final floatOptional$cached =
        this$NormalizedRecord[floatOptionalNormalized$Key];
    final floatOptional$raw = data["floatOptional"];
    if (floatOptional$raw != null) {
      if (floatOptional$cached != floatOptional$raw) {}
      this$NormalizedRecord[floatOptionalNormalized$Key] = floatOptional$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("floatOptional") && floatOptional$cached != null) {
        this$NormalizedRecord[floatOptionalNormalized$Key] = null;
      }
    }
  }

  static GetFloatOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final floatOptional$raw = data["floatOptional"];
    final double? floatOptional$value = floatOptional$raw as double?;
    return GetFloatOptionalResponse(floatOptional: floatOptional$value);
  }

  static GetFloatOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}) {
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
      this$fieldName: "floatOptional",
      parent$record: getOrCreateObject(
        updateCtx.getCachedObjectRecord("ROOT_QUERY"),
        "floatOptional",
      ),
    );
    return fromJsonImpl(data, ctx);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptionalResponse &&
            other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': this.floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetFloatOptional {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptional({this.floatOptional});

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
    final floatOptionalNormalized$Key = "floatOptional";
    final floatOptional$cached =
        this$NormalizedRecord[floatOptionalNormalized$Key];
    final floatOptional$raw = data["floatOptional"];
    if (floatOptional$raw != null) {
      if (floatOptional$cached != floatOptional$raw) {}
      this$NormalizedRecord[floatOptionalNormalized$Key] = floatOptional$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("floatOptional") && floatOptional$cached != null) {
        this$NormalizedRecord[floatOptionalNormalized$Key] = null;
      }
    }
  }

  static GetFloatOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final floatOptional$raw = data["floatOptional"];
    final double? floatOptional$value = floatOptional$raw as double?;
    return GetFloatOptional(floatOptional: floatOptional$value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptional && other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': this.floatOptional};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
  RequestGetFloatOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatOptional {
  floatOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetFloatOptional',
    );
  }
}
