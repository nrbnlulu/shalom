// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListOfOptionalObjectsWithNullDefaultResponse {
  /// class members

  final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault?
  InputListOfOptionalObjectsWithNullDefault;

  // keywordargs constructor
  InputListOfOptionalObjectsWithNullDefaultResponse({
    this.InputListOfOptionalObjectsWithNullDefault,
  });
  static InputListOfOptionalObjectsWithNullDefaultResponse fromJson(
    JsonObject data,
  ) {
    final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault?
    InputListOfOptionalObjectsWithNullDefault_value;

    final JsonObject? InputListOfOptionalObjectsWithNullDefault$raw =
        data['InputListOfOptionalObjectsWithNullDefault'];
    if (InputListOfOptionalObjectsWithNullDefault$raw != null) {
      InputListOfOptionalObjectsWithNullDefault_value =
          InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault.fromJson(
            InputListOfOptionalObjectsWithNullDefault$raw,
          );
    } else {
      InputListOfOptionalObjectsWithNullDefault_value = null;
    }

    return InputListOfOptionalObjectsWithNullDefaultResponse(
      InputListOfOptionalObjectsWithNullDefault:
          InputListOfOptionalObjectsWithNullDefault_value,
    );
  }

  InputListOfOptionalObjectsWithNullDefaultResponse updateWithJson(
    JsonObject data,
  ) {
    final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault?
    InputListOfOptionalObjectsWithNullDefault_value;
    if (data.containsKey('InputListOfOptionalObjectsWithNullDefault')) {
      final JsonObject? InputListOfOptionalObjectsWithNullDefault$raw =
          data['InputListOfOptionalObjectsWithNullDefault'];
      if (InputListOfOptionalObjectsWithNullDefault$raw != null) {
        InputListOfOptionalObjectsWithNullDefault_value =
            InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault.fromJson(
              InputListOfOptionalObjectsWithNullDefault$raw,
            );
      } else {
        InputListOfOptionalObjectsWithNullDefault_value = null;
      }
    } else {
      InputListOfOptionalObjectsWithNullDefault_value =
          InputListOfOptionalObjectsWithNullDefault;
    }

    return InputListOfOptionalObjectsWithNullDefaultResponse(
      InputListOfOptionalObjectsWithNullDefault:
          InputListOfOptionalObjectsWithNullDefault_value,
    );
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
          InputListOfOptionalObjectsWithNullDefault?.toJson(),
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

    success_value = data['success'];

    final String? message_value;

    message_value = data['message'];

    return InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault(
      success: success_value,

      message: message_value,
    );
  }

  InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault
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

    return InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault(
      success: success_value,

      message: message_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other
                is InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault &&
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
      StringopName: 'InputListOfOptionalObjectsWithNullDefault',
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

    return InputListOfOptionalObjectsWithNullDefaultVariables(
      items: items$next,
    );
  }
}
