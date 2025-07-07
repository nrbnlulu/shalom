// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListOfRequiredObjectsResponse {
  /// class members

  final InputListOfRequiredObjects_InputListOfRequiredObjects?
  InputListOfRequiredObjects;

  // keywordargs constructor
  InputListOfRequiredObjectsResponse({this.InputListOfRequiredObjects});
  static InputListOfRequiredObjectsResponse fromJson(JsonObject data) {
    final InputListOfRequiredObjects_InputListOfRequiredObjects?
    InputListOfRequiredObjects_value;

    final JsonObject? InputListOfRequiredObjects$raw =
        data['InputListOfRequiredObjects'];
    if (InputListOfRequiredObjects$raw != null) {
      InputListOfRequiredObjects_value =
          InputListOfRequiredObjects_InputListOfRequiredObjects.fromJson(
            InputListOfRequiredObjects$raw,
          );
    } else {
      InputListOfRequiredObjects_value = null;
    }

    return InputListOfRequiredObjectsResponse(
      InputListOfRequiredObjects: InputListOfRequiredObjects_value,
    );
  }

  InputListOfRequiredObjectsResponse updateWithJson(JsonObject data) {
    final InputListOfRequiredObjects_InputListOfRequiredObjects?
    InputListOfRequiredObjects_value;
    if (data.containsKey('InputListOfRequiredObjects')) {
      final JsonObject? InputListOfRequiredObjects$raw =
          data['InputListOfRequiredObjects'];
      if (InputListOfRequiredObjects$raw != null) {
        InputListOfRequiredObjects_value =
            InputListOfRequiredObjects_InputListOfRequiredObjects.fromJson(
              InputListOfRequiredObjects$raw,
            );
      } else {
        InputListOfRequiredObjects_value = null;
      }
    } else {
      InputListOfRequiredObjects_value = InputListOfRequiredObjects;
    }

    return InputListOfRequiredObjectsResponse(
      InputListOfRequiredObjects: InputListOfRequiredObjects_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListOfRequiredObjectsResponse &&
            other.InputListOfRequiredObjects == InputListOfRequiredObjects);
  }

  @override
  int get hashCode => InputListOfRequiredObjects.hashCode;

  JsonObject toJson() {
    return {'InputListOfRequiredObjects': InputListOfRequiredObjects?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputListOfRequiredObjects_InputListOfRequiredObjects {
  /// class members

  final bool success;

  final String? message;

  // keywordargs constructor
  InputListOfRequiredObjects_InputListOfRequiredObjects({
    required this.success,

    this.message,
  });
  static InputListOfRequiredObjects_InputListOfRequiredObjects fromJson(
    JsonObject data,
  ) {
    final bool success_value;

    success_value = data['success'];

    final String? message_value;

    message_value = data['message'];

    return InputListOfRequiredObjects_InputListOfRequiredObjects(
      success: success_value,

      message: message_value,
    );
  }

  InputListOfRequiredObjects_InputListOfRequiredObjects updateWithJson(
    JsonObject data,
  ) {
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

    return InputListOfRequiredObjects_InputListOfRequiredObjects(
      success: success_value,

      message: message_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListOfRequiredObjects_InputListOfRequiredObjects &&
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

class RequestInputListOfRequiredObjects extends Requestable {
  final InputListOfRequiredObjectsVariables variables;

  RequestInputListOfRequiredObjects({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation InputListOfRequiredObjects($items: [MyInputObject!]!) {
  InputListOfRequiredObjects(items: $items) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputListOfRequiredObjects',
    );
  }
}

class InputListOfRequiredObjectsVariables {
  final List<MyInputObject> items;

  InputListOfRequiredObjectsVariables({required this.items});

  JsonObject toJson() {
    JsonObject data = {};

    data["items"] = this.items.map((e) => e.toJson()).toList();

    return data;
  }

  InputListOfRequiredObjectsVariables updateWith({List<MyInputObject>? items}) {
    final List<MyInputObject> items$next;

    if (items != null) {
      items$next = items;
    } else {
      items$next = this.items;
    }

    return InputListOfRequiredObjectsVariables(items: items$next);
  }
}
