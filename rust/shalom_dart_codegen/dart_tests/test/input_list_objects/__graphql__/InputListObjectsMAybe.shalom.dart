// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListObjectsMAybeResponse {
  /// class members

  InputListObjectsMAybe_InputListObjectsMAybe? InputListObjectsMAybe;

  // keywordargs constructor
  InputListObjectsMAybeResponse({this.InputListObjectsMAybe});
  static InputListObjectsMAybeResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final InputListObjectsMAybe_InputListObjectsMAybe?
    InputListObjectsMAybe_value;
    final InputListObjectsMAybe$raw = data["InputListObjectsMAybe"];

    InputListObjectsMAybe_value =
        InputListObjectsMAybe$raw == null
            ? null
            : InputListObjectsMAybe_InputListObjectsMAybe.fromJson(
              InputListObjectsMAybe$raw,
              context,
            );

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
    return {'InputListObjectsMAybe': this.InputListObjectsMAybe?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputListObjectsMAybe_InputListObjectsMAybe {
  /// class members

  bool success;

  String? message;

  // keywordargs constructor
  InputListObjectsMAybe_InputListObjectsMAybe({
    required this.success,

    this.message,
  });
  static InputListObjectsMAybe_InputListObjectsMAybe fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final bool success_value;
    final success$raw = data["success"];

    success_value = success$raw as bool;

    final String? message_value;
    final message$raw = data["message"];

    message_value = message$raw as String?;

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
    return {'success': this.success, 'message': this.message};
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
      opName: 'InputListObjectsMAybe',
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
