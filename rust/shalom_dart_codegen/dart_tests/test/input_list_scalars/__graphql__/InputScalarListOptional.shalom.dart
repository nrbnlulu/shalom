// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputScalarListOptionalResponse {
  /// class members

  final InputScalarListOptional_InputScalarListOptional?
  InputScalarListOptional;

  // keywordargs constructor
  InputScalarListOptionalResponse({this.InputScalarListOptional});
  static InputScalarListOptionalResponse fromJson(JsonObject data) {
    final InputScalarListOptional_InputScalarListOptional?
    InputScalarListOptional_value;

    final JsonObject? InputScalarListOptional$raw =
        data['InputScalarListOptional'];
    if (InputScalarListOptional$raw != null) {
      InputScalarListOptional_value =
          InputScalarListOptional_InputScalarListOptional.fromJson(
            InputScalarListOptional$raw,
          );
    } else {
      InputScalarListOptional_value = null;
    }

    return InputScalarListOptionalResponse(
      InputScalarListOptional: InputScalarListOptional_value,
    );
  }

  InputScalarListOptionalResponse updateWithJson(JsonObject data) {
    final InputScalarListOptional_InputScalarListOptional?
    InputScalarListOptional_value;
    if (data.containsKey('InputScalarListOptional')) {
      final JsonObject? InputScalarListOptional$raw =
          data['InputScalarListOptional'];
      if (InputScalarListOptional$raw != null) {
        InputScalarListOptional_value =
            InputScalarListOptional_InputScalarListOptional.fromJson(
              InputScalarListOptional$raw,
            );
      } else {
        InputScalarListOptional_value = null;
      }
    } else {
      InputScalarListOptional_value = InputScalarListOptional;
    }

    return InputScalarListOptionalResponse(
      InputScalarListOptional: InputScalarListOptional_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarListOptionalResponse &&
            other.InputScalarListOptional == InputScalarListOptional);
  }

  @override
  int get hashCode => InputScalarListOptional.hashCode;

  JsonObject toJson() {
    return {'InputScalarListOptional': InputScalarListOptional?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputScalarListOptional_InputScalarListOptional {
  /// class members

  final bool success;

  // keywordargs constructor
  InputScalarListOptional_InputScalarListOptional({required this.success});
  static InputScalarListOptional_InputScalarListOptional fromJson(
    JsonObject data,
  ) {
    final bool success_value;

    success_value = data['success'];

    return InputScalarListOptional_InputScalarListOptional(
      success: success_value,
    );
  }

  InputScalarListOptional_InputScalarListOptional updateWithJson(
    JsonObject data,
  ) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return InputScalarListOptional_InputScalarListOptional(
      success: success_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarListOptional_InputScalarListOptional &&
            other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputScalarListOptional extends Requestable {
  final InputScalarListOptionalVariables variables;

  RequestInputScalarListOptional({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputScalarListOptional($names: [String]) {
  InputScalarListOptional(names: $names) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputScalarListOptional',
    );
  }
}

class InputScalarListOptionalVariables {
  final Option<List<String?>?> names;

  InputScalarListOptionalVariables({this.names = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (names.isSome()) {
      final value = names.some();

      data["names"] = value;
    }

    return data;
  }

  InputScalarListOptionalVariables updateWith({
    Option<Option<List<String?>?>> names = const None(),
  }) {
    final Option<List<String?>?> names$next;

    switch (names) {
      case Some(value: final data):
        names$next = data;
      case None():
        names$next = this.names;
    }

    return InputScalarListOptionalVariables(names: names$next);
  }
}
