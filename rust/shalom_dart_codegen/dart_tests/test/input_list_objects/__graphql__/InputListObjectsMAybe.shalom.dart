// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListObjectsMAybeResponse {
  /// class members

  final InputListObjectsMAybe_InputListObjectsMAybe? InputListObjectsMAybe;

  // keywordargs constructor
  InputListObjectsMAybeResponse({this.InputListObjectsMAybe});
  static InputListObjectsMAybeResponse fromJson(JsonObject data) {
    final InputListObjectsMAybe_InputListObjectsMAybe?
    InputListObjectsMAybe_value;

    final JsonObject? InputListObjectsMAybe$raw = data['InputListObjectsMAybe'];
    if (InputListObjectsMAybe$raw != null) {
      InputListObjectsMAybe_value =
          InputListObjectsMAybe_InputListObjectsMAybe.fromJson(
            InputListObjectsMAybe$raw,
          );
    } else {
      InputListObjectsMAybe_value = null;
    }

    return InputListObjectsMAybeResponse(
      InputListObjectsMAybe: InputListObjectsMAybe_value,
    );
  }

  InputListObjectsMAybeResponse updateWithJson(JsonObject data) {
    final InputListObjectsMAybe_InputListObjectsMAybe?
    InputListObjectsMAybe_value;
    if (data.containsKey('InputListObjectsMAybe')) {
      final JsonObject? InputListObjectsMAybe$raw =
          data['InputListObjectsMAybe'];
      if (InputListObjectsMAybe$raw != null) {
        InputListObjectsMAybe_value =
            InputListObjectsMAybe_InputListObjectsMAybe.fromJson(
              InputListObjectsMAybe$raw,
            );
      } else {
        InputListObjectsMAybe_value = null;
      }
    } else {
      InputListObjectsMAybe_value = InputListObjectsMAybe;
    }

    return InputListObjectsMAybeResponse(
      InputListObjectsMAybe: InputListObjectsMAybe_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListObjectsMAybeResponse &&
            other.InputListObjectsMAybe == InputListObjectsMAybe);
  }

  @override
  int get hashCode => InputListObjectsMAybe.hashCode;

  JsonObject toJson() {
    return {'InputListObjectsMAybe': InputListObjectsMAybe?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputListObjectsMAybe_InputListObjectsMAybe {
  /// class members

  final bool success;

  final String? message;

  // keywordargs constructor
  InputListObjectsMAybe_InputListObjectsMAybe({
    required this.success,

    this.message,
  });
  static InputListObjectsMAybe_InputListObjectsMAybe fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    final String? message_value;

    message_value = data['message'];

    return InputListObjectsMAybe_InputListObjectsMAybe(
      success: success_value,

      message: message_value,
    );
  }

  InputListObjectsMAybe_InputListObjectsMAybe updateWithJson(JsonObject data) {
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

    return InputListObjectsMAybe_InputListObjectsMAybe(
      success: success_value,

      message: message_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListObjectsMAybe_InputListObjectsMAybe &&
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

class RequestInputListObjectsMAybe extends Requestable {
  final InputListObjectsMAybeVariables variables;

  RequestInputListObjectsMAybe({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputListObjectsMAybe($items: [MyInputObject!]) {
  InputListObjectsMAybe(items: $items) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputListObjectsMAybe',
    );
  }
}

class InputListObjectsMAybeVariables {
  final Option<List<MyInputObject>?> items;

  InputListObjectsMAybeVariables({this.items = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (items.isSome()) {
      final value = this.items.some();
      data["items"] = value?.map((e) => e.toJson()).toList();
    }

    return data;
  }

  InputListObjectsMAybeVariables updateWith({
    Option<Option<List<MyInputObject>?>> items = const None(),
  }) {
    final Option<List<MyInputObject>?> items$next;

    switch (items) {
      case Some(value: final updateData):
        items$next = updateData;
      case None():
        items$next = this.items;
    }

    return InputListObjectsMAybeVariables(items: items$next);
  }
}
