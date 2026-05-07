// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class UserWidgetResponse {
  static String G__typename = "query";

  /// class members
  final UserWidget_user? user;

  // keywordargs constructor
  UserWidgetResponse({this.user});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserWidgetResponse && user == other.user);
  }

  @override
  int get hashCode => Object.hashAll([user, UserWidgetResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }

  @experimental
  static UserWidgetResponse fromJson(shalom_core.JsonObject data) {
    final UserWidget_user? user$value = data['user'] == null
        ? null
        : UserWidget_user.fromJson(data['user'] as shalom_core.JsonObject);
    return UserWidgetResponse(user: user$value);
  }
}

class UserWidget_user {
  static String G__typename = "User";

  /// class members
  final String id;

  final String name;

  // keywordargs constructor
  UserWidget_user({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserWidget_user && id == other.id && name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([id, name, UserWidget_user.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  @experimental
  static UserWidget_user fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return UserWidget_user(id: id$value, name: name$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ V2 WIDGET API -------------

final class UserWidgetData {
  final UserWidget_user? user;

  const UserWidgetData({required this.user});

  @experimental
  static UserWidgetData fromCache(shalom_core.JsonObject data) {
    final UserWidget_user? user$value = data['user'] == null
        ? null
        : UserWidget_user.fromJson(data['user'] as shalom_core.JsonObject);
    return UserWidgetData(user: user$value);
  }

  shalom_core.JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

final class UserWidgetVariables {
  final String id;

  const UserWidgetVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserWidgetVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END V2 WIDGET API -------------
