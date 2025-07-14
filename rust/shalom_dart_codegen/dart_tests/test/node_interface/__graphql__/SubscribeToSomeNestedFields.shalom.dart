// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class SubscribeToSomeNestedFieldsResponse {
  /// class members

  final SubscribeToSomeNestedFields_userInfo? userInfo;

  // keywordargs constructor
  SubscribeToSomeNestedFieldsResponse({this.userInfo});
  static SubscribeToSomeNestedFieldsResponse fromJson(JsonObject data) {
    final SubscribeToSomeNestedFields_userInfo? userInfo_value;
    final userInfo$raw = data["userInfo"];
    userInfo_value =
        userInfo$raw == null
            ? null
            : SubscribeToSomeNestedFields_userInfo.fromJson(userInfo$raw);

    return SubscribeToSomeNestedFieldsResponse(userInfo: userInfo_value);
  }

  static SubscribeToSomeNestedFieldsResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeNestedFieldsResponse.fromJson(data);

    SubscribeToSomeNestedFields_userInfo?.deserialize(
      data['userInfo'],
      context,
    );

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeNestedFieldsResponse &&
            other.userInfo == userInfo);
  }

  @override
  int get hashCode => userInfo.hashCode;

  JsonObject toJson() {
    return {'userInfo': this.userInfo?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class SubscribeToSomeNestedFields_userInfo extends Node {
  /// class members

  SubscribeToSomeNestedFields_userInfo_user user;

  SubscribeToSomeNestedFields_userInfo_address address;

  // keywordargs constructor
  SubscribeToSomeNestedFields_userInfo({
    required super.id,
    required this.user,
    required this.address,
  });
  static SubscribeToSomeNestedFields_userInfo fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final SubscribeToSomeNestedFields_userInfo_user user_value;
    final user$raw = data["user"];
    user_value = SubscribeToSomeNestedFields_userInfo_user.fromJson(user$raw);

    final SubscribeToSomeNestedFields_userInfo_address address_value;
    final address$raw = data["address"];
    address_value = SubscribeToSomeNestedFields_userInfo_address.fromJson(
      address$raw,
    );

    return SubscribeToSomeNestedFields_userInfo(
      id: id_value,

      user: user_value,

      address: address_value,
    );
  }

  static SubscribeToSomeNestedFields_userInfo deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeNestedFields_userInfo.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    SubscribeToSomeNestedFields_userInfo_user.deserialize(
      data['user'],
      context,
    );

    SubscribeToSomeNestedFields_userInfo_address.deserialize(
      data['address'],
      context,
    );

    return self;
  }

  @override
  StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'user', 'address'}, context);
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

        case 'user':
          user = SubscribeToSomeNestedFields_userInfo_user.deserialize(
            rawData['user'],
            context,
          );

          break;

        case 'address':
          address = SubscribeToSomeNestedFields_userInfo_address.deserialize(
            rawData['address'],
            context,
          );

          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeNestedFields_userInfo &&
            other.id == id &&
            other.user == user &&
            other.address == address);
  }

  @override
  int get hashCode => Object.hashAll([id, user, address]);

  @override
  JsonObject toJson() {
    return {
      'id': this.id,

      'user': this.user.toJson(),

      'address': this.address.toJson(),
    };
  }
}

class SubscribeToSomeNestedFields_userInfo_address extends Node {
  /// class members

  String city;

  // keywordargs constructor
  SubscribeToSomeNestedFields_userInfo_address({
    required super.id,
    required this.city,
  });
  static SubscribeToSomeNestedFields_userInfo_address fromJson(
    JsonObject data,
  ) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String city_value;
    final city$raw = data["city"];
    city_value = city$raw as String;

    return SubscribeToSomeNestedFields_userInfo_address(
      id: id_value,

      city: city_value,
    );
  }

  static SubscribeToSomeNestedFields_userInfo_address deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeNestedFields_userInfo_address.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    return self;
  }

  @override
  StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'city'}, context);
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

        case 'city':
          city = rawData['city'];

          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeNestedFields_userInfo_address &&
            other.id == id &&
            other.city == city);
  }

  @override
  int get hashCode => Object.hashAll([id, city]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'city': this.city};
  }
}

class SubscribeToSomeNestedFields_userInfo_user extends Node {
  /// class members

  String name;

  // keywordargs constructor
  SubscribeToSomeNestedFields_userInfo_user({
    required super.id,
    required this.name,
  });
  static SubscribeToSomeNestedFields_userInfo_user fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    return SubscribeToSomeNestedFields_userInfo_user(
      id: id_value,

      name: name_value,
    );
  }

  static SubscribeToSomeNestedFields_userInfo_user deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeNestedFields_userInfo_user.fromJson(data);

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
        (other is SubscribeToSomeNestedFields_userInfo_user &&
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

class RequestSubscribeToSomeNestedFields extends Requestable {
  RequestSubscribeToSomeNestedFields();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query SubscribeToSomeNestedFields {
  userInfo {
    id
    user {
      id
      name
    }
    address {
      id
      city
    }
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'SubscribeToSomeNestedFields',
    );
  }
}
