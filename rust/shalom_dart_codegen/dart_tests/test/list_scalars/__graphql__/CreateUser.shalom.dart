// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class CreateUserResponse {
  /// class members

  final CreateUser_createUser? createUser;

  // keywordargs constructor
  CreateUserResponse({this.createUser});
  static CreateUserResponse fromJson(JsonObject data) {
    final CreateUser_createUser? createUser_value;

    final JsonObject? createUser$raw = data['createUser'];
    if (createUser$raw != null) {
      createUser_value = CreateUser_createUser.fromJson(createUser$raw);
    } else {
      createUser_value = null;
    }

    return CreateUserResponse(createUser: createUser_value);
  }

  CreateUserResponse updateWithJson(JsonObject data) {
    final CreateUser_createUser? createUser_value;
    if (data.containsKey('createUser')) {
      final JsonObject? createUser$raw = data['createUser'];
      if (createUser$raw != null) {
        createUser_value = CreateUser_createUser.fromJson(createUser$raw);
      } else {
        createUser_value = null;
      }
    } else {
      createUser_value = createUser;
    }

    return CreateUserResponse(createUser: createUser_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateUserResponse && other.createUser == createUser);
  }

  @override
  int get hashCode => createUser.hashCode;

  JsonObject toJson() {
    return {'createUser': createUser?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class CreateUser_createUser {
  /// class members

  final bool success;

  // keywordargs constructor
  CreateUser_createUser({required this.success});
  static CreateUser_createUser fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return CreateUser_createUser(success: success_value);
  }

  CreateUser_createUser updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return CreateUser_createUser(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateUser_createUser && other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestCreateUser extends Requestable {
  final CreateUserVariables variables;

  RequestCreateUser({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation CreateUser($user: UserInput!) {
  createUser(user: $user) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'CreateUser',
    );
  }
}

class CreateUserVariables {
  final UserInput user;

  CreateUserVariables({required this.user});

  JsonObject toJson() {
    JsonObject data = {};

    data["user"] = user.toJson();

    return data;
  }

  CreateUserVariables updateWith({UserInput? user}) {
    final UserInput user$next;

    if (user != null) {
      user$next = user;
    } else {
      user$next = this.user;
    }

    return CreateUserVariables(user: user$next);
  }
}
