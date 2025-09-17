// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class SubmitReviewResponse {
  /// class members

  final String? submitReview;

  // keywordargs constructor
  SubmitReviewResponse({this.submitReview});

  static void updateCachePrivate(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject this$data,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    this$normalizedID = this$fieldName;
    this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
    // TODO: handle arguments
    final submitReviewNormalized$Key = "submitReview";
    final submitReview$cached =
        this$NormalizedRecord[submitReviewNormalized$Key];
    final submitReview$raw = data["submitReview"];
    if (submitReview$raw != null) {
      if (submitReview$cached != submitReview$raw) {}
      this$NormalizedRecord[submitReviewNormalized$Key] = submitReview$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("submitReview") && submitReview$cached != null) {
        this$NormalizedRecord[submitReviewNormalized$Key] = null;
      }
    }
  }

  static SubmitReviewResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final submitReview$raw = data["submitReview"];
    final String? submitReview$value = submitReview$raw as String?;
    return SubmitReviewResponse(submitReview: submitReview$value);
  }

  static SubmitReviewResponse fromJson(JsonObject data, {ShalomCtx? ctx}) {
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
      this$fieldName: "submitReview",
      this$data: getOrCreateObject(
        updateCtx.getCachedObjectRecord("ROOT_QUERY"),
        "submitReview",
      ),
    );
    return fromJsonImpl(data, ctx);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubmitReviewResponse && other.submitReview == submitReview);
  }

  @override
  int get hashCode => submitReview.hashCode;

  JsonObject toJson() {
    return {'submitReview': this.submitReview};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class SubmitReview {
  /// class members

  final String? submitReview;

  // keywordargs constructor
  SubmitReview({this.submitReview});

  static void updateCachePrivate(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject this$data,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    this$normalizedID = this$fieldName;
    this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
    // TODO: handle arguments
    final submitReviewNormalized$Key = "submitReview";
    final submitReview$cached =
        this$NormalizedRecord[submitReviewNormalized$Key];
    final submitReview$raw = data["submitReview"];
    if (submitReview$raw != null) {
      if (submitReview$cached != submitReview$raw) {}
      this$NormalizedRecord[submitReviewNormalized$Key] = submitReview$raw;
    } else {
      // if this field was null in the response and key exists clear the cache.
      if (data.containsKey("submitReview") && submitReview$cached != null) {
        this$NormalizedRecord[submitReviewNormalized$Key] = null;
      }
    }
  }

  static SubmitReview fromJsonImpl(JsonObject data, ShalomCtx ctx) {
    final submitReview$raw = data["submitReview"];
    final String? submitReview$value = submitReview$raw as String?;
    return SubmitReview(submitReview: submitReview$value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubmitReview && other.submitReview == submitReview);
  }

  @override
  int get hashCode => submitReview.hashCode;

  JsonObject toJson() {
    return {'submitReview': this.submitReview};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestSubmitReview extends Requestable {
  final SubmitReviewVariables variables;

  RequestSubmitReview({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation SubmitReview($review: Review) {
  submitReview(review: $review)
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'SubmitReview',
    );
  }
}

class SubmitReviewVariables {
  final Option<Review?> review;

  SubmitReviewVariables({this.review = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (review.isSome()) {
      final value = this.review.some();
      data["review"] = value?.toJson();
    }

    return data;
  }

  SubmitReviewVariables updateWith({
    Option<Option<Review?>> review = const None(),
  }) {
    final Option<Review?> review$next;

    switch (review) {
      case Some(value: final updateData):
        review$next = updateData;
      case None():
        review$next = this.review;
    }

    return SubmitReviewVariables(review: review$next);
  }
}
