import "schema.shalom.dart";

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetTaskWithUndecisiveStatus {
  /// class members

  final GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus?
  taskWithUndecisiveStatus;

  // keywordargs constructor

  RequestGetTaskWithUndecisiveStatus({this.taskWithUndecisiveStatus});
  static RequestGetTaskWithUndecisiveStatus fromJson(JsonObject data) {
    final GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus?
    taskWithUndecisiveStatus_value;

    final JsonObject? taskWithUndecisiveStatus$raw =
        data['taskWithUndecisiveStatus'];
    if (taskWithUndecisiveStatus$raw != null) {
      taskWithUndecisiveStatus_value =
          GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus.fromJson(
            taskWithUndecisiveStatus$raw,
          );
    } else {
      taskWithUndecisiveStatus_value = null;
    }

    return RequestGetTaskWithUndecisiveStatus(
      taskWithUndecisiveStatus: taskWithUndecisiveStatus_value,
    );
  }

  RequestGetTaskWithUndecisiveStatus updateWithJson(JsonObject data) {
    final GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus?
    taskWithUndecisiveStatus_value;
    if (data.containsKey('taskWithUndecisiveStatus')) {
      final JsonObject? taskWithUndecisiveStatus$raw =
          data['taskWithUndecisiveStatus'];
      if (taskWithUndecisiveStatus$raw != null) {
        taskWithUndecisiveStatus_value =
            GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus.fromJson(
              taskWithUndecisiveStatus$raw,
            );
      } else {
        taskWithUndecisiveStatus_value = null;
      }
    } else {
      taskWithUndecisiveStatus_value = taskWithUndecisiveStatus;
    }

    return RequestGetTaskWithUndecisiveStatus(
      taskWithUndecisiveStatus: taskWithUndecisiveStatus_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetTaskWithUndecisiveStatus &&
            other.taskWithUndecisiveStatus == taskWithUndecisiveStatus &&
            true);
  }

  @override
  int get hashCode => taskWithUndecisiveStatus.hashCode;

  JsonObject toJson() {
    return {'taskWithUndecisiveStatus': taskWithUndecisiveStatus?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus {
  /// class members

  final String id;

  final String name;

  final Status? status;

  // keywordargs constructor
  GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus({
    required this.id,
    required this.name,

    this.status,
  });
  static GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus fromJson(
    JsonObject data,
  ) {
    final String id_value = data['id'];

    final String name_value = data['name'];

    final Status? status_value;

    final String? status$raw = data['status'];
    if (status$raw != null) {
      status_value = Status.fromString(status$raw);
    } else {
      status_value = null;
    }

    return GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus(
      id: id_value,

      name: name_value,

      status: status_value,
    );
  }

  GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus updateWithJson(
    JsonObject data,
  ) {
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

    final Status? status_value;
    if (data.containsKey('status')) {
      final String? status$raw = data['status'];
      if (status$raw != null) {
        status_value = Status.fromString(status$raw);
      } else {
        status_value = null;
      }
    } else {
      status_value = status;
    }

    return GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus(
      id: id_value,

      name: name_value,

      status: status_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus &&
            other.id == id &&
            other.name == name &&
            other.status == status &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, status]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'status': status?.name};
  }
}
