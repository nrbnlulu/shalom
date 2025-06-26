// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import

import 'package:shalom_core/shalom_core.dart';

// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

class UserInput {
  final Option<List<String>?> ids;

  final Option<List<int?>?> scores;

  final List<String> tags;

  UserInput({
    this.ids = const None(),

    this.scores = const None(),

    required this.tags,
  });

  JsonObject toJson() {
    JsonObject data = {};

    if (ids.isSome()) {
      final value = ids.some();

      data["ids"] = value;
    } else {
      // This is a list type. Serialize None() to null.
      data["ids"] = null;
    }

    if (scores.isSome()) {
      final value = scores.some();

      data["scores"] = value;
    } else {
      // This is a list type. Serialize None() to null.
      data["scores"] = null;
    }

    data["tags"] = tags;

    return data;
  }

  UserInput updateWith({
    Option<Option<List<String>?>> ids = const None(),

    Option<Option<List<int?>?>> scores = const None(),

    List<String>? tags,
  }) {
    final Option<List<String>?> ids$next;

    switch (ids) {
      case Some(value: final data):
        ids$next = data;
      case None():
        ids$next = this.ids;
    }

    final Option<List<int?>?> scores$next;

    switch (scores) {
      case Some(value: final data):
        scores$next = data;
      case None():
        scores$next = this.scores;
    }

    final List<String> tags$next;

    if (tags != null) {
      tags$next = tags;
    } else {
      tags$next = this.tags;
    }

    return UserInput(ids: ids$next, scores: scores$next, tags: tags$next);
  }
}

// ------------ END Input DEFINITIONS -------------
