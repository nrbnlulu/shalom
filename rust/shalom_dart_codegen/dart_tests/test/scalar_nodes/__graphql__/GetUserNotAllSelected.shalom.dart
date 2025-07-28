// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetUserNotAllSelectedResponse {
  /// class members

  GetUserNotAllSelected_user? user;

  // keywordargs constructor
  GetUserNotAllSelectedResponse({this.user});
  static GetUserNotAllSelectedResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final GetUserNotAllSelected_user? user_value;
    final user$raw = data["user"];
    user_value =
        user$raw == null
            ? null
            : GetUserNotAllSelected_user.fromJson(user$raw, context: context);

    return GetUserNotAllSelectedResponse(user: user_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserNotAllSelectedResponse && other.user == user);
  }

  @override
  int get hashCode => user.hashCode;

  JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetUserNotAllSelected_user extends Node {
  /// class members

  String name;

  // keywordargs constructor
  GetUserNotAllSelected_user({required super.id, required this.name});
  static GetUserNotAllSelected_user fromJson(
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

    return GetUserNotAllSelected_user(id: id_value, name: name_value);
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name'}, context);
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
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserNotAllSelected_user &&
            other.id == id &&
            other.name == name);
  }

  @override
  int get hashCode => Object.hashAll([id, name]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetUserNotAllSelected extends Requestable {
  RequestGetUserNotAllSelected();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetUserNotAllSelected {
  user {
    id
    name
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetUserNotAllSelected',
    );
  }
}
