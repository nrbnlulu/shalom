// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetUserWithOptionalNameResponse {
  /// class members

  GetUserWithOptionalName_userOptional? userOptional;

  // keywordargs constructor
  GetUserWithOptionalNameResponse({this.userOptional});
  static GetUserWithOptionalNameResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final GetUserWithOptionalName_userOptional? userOptional_value;
    final userOptional$raw = data["userOptional"];
    userOptional_value =
        userOptional$raw == null
            ? null
            : GetUserWithOptionalName_userOptional.fromJson(
              userOptional$raw,
              context: context,
            );

    return GetUserWithOptionalNameResponse(userOptional: userOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithOptionalNameResponse &&
            other.userOptional == userOptional);
  }

  @override
  int get hashCode => userOptional.hashCode;

  JsonObject toJson() {
    return {'userOptional': this.userOptional?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetUserWithOptionalName_userOptional extends Node {
  /// class members

  String? name;

  String password;

  // keywordargs constructor
  GetUserWithOptionalName_userOptional({
    required super.id,

    this.name,

    required this.password,
  });
  static GetUserWithOptionalName_userOptional fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String? name_value;
    final name$raw = data["name"];
    name_value = name$raw as String?;

    final String password_value;
    final password$raw = data["password"];
    password_value = password$raw as String;

    return GetUserWithOptionalName_userOptional(
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
          name = name$raw as String?;
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
        (other is GetUserWithOptionalName_userOptional &&
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

class RequestGetUserWithOptionalName extends Requestable {
  RequestGetUserWithOptionalName();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetUserWithOptionalName {
  userOptional {
    id
    name
    password
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetUserWithOptionalName',
    );
  }
}
