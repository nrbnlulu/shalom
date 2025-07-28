// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetUserWithOptionalNameAndStatusResponse {
  /// class members

  GetUserWithOptionalNameAndStatus_userOptional? userOptional;

  // keywordargs constructor
  GetUserWithOptionalNameAndStatusResponse({this.userOptional});
  static GetUserWithOptionalNameAndStatusResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final GetUserWithOptionalNameAndStatus_userOptional? userOptional_value;
    final userOptional$raw = data["userOptional"];
    userOptional_value =
        userOptional$raw == null
            ? null
            : GetUserWithOptionalNameAndStatus_userOptional.fromJson(
              userOptional$raw,
              context: context,
            );

    return GetUserWithOptionalNameAndStatusResponse(
      userOptional: userOptional_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithOptionalNameAndStatusResponse &&
            other.userOptional == userOptional);
  }

  @override
  int get hashCode => userOptional.hashCode;

  JsonObject toJson() {
    return {'userOptional': this.userOptional?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetUserWithOptionalNameAndStatus_userOptional extends Node {
  /// class members

  String? name;

  Status status;

  // keywordargs constructor
  GetUserWithOptionalNameAndStatus_userOptional({
    required super.id,

    this.name,

    required this.status,
  });
  static GetUserWithOptionalNameAndStatus_userOptional fromJson(
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

    final Status status_value;
    final status$raw = data["status"];
    status_value = Status.fromString(status$raw);

    return GetUserWithOptionalNameAndStatus_userOptional(
      id: id_value,

      name: name_value,

      status: status_value,
    );
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name', 'status'}, context);
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

        case 'status':
          final status$raw = rawData['status'];
          status = Status.fromString(status$raw);
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserWithOptionalNameAndStatus_userOptional &&
            other.id == id &&
            other.name == name &&
            other.status == status);
  }

  @override
  int get hashCode => Object.hashAll([id, name, status]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'name': this.name, 'status': this.status.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetUserWithOptionalNameAndStatus extends Requestable {
  RequestGetUserWithOptionalNameAndStatus();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetUserWithOptionalNameAndStatus {
  userOptional {
    id
    name
    status
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetUserWithOptionalNameAndStatus',
    );
  }
}
