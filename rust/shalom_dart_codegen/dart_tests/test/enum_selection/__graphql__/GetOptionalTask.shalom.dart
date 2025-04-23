typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetOptionalTask {
  /// class members

  final GetOptionalTask_task? task;

  // keywordargs constructor

  RequestGetOptionalTask({this.task});
  static RequestGetOptionalTask fromJson(JsonObject data) {
    final GetOptionalTask_task? task_value;

    final JsonObject? task$raw = data['task'];
    if (task$raw != null) {
      task_value = GetOptionalTask_task.fromJson(task$raw);
    } else {
      task_value = null;
    }

    return RequestGetOptionalTask(task: task_value);
  }

  RequestGetOptionalTask updateWithJson(JsonObject data) {
    final GetOptionalTask_task? task_value;
    if (data.containsKey('task')) {
      final JsonObject? task$raw = data['task'];
      if (task$raw != null) {
        task_value = GetOptionalTask_task.fromJson(task$raw);
      } else {
        task_value = null;
      }
    } else {
      task_value = task;
    }

    return RequestGetOptionalTask(task: task_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetOptionalTask && other.task == task && true);
  }

  @override
  int get hashCode => task.hashCode;

  JsonObject toJson() {
    return {'task': task?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetOptionalTask_task {
  /// class members

  final String id;

  final String name;

  final GetOptionalTask_task_status status;

  // keywordargs constructor
  GetOptionalTask_task({
    required this.id,
    required this.name,
    required this.status,
  });
  static GetOptionalTask_task fromJson(JsonObject data) {
    final String id_value = data['id'];

    final String name_value = data['name'];

    final GetOptionalTask_task_status status_value;

    status_value = GetOptionalTask_task_status.fromString(data['status']);

    return GetOptionalTask_task(
      id: id_value,

      name: name_value,

      status: status_value,
    );
  }

  GetOptionalTask_task updateWithJson(JsonObject data) {
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

    final GetOptionalTask_task_status status_value;
    if (data.containsKey('status')) {
      status_value = GetOptionalTask_task_status.fromString(data['status']);
    } else {
      status_value = status;
    }

    return GetOptionalTask_task(
      id: id_value,

      name: name_value,

      status: status_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetOptionalTask_task &&
            other.id == id &&
            other.name == name &&
            other.status == status &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, status]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'status': status.toString()};
  }
}

// ------------ Enum DEFINITIONS -------------

enum GetOptionalTask_task_status {
  COMPLETED,

  FAILED,

  PENDING,

  PROCESSING;

  static GetOptionalTask_task_status fromString(String value) {
    return GetOptionalTask_task_status.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse:
          () =>
              throw ArgumentError("Unknown GetOptionalTask_task_status $value"),
    );
  }

  @override
  String toString() => name.toUpperCase();
}

// ------------ END Enum DEFINITIONS -------------
