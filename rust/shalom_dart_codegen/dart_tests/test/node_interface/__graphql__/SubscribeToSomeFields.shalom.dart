// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class SubscribeToSomeFieldsResponse {
  /// class members

  final SubscribeToSomeFields_user? user;

  // keywordargs constructor
  SubscribeToSomeFieldsResponse({this.user});
  static SubscribeToSomeFieldsResponse fromJson(JsonObject data) {
    final SubscribeToSomeFields_user? user_value;
    final user$raw = data["user"];
    user_value =
        user$raw == null ? null : SubscribeToSomeFields_user.fromJson(user$raw);

    return SubscribeToSomeFieldsResponse(user: user_value);
  }

  static SubscribeToSomeFieldsResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeFieldsResponse.fromJson(data);

    SubscribeToSomeFields_user?.deserialize(data['user'], context);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeFieldsResponse && other.user == user);
  }

  @override
  int get hashCode => user.hashCode;

  JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class SubscribeToSomeFields_user extends Node {
  /// class members

  String name;

  // keywordargs constructor
  SubscribeToSomeFields_user({required super.id, required this.name});
  static SubscribeToSomeFields_user fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    return SubscribeToSomeFields_user(id: id_value, name: name_value);
  }

  static SubscribeToSomeFields_user deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeFields_user.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    return self;
  }

  @override
  StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name'}, context);
  }

  @override
  void updateWithJson(
    JsonObject rawData,
    Set<String> changedFields,
    ShalomContext context,
  ) {
    for (final fieldName in changedFields) {
      switch (fieldName) {
        case 'id':
          id = rawData['id'];

          break;

        case 'name':
          name = rawData['name'];

          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeFields_user &&
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

class RequestSubscribeToSomeFields extends Requestable {
  RequestSubscribeToSomeFields();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query SubscribeToSomeFields {
  user {
    id
    name
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'SubscribeToSomeFields',
    );
  }
}
