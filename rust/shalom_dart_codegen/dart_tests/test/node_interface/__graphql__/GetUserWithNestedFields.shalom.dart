// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetUserWithNestedFieldsResponse {
  /// class members

  GetUserWithNestedFields_user? user;

  // keywordargs constructor
  GetUserWithNestedFieldsResponse({this.user});
  static GetUserWithNestedFieldsResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final GetUserWithNestedFields_user? user_value;
    final user$raw = data["user"];
    user_value =
        user$raw == null
            ? null
            : GetUserWithNestedFields_user.fromJson(user$raw, context: context);

    return GetUserWithNestedFieldsResponse(user: user_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithNestedFieldsResponse && other.user == user);
  }

  @override
  int get hashCode => user.hashCode;

  JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetUserWithNestedFields_user extends Node {
  /// class members

  String name;

  GetUserWithNestedFields_user_address? address;

  GetUserWithNestedFields_user_post post;

  // keywordargs constructor
  GetUserWithNestedFields_user({
    required super.id,

    required this.name,

    this.address,

    required this.post,
  });
  static GetUserWithNestedFields_user fromJson(
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

    final GetUserWithNestedFields_user_address? address_value;
    final address$raw = data["address"];
    address_value =
        address$raw == null
            ? null
            : GetUserWithNestedFields_user_address.fromJson(
              address$raw,
              context: context,
            );

    final GetUserWithNestedFields_user_post post_value;
    final post$raw = data["post"];
    post_value = GetUserWithNestedFields_user_post.fromJson(
      post$raw,
      context: context,
    );

    return GetUserWithNestedFields_user(
      id: id_value,

      name: name_value,

      address: address_value,

      post: post_value,
    );
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name', 'address'}, context);
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

        case 'address':
          final address$raw = rawData['address'];
          address =
              address$raw == null
                  ? null
                  : GetUserWithNestedFields_user_address.fromJson(address$raw);
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithNestedFields_user &&
            other.id == id &&
            other.name == name &&
            other.address == address &&
            other.post == post);
  }

  @override
  int get hashCode => Object.hashAll([id, name, address, post]);

  @override
  JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'address': this.address?.toJson(),

      'post': this.post.toJson(),
    };
  }
}

class GetUserWithNestedFields_user_address {
  /// class members

  String street;

  String city;

  // keywordargs constructor
  GetUserWithNestedFields_user_address({
    required this.street,

    required this.city,
  });
  static GetUserWithNestedFields_user_address fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final String street_value;
    final street$raw = data["street"];
    street_value = street$raw as String;

    final String city_value;
    final city$raw = data["city"];
    city_value = city$raw as String;

    return GetUserWithNestedFields_user_address(
      street: street_value,

      city: city_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithNestedFields_user_address &&
            other.street == street &&
            other.city == city);
  }

  @override
  int get hashCode => Object.hashAll([street, city]);

  JsonObject toJson() {
    return {'street': this.street, 'city': this.city};
  }
}

class GetUserWithNestedFields_user_post extends Node {
  /// class members

  String title;

  // keywordargs constructor
  GetUserWithNestedFields_user_post({required super.id, required this.title});
  static GetUserWithNestedFields_user_post fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String title_value;
    final title$raw = data["title"];
    title_value = title$raw as String;

    return GetUserWithNestedFields_user_post(id: id_value, title: title_value);
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'title'}, context);
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    for (final fieldName in changedFields) {
      switch (fieldName) {
        case 'id':
          final id$raw = rawData['id'];
          id = id$raw as String;
          break;

        case 'title':
          final title$raw = rawData['title'];
          title = title$raw as String;
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithNestedFields_user_post &&
            other.id == id &&
            other.title == title);
  }

  @override
  int get hashCode => Object.hashAll([id, title]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'title': this.title};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetUserWithNestedFields extends Requestable {
  final GetUserWithNestedFieldsVariables variables;

  RequestGetUserWithNestedFields({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""query GetUserWithNestedFields($userId: ID!) {
  user(id: $userId) {
    id
    name
    address {
      street
      city
    }
    post {
      id
      title
    }
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetUserWithNestedFields',
    );
  }
}

class GetUserWithNestedFieldsVariables {
  final String userId;

  GetUserWithNestedFieldsVariables({required this.userId});

  JsonObject toJson() {
    JsonObject data = {};

    data["userId"] = this.userId;

    return data;
  }

  GetUserWithNestedFieldsVariables updateWith({String? userId}) {
    final String userId$next;

    if (userId != null) {
      userId$next = userId;
    } else {
      userId$next = this.userId;
    }

    return GetUserWithNestedFieldsVariables(userId: userId$next);
  }
}
