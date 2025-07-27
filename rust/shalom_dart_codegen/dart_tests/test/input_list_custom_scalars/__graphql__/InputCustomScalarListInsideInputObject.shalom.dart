// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputCustomScalarListInsideInputObjectResponse {
  /// class members

  InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject?
  InputCustomScalarListInsideInputObject;

  // keywordargs constructor
  InputCustomScalarListInsideInputObjectResponse({
    this.InputCustomScalarListInsideInputObject,
  });
  static InputCustomScalarListInsideInputObjectResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject?
    InputCustomScalarListInsideInputObject_value;
    final InputCustomScalarListInsideInputObject$raw =
        data["InputCustomScalarListInsideInputObject"];
    InputCustomScalarListInsideInputObject_value =
        InputCustomScalarListInsideInputObject$raw == null
            ? null
            : InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject.fromJson(
              InputCustomScalarListInsideInputObject$raw,
              context,
            );

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
          this.InputCustomScalarListInsideInputObject?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject {
  /// class members

  bool success;

  String? message;

  // keywordargs constructor
  InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject({
    required this.success,

    this.message,
  });
  static InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject
  fromJson(JsonObject data, {ShalomContext? context}) {
    final bool success_value;
    final success$raw = data["success"];
    success_value = success$raw as bool;

    final String? message_value;
    final message$raw = data["message"];
    message_value = message$raw as String?;

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
    return {'success': this.success, 'message': this.message};
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
      opName: 'InputCustomScalarListInsideInputObject',
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
