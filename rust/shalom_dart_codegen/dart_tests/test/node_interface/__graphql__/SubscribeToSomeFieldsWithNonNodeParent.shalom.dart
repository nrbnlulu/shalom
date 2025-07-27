// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class SubscribeToSomeFieldsWithNonNodeParentResponse {
  /// class members

  SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode? userInfoNotNode;

  // keywordargs constructor
  SubscribeToSomeFieldsWithNonNodeParentResponse({this.userInfoNotNode});
  static SubscribeToSomeFieldsWithNonNodeParentResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode?
    userInfoNotNode_value;
    final userInfoNotNode$raw = data["userInfoNotNode"];

    userInfoNotNode_value =
        userInfoNotNode$raw == null
            ? null
            : SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode.fromJson(
              userInfoNotNode$raw,
              context,
            );

    return SubscribeToSomeFieldsWithNonNodeParentResponse(
      userInfoNotNode: userInfoNotNode_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeFieldsWithNonNodeParentResponse &&
            other.userInfoNotNode == userInfoNotNode);
  }

  @override
  int get hashCode => userInfoNotNode.hashCode;

  JsonObject toJson() {
    return {'userInfoNotNode': this.userInfoNotNode?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode {
  /// class members

  SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user user;

  // keywordargs constructor
  SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode({required this.user});
  static SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user
    user_value;
    final user$raw = data["user"];

    user_value =
        SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user.fromJson(
          user$raw,
          context,
        );

    if (context != null) {
      context.manager.parseNodeData(user$raw);
    }

    return SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode(
      user: user_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode &&
            other.user == user);
  }

  @override
  int get hashCode => user.hashCode;

  JsonObject toJson() {
    return {'user': this.user.toJson()};
  }
}

class SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user extends Node {
  /// class members

  String name;

  // keywordargs constructor
  SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user({
    required super.id,

    required this.name,
  });
  static SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String id_value;
    final id$raw = data["id"];

    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];

    name_value = name$raw as String;

    return SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user(
      id: id_value,

      name: name_value,
    );
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
        (other is SubscribeToSomeFieldsWithNonNodeParent_userInfoNotNode_user &&
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

class RequestSubscribeToSomeFieldsWithNonNodeParent extends Requestable {
  RequestSubscribeToSomeFieldsWithNonNodeParent();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query SubscribeToSomeFieldsWithNonNodeParent {
  userInfoNotNode {
    user {
      id
      name
    }
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'SubscribeToSomeFieldsWithNonNodeParent',
    );
  }
}
