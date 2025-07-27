// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class SubmitReviewResponse {
  /// class members

  final String? submitReview;

  // keywordargs constructor
  SubmitReviewResponse({this.submitReview});
  static SubmitReviewResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String? submitReview_value;
    final submitReview$raw = data["submitReview"];
    submitReview_value = submitReview$raw as String?;

    return SubmitReviewResponse(submitReview: submitReview_value);
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
