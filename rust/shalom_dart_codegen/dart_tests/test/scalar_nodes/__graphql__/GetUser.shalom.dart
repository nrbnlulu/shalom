// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetUserResponse {
  /// class members

  GetUser_user? user;

  // keywordargs constructor
  GetUserResponse({this.user});
  static GetUserResponse fromJson(JsonObject data, {ShalomContext? context}) {
    final GetUser_user? user_value;
    final user$raw = data["user"];
    user_value =
        user$raw == null
            ? null
            : GetUser_user.fromJson(user$raw, context: context);

    return GetUserResponse(user: user_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserResponse && other.user == user);
  }

  @override
  int get hashCode => user.hashCode;

  JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetUser_user extends Node {
  /// class members

  String name;

  String password;

  // keywordargs constructor
  GetUser_user({required super.id, required this.name, required this.password});
  static GetUser_user fromJson(JsonObject data, {ShalomContext? context}) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final String password_value;
    final password$raw = data["password"];
    password_value = password$raw as String;

    return GetUser_user(
      id: id_value,

      name: name_value,

      password: password_value,
    );
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name', 'password'}, context);
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

        case 'password':
          final password$raw = rawData['password'];
          password = password$raw as String;
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUser_user &&
            other.id == id &&
            other.name == name &&
            other.password == password);
  }

  @override
  int get hashCode => Object.hashAll([id, name, password]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'name': this.name, 'password': this.password};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetUser extends Requestable {
  RequestGetUser();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetUser {
  user {
    id
    name
    password
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetUser',
    );
  }
}
