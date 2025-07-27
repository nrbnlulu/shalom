// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OptionalArgumentsResponse {
  /// class members

  OptionalArguments_updateUser? updateUser;

  // keywordargs constructor
  OptionalArgumentsResponse({this.updateUser});
  static OptionalArgumentsResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final OptionalArguments_updateUser? updateUser_value;
    final updateUser$raw = data["updateUser"];

    updateUser_value =
        updateUser$raw == null
            ? null
            : OptionalArguments_updateUser.fromJson(updateUser$raw, context);

    return OptionalArgumentsResponse(updateUser: updateUser_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OptionalArgumentsResponse && other.updateUser == updateUser);
  }

  @override
  int get hashCode => updateUser.hashCode;

  JsonObject toJson() {
    return {'updateUser': this.updateUser?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OptionalArguments_updateUser {
  /// class members

  String? name;

  // keywordargs constructor
  OptionalArguments_updateUser({this.name});
  static OptionalArguments_updateUser fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String? name_value;
    final name$raw = data["name"];

    name_value = name$raw as String?;

    return OptionalArguments_updateUser(name: name_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OptionalArguments_updateUser && other.name == name);
  }

  @override
  int get hashCode => name.hashCode;

  JsonObject toJson() {
    return {'name': this.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestOptionalArguments extends Requestable {
  final OptionalArgumentsVariables variables;

  RequestOptionalArguments({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation OptionalArguments($id: ID, $phone: String) {
  updateUser(id: $id, phone: $phone) {
    name
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'OptionalArguments',
    );
  }
}

class OptionalArgumentsVariables {
  final Option<String?> id;

  final Option<String?> phone;

  OptionalArgumentsVariables({
    this.id = const None(),

    this.phone = const None(),
  });

  JsonObject toJson() {
    JsonObject data = {};

    if (id.isSome()) {
      final value = this.id.some();
      data["id"] = value;
    }

    if (phone.isSome()) {
      final value = this.phone.some();
      data["phone"] = value;
    }

    return data;
  }

  OptionalArgumentsVariables updateWith({
    Option<Option<String?>> id = const None(),

    Option<Option<String?>> phone = const None(),
  }) {
    final Option<String?> id$next;

    switch (id) {
      case Some(value: final updateData):
        id$next = updateData;
      case None():
        id$next = this.id;
    }

    final Option<String?> phone$next;

    switch (phone) {
      case Some(value: final updateData):
        phone$next = updateData;
      case None():
        phone$next = this.phone;
    }

    return OptionalArgumentsVariables(id: id$next, phone: phone$next);
  }
}
