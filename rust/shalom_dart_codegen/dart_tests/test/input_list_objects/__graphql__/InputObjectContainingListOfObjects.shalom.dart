// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputObjectContainingListOfObjectsResponse {
  /// class members

  final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects?
  InputObjectContainingListOfObjects;

  // keywordargs constructor
  InputObjectContainingListOfObjectsResponse({this.InputObjectContainingListOfObjects});
  static InputObjectContainingListOfObjectsResponse fromJson(JsonObject data) {
    final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects?
    InputObjectContainingListOfObjects_value;
    final InputObjectContainingListOfObjects$raw = data["InputObjectContainingListOfObjects"];
    InputObjectContainingListOfObjects_value =
        InputObjectContainingListOfObjects$raw == null
            ? null
            : InputObjectContainingListOfObjects_InputObjectContainingListOfObjects.fromJson(
              InputObjectContainingListOfObjects$raw,
            );

    return InputObjectContainingListOfObjectsResponse(
      InputObjectContainingListOfObjects: InputObjectContainingListOfObjects_value,
    );
  }

  static InputObjectContainingListOfObjectsResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = InputObjectContainingListOfObjectsResponse.fromJson(data);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputObjectContainingListOfObjectsResponse &&
            other.InputObjectContainingListOfObjects == InputObjectContainingListOfObjects);
  }

  @override
  int get hashCode => InputObjectContainingListOfObjects.hashCode;

  JsonObject toJson() {
    return {
      'InputObjectContainingListOfObjects': this.InputObjectContainingListOfObjects?.toJson(),
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
  static InputObjectContainingListOfObjects_InputObjectContainingListOfObjects fromJson(
    JsonObject data,
  ) {
    final bool success_value;
    final success$raw = data["success"];
    success_value = success$raw as bool;

    final String? message_value;
    final message$raw = data["message"];
    message_value = message$raw as String?;

    return InputObjectContainingListOfObjects_InputObjectContainingListOfObjects(
      success: success_value,

      message: message_value,
    );
  }

  static InputObjectContainingListOfObjects_InputObjectContainingListOfObjects deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = InputObjectContainingListOfObjects_InputObjectContainingListOfObjects.fromJson(
      data,
    );

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputObjectContainingListOfObjects_InputObjectContainingListOfObjects &&
            other.success == success &&
            other.message == message);
  }

  @override
  int get hashCode => Object.hashAll([success, message]);

  JsonObject toJson() {
    return {'success': this.success, 'message': this.message};
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
      query: r"""mutation InputObjectContainingListOfObjects($data: ContainerInput!) {
  InputObjectContainingListOfObjects(data: $data) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'InputObjectContainingListOfObjects',
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

  InputObjectContainingListOfObjectsVariables updateWith({ContainerInput? data}) {
    final ContainerInput data$next;

    if (data != null) {
      data$next = data;
    } else {
      data$next = this.data;
    }

    return InputObjectContainingListOfObjectsVariables(data: data$next);
  }
}
