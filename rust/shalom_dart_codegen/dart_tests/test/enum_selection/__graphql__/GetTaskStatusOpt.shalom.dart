// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetTaskStatusOptResponse {
  /// class members

  final GetTaskStatusOpt_task task;

  // keywordargs constructor
  GetTaskStatusOptResponse({required this.task});
  static GetTaskStatusOptResponse fromJson(JsonObject data) {
    final GetTaskStatusOpt_task task_value;

    task_value = GetTaskStatusOpt_task.fromJson(data['task']);

    return GetTaskStatusOptResponse(task: task_value);
  }

  GetTaskStatusOptResponse updateWithJson(JsonObject data) {
    final GetTaskStatusOpt_task task_value;
    if (data.containsKey('task')) {
      task_value = GetTaskStatusOpt_task.fromJson(data['task']);
    } else {
      task_value = task;
    }

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
    return {'task': task.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetTaskStatusOpt_task {
  /// class members

  final String id;

  final String name;

  final Status? statusOpt;

  // keywordargs constructor
  GetTaskStatusOpt_task({required this.id, required this.name, this.statusOpt});
  static GetTaskStatusOpt_task fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final String name_value;

    name_value = data['name'];

    final Status? statusOpt_value;

    final String? statusOpt$raw = data['statusOpt'];
    if (statusOpt$raw != null) {
      statusOpt_value = Status.fromString(statusOpt$raw);
    } else {
      statusOpt_value = null;
    }

    return GetTaskStatusOpt_task(
      id: id_value,

      name: name_value,

      statusOpt: statusOpt_value,
    );
  }

  GetTaskStatusOpt_task updateWithJson(JsonObject data) {
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

    final Status? statusOpt_value;
    if (data.containsKey('statusOpt')) {
      final String? statusOpt$raw = data['statusOpt'];
      if (statusOpt$raw != null) {
        statusOpt_value = Status.fromString(statusOpt$raw);
      } else {
        statusOpt_value = null;
      }
    } else {
      statusOpt_value = statusOpt;
    }

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
    return {'id': id, 'name': name, 'statusOpt': statusOpt?.name};
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
      StringopName: 'GetTaskStatusOpt',
    );
  }
}

// ------------ Node DEFINITIONS -------------

class GetTaskStatusOptNode extends Node {
  GetTaskStatusOptResponse? _obj;
  bool isSubscribed = false;
  GetTaskStatusOptNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    if (!isSubscribed) {
      throw Exception("manager must be subscribed to node");
    }
    _obj = GetTaskStatusOptResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (!isSubscribed) {
      throw Exception("must subscribe to node through manager");
    }
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = GetTaskStatusOptResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setSubscription(JsonObject? data) {
    if (data != null) {
      _obj = GetTaskStatusOptResponse.fromJson(data);
    }
    isSubscribed = true;
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetTaskStatusOptResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
