// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetTaskResponse {
  /// class members

  final GetTask_task task;

  // keywordargs constructor
  GetTaskResponse({required this.task});
  static GetTaskResponse fromJson(JsonObject data, ShalomContext? context) {
    final GetTask_task task_value;
    final task$raw = data["task"];
    task_value = GetTask_task.fromJson(task$raw, context);

    return GetTaskResponse(task: task_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetTaskResponse && other.task == task);
  }

  @override
  int get hashCode => task.hashCode;

  JsonObject toJson() {
    return {'task': this.task.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetTask_task {
  /// class members

  final String id;

  final String name;

  final Status status;

  // keywordargs constructor
  GetTask_task({required this.id, required this.name, required this.status});
  static GetTask_task fromJson(JsonObject data, ShalomContext? context) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final Status status_value;
    final status$raw = data["status"];
    status_value = Status.fromString(status$raw);

    return GetTask_task(id: id_value, name: name_value, status: status_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetTask_task &&
            other.id == id &&
            other.name == name &&
            other.status == status);
  }

  @override
  int get hashCode => Object.hashAll([id, name, status]);

  JsonObject toJson() {
    return {'id': this.id, 'name': this.name, 'status': this.status.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetTask extends Requestable {
  RequestGetTask();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetTask {
  task {
    id
    name
    status
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetTask',
    );
  }
}
