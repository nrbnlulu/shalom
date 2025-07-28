// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetUserWithStatusResponse {
  /// class members

  GetUserWithStatus_user? user;

  // keywordargs constructor
  GetUserWithStatusResponse({this.user});
  static GetUserWithStatusResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final GetUserWithStatus_user? user_value;
    final user$raw = data["user"];
    user_value =
        user$raw == null
            ? null
            : GetUserWithStatus_user.fromJson(user$raw, context: context);

    return GetUserWithStatusResponse(user: user_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithStatusResponse && other.user == user);
  }

  @override
  int get hashCode => user.hashCode;

  JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetUserWithStatus_user extends Node {
  /// class members

  String name;

  Status status;

  // keywordargs constructor
  GetUserWithStatus_user({
    required super.id,

    required this.name,

    required this.status,
  });
  static GetUserWithStatus_user fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final Status status_value;
    final status$raw = data["status"];
    status_value = Status.fromString(status$raw);

    return GetUserWithStatus_user(
      id: id_value,

      name: name_value,

      status: status_value,
    );
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name', 'status'}, context);
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    for (final fieldName in changedFields) {
      switch (fieldName) {
        case 'id':
          final id$raw = rawData['id'];
          id = id$raw as String;
          break;

        case 'name':
          final name$raw = rawData['name'];
          name = name$raw as String;
          break;

        case 'status':
          final status$raw = rawData['status'];
          status = Status.fromString(status$raw);
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithStatus_user &&
            other.id == id &&
            other.name == name &&
            other.status == status);
  }

  @override
  int get hashCode => Object.hashAll([id, name, status]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'name': this.name, 'status': this.status.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetUserWithStatus extends Requestable {
  RequestGetUserWithStatus();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetUserWithStatus {
  user {
    id
    name
    status
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetUserWithStatus',
    );
  }
}
