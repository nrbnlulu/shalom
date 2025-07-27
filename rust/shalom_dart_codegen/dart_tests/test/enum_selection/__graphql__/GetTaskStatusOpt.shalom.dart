// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetTaskStatusOptResponse {
  /// class members

  GetTaskStatusOpt_task task;

  // keywordargs constructor
  GetTaskStatusOptResponse({required this.task});
  static GetTaskStatusOptResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final GetTaskStatusOpt_task task_value;
    final task$raw = data["task"];

    task_value = GetTaskStatusOpt_task.fromJson(task$raw, context);

    return GetTaskStatusOptResponse(task: task_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetTaskStatusOptResponse && other.task == task);
  }

  @override
  int get hashCode => task.hashCode;

  JsonObject toJson() {
    return {'task': this.task.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetTaskStatusOpt_task {
  /// class members

  String id;

  String name;

  Status? statusOpt;

  // keywordargs constructor
  GetTaskStatusOpt_task({required this.id, required this.name, this.statusOpt});
  static GetTaskStatusOpt_task fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String id_value;
    final id$raw = data["id"];

    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];

    name_value = name$raw as String;

    final Status? statusOpt_value;
    final statusOpt$raw = data["statusOpt"];

    statusOpt_value =
        statusOpt$raw == null ? null : Status.fromString(statusOpt$raw);

    return GetTaskStatusOpt_task(
      id: id_value,

      name: name_value,

      statusOpt: statusOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetTaskStatusOpt_task &&
            other.id == id &&
            other.name == name &&
            other.statusOpt == statusOpt);
  }

  @override
  int get hashCode => Object.hashAll([id, name, statusOpt]);

  JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'statusOpt': this.statusOpt?.name,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetTaskStatusOpt extends Requestable {
  RequestGetTaskStatusOpt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetTaskStatusOpt {
  task {
    id
    name
    statusOpt
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetTaskStatusOpt',
    );
  }
}
