// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class SubscribeToAllNestedFieldsResponse {
  /// class members

  final SubscribeToAllNestedFields_userInfo? userInfo;

  // keywordargs constructor
  SubscribeToAllNestedFieldsResponse({this.userInfo});
  static SubscribeToAllNestedFieldsResponse fromJson(JsonObject data) {
    final SubscribeToAllNestedFields_userInfo? userInfo_value;
    final userInfo$raw = data["userInfo"];
    userInfo_value =
        userInfo$raw == null
            ? null
            : SubscribeToAllNestedFields_userInfo.fromJson(userInfo$raw);

    return SubscribeToAllNestedFieldsResponse(userInfo: userInfo_value);
  }

  static SubscribeToAllNestedFieldsResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToAllNestedFieldsResponse.fromJson(data);

    SubscribeToAllNestedFields_userInfo?.deserialize(data['userInfo'], context);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToAllNestedFieldsResponse &&
            other.userInfo == userInfo);
  }

  @override
  int get hashCode => userInfo.hashCode;

  JsonObject toJson() {
    return {'userInfo': this.userInfo?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class SubscribeToAllNestedFields_userInfo extends Node {
  /// class members

  SubscribeToAllNestedFields_userInfo_user user;

  SubscribeToAllNestedFields_userInfo_address address;

  // keywordargs constructor
  SubscribeToAllNestedFields_userInfo({
    required super.id,
    required this.user,
    required this.address,
  });
  static SubscribeToAllNestedFields_userInfo fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final SubscribeToAllNestedFields_userInfo_user user_value;
    final user$raw = data["user"];
    user_value = SubscribeToAllNestedFields_userInfo_user.fromJson(user$raw);

    final SubscribeToAllNestedFields_userInfo_address address_value;
    final address$raw = data["address"];
    address_value = SubscribeToAllNestedFields_userInfo_address.fromJson(
      address$raw,
    );

    return SubscribeToAllNestedFields_userInfo(
      id: id_value,

      user: user_value,

      address: address_value,
    );
  }

  static SubscribeToAllNestedFields_userInfo deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToAllNestedFields_userInfo.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    SubscribeToAllNestedFields_userInfo_user.deserialize(data['user'], context);

    SubscribeToAllNestedFields_userInfo_address.deserialize(
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
          SubscribeToAllNestedFields_userInfo_user.deserialize(
            rawData['user'],
            context,
          );

          break;

        case 'address':
          SubscribeToAllNestedFields_userInfo_address.deserialize(
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
        (other is SubscribeToAllNestedFields_userInfo &&
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

class SubscribeToAllNestedFields_userInfo_address extends Node {
  /// class members

  String street;

  String city;

  // keywordargs constructor
  SubscribeToAllNestedFields_userInfo_address({
    required super.id,
    required this.street,
    required this.city,
  });
  static SubscribeToAllNestedFields_userInfo_address fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String street_value;
    final street$raw = data["street"];
    street_value = street$raw as String;

    final String city_value;
    final city$raw = data["city"];
    city_value = city$raw as String;

    return SubscribeToAllNestedFields_userInfo_address(
      id: id_value,

      street: street_value,

      city: city_value,
    );
  }

  static SubscribeToAllNestedFields_userInfo_address deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToAllNestedFields_userInfo_address.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    return self;
  }

  @override
  StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'street', 'city'}, context);
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

        case 'street':
          street = rawData['street'];

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
        (other is SubscribeToAllNestedFields_userInfo_address &&
            other.id == id &&
            other.street == street &&
            other.city == city);
  }

  @override
  int get hashCode => Object.hashAll([id, street, city]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'street': this.street, 'city': this.city};
  }
}

class SubscribeToAllNestedFields_userInfo_user extends Node {
  /// class members

  String name;

  String email;

  int? age;

  // keywordargs constructor
  SubscribeToAllNestedFields_userInfo_user({
    required super.id,
    required this.name,
    required this.email,

    this.age,
  });
  static SubscribeToAllNestedFields_userInfo_user fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final String email_value;
    final email$raw = data["email"];
    email_value = email$raw as String;

    final int? age_value;
    final age$raw = data["age"];
    age_value = age$raw as int?;

    return SubscribeToAllNestedFields_userInfo_user(
      id: id_value,

      name: name_value,

      email: email_value,

      age: age_value,
    );
  }

  static SubscribeToAllNestedFields_userInfo_user deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToAllNestedFields_userInfo_user.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    return self;
  }

  @override
  StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {
      'id',

      'name',

      'email',

      'age',
    }, context);
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

        case 'email':
          email = rawData['email'];

          break;

        case 'age':
          age = rawData['age'];

          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToAllNestedFields_userInfo_user &&
            other.id == id &&
            other.name == name &&
            other.email == email &&
            other.age == age);
  }

  @override
  int get hashCode => Object.hashAll([id, name, email, age]);

  @override
  JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'email': this.email,

      'age': this.age,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestSubscribeToAllNestedFields extends Requestable {
  RequestSubscribeToAllNestedFields();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query SubscribeToAllNestedFields {
  userInfo {
    id
    user {
      id
      name
      email
      age
    }
    address {
      id
      street
      city
    }
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'SubscribeToAllNestedFields',
    );
  }
}
