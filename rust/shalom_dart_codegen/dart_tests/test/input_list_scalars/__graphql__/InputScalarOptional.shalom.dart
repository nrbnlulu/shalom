// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputScalarOptionalResponse {
  /// class members

  final InputScalarOptional_inputScalarOptional? inputScalarOptional;

  // keywordargs constructor
  InputScalarOptionalResponse({this.inputScalarOptional});
  static InputScalarOptionalResponse fromJson(JsonObject data) {
    final InputScalarOptional_inputScalarOptional? inputScalarOptional_value;

    final JsonObject? inputScalarOptional$raw = data['inputScalarOptional'];
    if (inputScalarOptional$raw != null) {
      inputScalarOptional_value =
          InputScalarOptional_inputScalarOptional.fromJson(
            inputScalarOptional$raw,
          );
    } else {
      inputScalarOptional_value = null;
    }

    return InputScalarOptionalResponse(
      inputScalarOptional: inputScalarOptional_value,
    );
  }

  InputScalarOptionalResponse updateWithJson(JsonObject data) {
    final InputScalarOptional_inputScalarOptional? inputScalarOptional_value;
    if (data.containsKey('inputScalarOptional')) {
      final JsonObject? inputScalarOptional$raw = data['inputScalarOptional'];
      if (inputScalarOptional$raw != null) {
        inputScalarOptional_value =
            InputScalarOptional_inputScalarOptional.fromJson(
              inputScalarOptional$raw,
            );
      } else {
        inputScalarOptional_value = null;
      }
    } else {
      inputScalarOptional_value = inputScalarOptional;
    }

    return InputScalarOptionalResponse(
      inputScalarOptional: inputScalarOptional_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarOptionalResponse &&
            other.inputScalarOptional == inputScalarOptional);
  }

  @override
  int get hashCode => inputScalarOptional.hashCode;

  JsonObject toJson() {
    return {'inputScalarOptional': inputScalarOptional?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputScalarOptional_inputScalarOptional {
  /// class members

  final bool success;

  // keywordargs constructor
  InputScalarOptional_inputScalarOptional({required this.success});
  static InputScalarOptional_inputScalarOptional fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return InputScalarOptional_inputScalarOptional(success: success_value);
  }

  InputScalarOptional_inputScalarOptional updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return InputScalarOptional_inputScalarOptional(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarOptional_inputScalarOptional &&
            other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputScalarOptional extends Requestable {
  final InputScalarOptionalVariables variables;

  RequestInputScalarOptional({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputScalarOptional($name: String) {
  inputScalarOptional(name: $name) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputScalarOptional',
    );
  }
}

class InputScalarOptionalVariables {
  final Option<String?> name;

  InputScalarOptionalVariables({this.name = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (name.isSome()) {
      final value = name.some();

      data["name"] = value;
    }

    return data;
  }

  InputScalarOptionalVariables updateWith({
    Option<Option<String?>> name = const None(),
  }) {
    final Option<String?> name$next;

    switch (name) {
      case Some(value: final data):
        name$next = data;
      case None():
        name$next = this.name;
    }

    return InputScalarOptionalVariables(name: name$next);
  }
}
