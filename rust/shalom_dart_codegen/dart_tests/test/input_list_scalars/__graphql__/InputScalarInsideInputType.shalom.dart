// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputScalarInsideInputTypeResponse {
  /// class members

  final InputScalarInsideInputType_InputScalarInsideInputType?
  InputScalarInsideInputType;

  // keywordargs constructor
  InputScalarInsideInputTypeResponse({this.InputScalarInsideInputType});
  static InputScalarInsideInputTypeResponse fromJson(JsonObject data) {
    final InputScalarInsideInputType_InputScalarInsideInputType?
    InputScalarInsideInputType_value;

    final JsonObject? InputScalarInsideInputType$raw =
        data['InputScalarInsideInputType'];
    if (InputScalarInsideInputType$raw != null) {
      InputScalarInsideInputType_value =
          InputScalarInsideInputType_InputScalarInsideInputType.fromJson(
            InputScalarInsideInputType$raw,
          );
    } else {
      InputScalarInsideInputType_value = null;
    }

    return InputScalarInsideInputTypeResponse(
      InputScalarInsideInputType: InputScalarInsideInputType_value,
    );
  }

  InputScalarInsideInputTypeResponse updateWithJson(JsonObject data) {
    final InputScalarInsideInputType_InputScalarInsideInputType?
    InputScalarInsideInputType_value;
    if (data.containsKey('InputScalarInsideInputType')) {
      final JsonObject? InputScalarInsideInputType$raw =
          data['InputScalarInsideInputType'];
      if (InputScalarInsideInputType$raw != null) {
        InputScalarInsideInputType_value =
            InputScalarInsideInputType_InputScalarInsideInputType.fromJson(
              InputScalarInsideInputType$raw,
            );
      } else {
        InputScalarInsideInputType_value = null;
      }
    } else {
      InputScalarInsideInputType_value = InputScalarInsideInputType;
    }

    return InputScalarInsideInputTypeResponse(
      InputScalarInsideInputType: InputScalarInsideInputType_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarInsideInputTypeResponse &&
            other.InputScalarInsideInputType == InputScalarInsideInputType);
  }

  @override
  int get hashCode => InputScalarInsideInputType.hashCode;

  JsonObject toJson() {
    return {'InputScalarInsideInputType': InputScalarInsideInputType?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputScalarInsideInputType_InputScalarInsideInputType {
  /// class members

  final bool success;

  // keywordargs constructor
  InputScalarInsideInputType_InputScalarInsideInputType({
    required this.success,
  });
  static InputScalarInsideInputType_InputScalarInsideInputType fromJson(
    JsonObject data,
  ) {
    final bool success_value;

    success_value = data['success'];

    return InputScalarInsideInputType_InputScalarInsideInputType(
      success: success_value,
    );
  }

  InputScalarInsideInputType_InputScalarInsideInputType updateWithJson(
    JsonObject data,
  ) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return InputScalarInsideInputType_InputScalarInsideInputType(
      success: success_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarInsideInputType_InputScalarInsideInputType &&
            other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputScalarInsideInputType extends Requestable {
  final InputScalarInsideInputTypeVariables variables;

  RequestInputScalarInsideInputType({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputScalarInsideInputType($user: UserInput!) {
  InputScalarInsideInputType(user: $user) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputScalarInsideInputType',
    );
  }
}

class InputScalarInsideInputTypeVariables {
  final UserInput user;

  InputScalarInsideInputTypeVariables({required this.user});

  JsonObject toJson() {
    JsonObject data = {};

    data["user"] = this.user.toJson();

    return data;
  }

  InputScalarInsideInputTypeVariables updateWith({UserInput? user}) {
    final UserInput user$next;

    if (user != null) {
      user$next = user;
    } else {
      user$next = this.user;
    }

    return InputScalarInsideInputTypeVariables(user: user$next);
  }
}
