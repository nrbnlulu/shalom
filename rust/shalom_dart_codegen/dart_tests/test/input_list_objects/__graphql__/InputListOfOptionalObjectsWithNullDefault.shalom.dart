// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListOfOptionalObjectsWithNullDefaultResponse {
  /// class members

  final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault?
  InputListOfOptionalObjectsWithNullDefault;

  // keywordargs constructor
  InputListOfOptionalObjectsWithNullDefaultResponse({
    this.InputListOfOptionalObjectsWithNullDefault,
  });
  static InputListOfOptionalObjectsWithNullDefaultResponse fromJson(JsonObject data) {
    final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault?
    InputListOfOptionalObjectsWithNullDefault_value;
    final InputListOfOptionalObjectsWithNullDefault$raw =
        data["InputListOfOptionalObjectsWithNullDefault"];
    InputListOfOptionalObjectsWithNullDefault_value =
        InputListOfOptionalObjectsWithNullDefault$raw == null
            ? null
            : InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault.fromJson(
              InputListOfOptionalObjectsWithNullDefault$raw,
            );

    return InputListOfOptionalObjectsWithNullDefaultResponse(
      InputListOfOptionalObjectsWithNullDefault: InputListOfOptionalObjectsWithNullDefault_value,
    );
  }

  static InputListOfOptionalObjectsWithNullDefaultResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = InputListOfOptionalObjectsWithNullDefaultResponse.fromJson(data);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListOfOptionalObjectsWithNullDefaultResponse &&
            other.InputListOfOptionalObjectsWithNullDefault ==
                InputListOfOptionalObjectsWithNullDefault);
  }

  @override
  int get hashCode => InputListOfOptionalObjectsWithNullDefault.hashCode;

  JsonObject toJson() {
    return {
      'InputListOfOptionalObjectsWithNullDefault':
          this.InputListOfOptionalObjectsWithNullDefault?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault {
  /// class members

  final bool success;

  final String? message;

  // keywordargs constructor
  InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault({
    required this.success,

    this.message,
  });
  static InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault
  fromJson(JsonObject data) {
    final bool success_value;
    final success$raw = data["success"];
    success_value = success$raw as bool;

    final String? message_value;
    final message$raw = data["message"];
    message_value = message$raw as String?;

    return InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault(
      success: success_value,

      message: message_value,
    );
  }

  static InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault
  deserialize(JsonObject data, ShalomContext context) {
    final self =
        InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault.fromJson(
          data,
        );

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault &&
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

class RequestInputListOfOptionalObjectsWithNullDefault extends Requestable {
  final InputListOfOptionalObjectsWithNullDefaultVariables variables;

  RequestInputListOfOptionalObjectsWithNullDefault({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation InputListOfOptionalObjectsWithNullDefault($items: [MyInputObject!] = null) {
  InputListOfOptionalObjectsWithNullDefault(items: $items) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'InputListOfOptionalObjectsWithNullDefault',
    );
  }
}

class InputListOfOptionalObjectsWithNullDefaultVariables {
  final List<MyInputObject>? items;

  InputListOfOptionalObjectsWithNullDefaultVariables({this.items});

  JsonObject toJson() {
    JsonObject data = {};

    data["items"] = this.items?.map((e) => e.toJson()).toList();

    return data;
  }

  InputListOfOptionalObjectsWithNullDefaultVariables updateWith({
    Option<List<MyInputObject>?> items = const None(),
  }) {
    final List<MyInputObject>? items$next;

    switch (items) {
      case Some(value: final updateData):
        items$next = updateData;
      case None():
        items$next = this.items;
    }

    return InputListOfOptionalObjectsWithNullDefaultVariables(items: items$next);
  }
}
