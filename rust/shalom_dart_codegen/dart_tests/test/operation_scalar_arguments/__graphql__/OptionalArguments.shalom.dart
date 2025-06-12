import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class OptionalArgumentsResponse {
  /// class members

  final OptionalArguments_updateUser? updateUser;

  // keywordargs constructor
  OptionalArgumentsResponse({this.updateUser});
  static OptionalArgumentsResponse fromJson(JsonObject data) {
    final OptionalArguments_updateUser? updateUser_value;

    final JsonObject? updateUser$raw = data['updateUser'];
    if (updateUser$raw != null) {
      updateUser_value = OptionalArguments_updateUser.fromJson(updateUser$raw);
    } else {
      updateUser_value = null;
    }

    return OptionalArgumentsResponse(updateUser: updateUser_value);
  }

  OptionalArgumentsResponse updateWithJson(JsonObject data) {
    final OptionalArguments_updateUser? updateUser_value;
    if (data.containsKey('updateUser')) {
      final JsonObject? updateUser$raw = data['updateUser'];
      if (updateUser$raw != null) {
        updateUser_value = OptionalArguments_updateUser.fromJson(
          updateUser$raw,
        );
      } else {
        updateUser_value = null;
      }
    } else {
      updateUser_value = updateUser;
    }

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
    return {'updateUser': updateUser?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OptionalArguments_updateUser {
  /// class members

  final String? name;

  // keywordargs constructor
  OptionalArguments_updateUser({this.name});
  static OptionalArguments_updateUser fromJson(JsonObject data) {
    final String? name_value = data['name'];

    return OptionalArguments_updateUser(name: name_value);
  }

  OptionalArguments_updateUser updateWithJson(JsonObject data) {
    final String? name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

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
    return {'name': name};
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
      StringopName: 'OptionalArguments',
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
      data["id"] = id.some();
    }

    if (phone.isSome()) {
      data["phone"] = phone.some();
    }

    return data;
  }
}
