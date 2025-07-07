// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputCustomScalarListInsideInputObjectResponse {
  /// class members

  final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject?
  InputCustomScalarListInsideInputObject;

  // keywordargs constructor
  InputCustomScalarListInsideInputObjectResponse({
    this.InputCustomScalarListInsideInputObject,
  });
  static InputCustomScalarListInsideInputObjectResponse fromJson(
    JsonObject data,
  ) {
    final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject?
    InputCustomScalarListInsideInputObject_value;

    final JsonObject? InputCustomScalarListInsideInputObject$raw =
        data['InputCustomScalarListInsideInputObject'];
    if (InputCustomScalarListInsideInputObject$raw != null) {
      InputCustomScalarListInsideInputObject_value =
          InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject.fromJson(
            InputCustomScalarListInsideInputObject$raw,
          );
    } else {
      InputCustomScalarListInsideInputObject_value = null;
    }

    return InputCustomScalarListInsideInputObjectResponse(
      InputCustomScalarListInsideInputObject:
          InputCustomScalarListInsideInputObject_value,
    );
  }

  InputCustomScalarListInsideInputObjectResponse updateWithJson(
    JsonObject data,
  ) {
    final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject?
    InputCustomScalarListInsideInputObject_value;
    if (data.containsKey('InputCustomScalarListInsideInputObject')) {
      final JsonObject? InputCustomScalarListInsideInputObject$raw =
          data['InputCustomScalarListInsideInputObject'];
      if (InputCustomScalarListInsideInputObject$raw != null) {
        InputCustomScalarListInsideInputObject_value =
            InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject.fromJson(
              InputCustomScalarListInsideInputObject$raw,
            );
      } else {
        InputCustomScalarListInsideInputObject_value = null;
      }
    } else {
      InputCustomScalarListInsideInputObject_value =
          InputCustomScalarListInsideInputObject;
    }

    return InputCustomScalarListInsideInputObjectResponse(
      InputCustomScalarListInsideInputObject:
          InputCustomScalarListInsideInputObject_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputCustomScalarListInsideInputObjectResponse &&
            other.InputCustomScalarListInsideInputObject ==
                InputCustomScalarListInsideInputObject);
  }

  @override
  int get hashCode => InputCustomScalarListInsideInputObject.hashCode;

  JsonObject toJson() {
    return {
      'InputCustomScalarListInsideInputObject':
          InputCustomScalarListInsideInputObject?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject {
  /// class members

  final bool success;

  final String? message;

  // keywordargs constructor
  InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject({
    required this.success,

    this.message,
  });
  static InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject
  fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    final String? message_value;

    message_value = data['message'];

    return InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject(
      success: success_value,

      message: message_value,
    );
  }

  InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject
  updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    final String? message_value;
    if (data.containsKey('message')) {
      message_value = data['message'];
    } else {
      message_value = message;
    }

    return InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject(
      success: success_value,

      message: message_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other
                is InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject &&
            other.success == success &&
            other.message == message);
  }

  @override
  int get hashCode => Object.hashAll([success, message]);

  JsonObject toJson() {
    return {'success': success, 'message': message};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputCustomScalarListInsideInputObject extends Requestable {
  final InputCustomScalarListInsideInputObjectVariables variables;

  RequestInputCustomScalarListInsideInputObject({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation InputCustomScalarListInsideInputObject($newContainer: ItemContainerInput!) {
  InputCustomScalarListInsideInputObject(newContainer: $newContainer) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputCustomScalarListInsideInputObject',
    );
  }
}

class InputCustomScalarListInsideInputObjectVariables {
  final ItemContainerInput newContainer;

  InputCustomScalarListInsideInputObjectVariables({required this.newContainer});

  JsonObject toJson() {
    JsonObject data = {};

    data["newContainer"] = this.newContainer.toJson();

    return data;
  }

  InputCustomScalarListInsideInputObjectVariables updateWith({
    ItemContainerInput? newContainer,
  }) {
    final ItemContainerInput newContainer$next;

    if (newContainer != null) {
      newContainer$next = newContainer;
    } else {
      newContainer$next = this.newContainer;
    }

    return InputCustomScalarListInsideInputObjectVariables(
      newContainer: newContainer$next,
    );
  }
}
