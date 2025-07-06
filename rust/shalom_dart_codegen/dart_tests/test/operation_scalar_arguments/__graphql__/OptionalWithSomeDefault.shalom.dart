// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class OptionalWithSomeDefaultResponse {
  /// class members

  final OptionalWithSomeDefault_task? task;

  // keywordargs constructor
  OptionalWithSomeDefaultResponse({this.task});
  static OptionalWithSomeDefaultResponse fromJson(JsonObject data) {
    final OptionalWithSomeDefault_task? task_value;

    final JsonObject? task$raw = data['task'];
    if (task$raw != null) {
      task_value = OptionalWithSomeDefault_task.fromJson(task$raw);
    } else {
      task_value = null;
    }

    return OptionalWithSomeDefaultResponse(task: task_value);
  }

  OptionalWithSomeDefaultResponse updateWithJson(JsonObject data) {
    final OptionalWithSomeDefault_task? task_value;
    if (data.containsKey('task')) {
      final JsonObject? task$raw = data['task'];
      if (task$raw != null) {
        task_value = OptionalWithSomeDefault_task.fromJson(task$raw);
      } else {
        task_value = null;
      }
    } else {
      task_value = task;
    }

    return OptionalWithSomeDefaultResponse(task: task_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OptionalWithSomeDefaultResponse && other.task == task);
  }

  @override
  int get hashCode => task.hashCode;

  JsonObject toJson() {
    return {'task': task?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OptionalWithSomeDefault_task {
  /// class members

  final String? name;

  final int? duration;

  final bool? is_easy;

  // keywordargs constructor
  OptionalWithSomeDefault_task({this.name, this.duration, this.is_easy});
  static OptionalWithSomeDefault_task fromJson(JsonObject data) {
    final String? name_value;

    name_value = data['name'];

    final int? duration_value;

    duration_value = data['duration'];

    final bool? is_easy_value;

    is_easy_value = data['is_easy'];

    return OptionalWithSomeDefault_task(
      name: name_value,

      duration: duration_value,

      is_easy: is_easy_value,
    );
  }

  OptionalWithSomeDefault_task updateWithJson(JsonObject data) {
    final String? name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final int? duration_value;
    if (data.containsKey('duration')) {
      duration_value = data['duration'];
    } else {
      duration_value = duration;
    }

    final bool? is_easy_value;
    if (data.containsKey('is_easy')) {
      is_easy_value = data['is_easy'];
    } else {
      is_easy_value = is_easy;
    }

    return OptionalWithSomeDefault_task(
      name: name_value,

      duration: duration_value,

      is_easy: is_easy_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OptionalWithSomeDefault_task &&
            other.name == name &&
            other.duration == duration &&
            other.is_easy == is_easy);
  }

  @override
  int get hashCode => Object.hashAll([name, duration, is_easy]);

  JsonObject toJson() {
    return {'name': name, 'duration': duration, 'is_easy': is_easy};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestOptionalWithSomeDefault extends Requestable {
  final OptionalWithSomeDefaultVariables variables;

  RequestOptionalWithSomeDefault({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""query OptionalWithSomeDefault($name: String = "shalom", $duration: Int = 2, $is_easy: Boolean = false) {
  task(name: $name, duration: $duration, is_easy: $is_easy) {
    name
    duration
    is_easy
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'OptionalWithSomeDefault',
    );
  }
}

class OptionalWithSomeDefaultVariables {
  final int? duration;

  final bool? is_easy;

  final String? name;

  OptionalWithSomeDefaultVariables({
    this.duration = 2,

    this.is_easy = false,

    this.name = "shalom",
  });

  JsonObject toJson() {
    JsonObject data = {};

    data["duration"] = this.duration;

    data["is_easy"] = this.is_easy;

    data["name"] = this.name;

    return data;
  }

  OptionalWithSomeDefaultVariables updateWith({
    Option<int?> duration = const None(),

    Option<bool?> is_easy = const None(),

    Option<String?> name = const None(),
  }) {
    final int? duration$next;

    switch (duration) {
      case Some(value: final updateData):
        duration$next = updateData;
      case None():
        duration$next = this.duration;
    }

    final bool? is_easy$next;

    switch (is_easy) {
      case Some(value: final updateData):
        is_easy$next = updateData;
      case None():
        is_easy$next = this.is_easy;
    }

    final String? name$next;

    switch (name) {
      case Some(value: final updateData):
        name$next = updateData;
      case None():
        name$next = this.name;
    }

    return OptionalWithSomeDefaultVariables(
      duration: duration$next,

      is_easy: is_easy$next,

      name: name$next,
    );
  }
}
