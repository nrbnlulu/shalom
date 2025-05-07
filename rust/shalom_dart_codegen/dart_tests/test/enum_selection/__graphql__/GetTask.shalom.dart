import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetTaskResponse {
  /// class members

  final GetTask_task task;

  // keywordargs constructor
  GetTaskResponse({required this.task});
  static GetTaskResponse fromJson(JsonObject data) {
    final GetTask_task task_value;

    task_value = GetTask_task.fromJson(data['task']);

    return GetTaskResponse(task: task_value);
  }

  GetTaskResponse updateWithJson(JsonObject data) {
    final GetTask_task task_value;
    if (data.containsKey('task')) {
      task_value = GetTask_task.fromJson(data['task']);
    } else {
      task_value = task;
    }

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
    return {'task': task.toJson()};
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
  static GetTask_task fromJson(JsonObject data) {
    final String id_value = data['id'];

    final String name_value = data['name'];

    final Status status_value;

    status_value = Status.fromString(data['status']);

    return GetTask_task(id: id_value, name: name_value, status: status_value);
  }

  GetTask_task updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final Status status_value;
    if (data.containsKey('status')) {
      status_value = Status.fromString(data['status']);
    } else {
      status_value = status;
    }

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
    return {'id': id, 'name': name, 'status': status.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetTask extends Requestable {
  final GetTaskVariables variables;

  RequestGetTask({required this.variables});

  @override
  Request toRequest() {
    return Request(
      query: r"""query GetTask {
  task {
    id
    name
    status
  }
}""",
      variables: variables.toJson(),
      opType: OperationType.Query,
      StringopName: 'GetTask',
    );
  }
}

class GetTaskVariables {
  GetTaskVariables();

  JsonObject toJson() {
    JsonObject data = {};

    return data;
  }

  static GetTaskVariables fromJson(JsonObject data) {
    return GetTaskVariables();
  }
}
