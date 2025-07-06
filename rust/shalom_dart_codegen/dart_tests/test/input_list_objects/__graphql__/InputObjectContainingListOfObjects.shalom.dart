// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputObjectContainingListOfObjectsResponse {
  /// class members

  final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects?
  InputObjectContainingListOfObjects;

  // keywordargs constructor
  InputObjectContainingListOfObjectsResponse({
    this.InputObjectContainingListOfObjects,
  });
  static InputObjectContainingListOfObjectsResponse fromJson(JsonObject data) {
    final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects?
    InputObjectContainingListOfObjects_value;

    final JsonObject? InputObjectContainingListOfObjects$raw =
        data['InputObjectContainingListOfObjects'];
    if (InputObjectContainingListOfObjects$raw != null) {
      InputObjectContainingListOfObjects_value =
          InputObjectContainingListOfObjects_InputObjectContainingListOfObjects.fromJson(
            InputObjectContainingListOfObjects$raw,
          );
    } else {
      InputObjectContainingListOfObjects_value = null;
    }

    return InputObjectContainingListOfObjectsResponse(
      InputObjectContainingListOfObjects:
          InputObjectContainingListOfObjects_value,
    );
  }

  InputObjectContainingListOfObjectsResponse updateWithJson(JsonObject data) {
    final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects?
    InputObjectContainingListOfObjects_value;
    if (data.containsKey('InputObjectContainingListOfObjects')) {
      final JsonObject? InputObjectContainingListOfObjects$raw =
          data['InputObjectContainingListOfObjects'];
      if (InputObjectContainingListOfObjects$raw != null) {
        InputObjectContainingListOfObjects_value =
            InputObjectContainingListOfObjects_InputObjectContainingListOfObjects.fromJson(
              InputObjectContainingListOfObjects$raw,
            );
      } else {
        InputObjectContainingListOfObjects_value = null;
      }
    } else {
      InputObjectContainingListOfObjects_value =
          InputObjectContainingListOfObjects;
    }

    return InputObjectContainingListOfObjectsResponse(
      InputObjectContainingListOfObjects:
          InputObjectContainingListOfObjects_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputObjectContainingListOfObjectsResponse &&
            other.InputObjectContainingListOfObjects ==
                InputObjectContainingListOfObjects);
  }

  @override
  int get hashCode => InputObjectContainingListOfObjects.hashCode;

  JsonObject toJson() {
    return {
      'InputObjectContainingListOfObjects':
          InputObjectContainingListOfObjects?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputObjectContainingListOfObjects_InputObjectContainingListOfObjects {
  /// class members

  final bool success;

  final String? message;

  // keywordargs constructor
  InputObjectContainingListOfObjects_InputObjectContainingListOfObjects({
    required this.success,

    this.message,
  });
  static InputObjectContainingListOfObjects_InputObjectContainingListOfObjects
  fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    final String? message_value;

    message_value = data['message'];

    return InputObjectContainingListOfObjects_InputObjectContainingListOfObjects(
      success: success_value,

      message: message_value,
    );
  }

  InputObjectContainingListOfObjects_InputObjectContainingListOfObjects
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

    return InputObjectContainingListOfObjects_InputObjectContainingListOfObjects(
      success: success_value,

      message: message_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other
                is InputObjectContainingListOfObjects_InputObjectContainingListOfObjects &&
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

class RequestInputObjectContainingListOfObjects extends Requestable {
  final InputObjectContainingListOfObjectsVariables variables;

  RequestInputObjectContainingListOfObjects({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation InputObjectContainingListOfObjects($data: ContainerInput!) {
  InputObjectContainingListOfObjects(data: $data) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputObjectContainingListOfObjects',
    );
  }
}

class InputObjectContainingListOfObjectsVariables {
  final ContainerInput data;

  InputObjectContainingListOfObjectsVariables({required this.data});

  JsonObject toJson() {
    JsonObject data = {};

    data["data"] = this.data.toJson();

    return data;
  }

  InputObjectContainingListOfObjectsVariables updateWith({
    ContainerInput? data,
  }) {
    final ContainerInput data$next;

    if (data != null) {
      data$next = data;
    } else {
      data$next = this.data;
    }

    return InputObjectContainingListOfObjectsVariables(data: data$next);
  }
}
