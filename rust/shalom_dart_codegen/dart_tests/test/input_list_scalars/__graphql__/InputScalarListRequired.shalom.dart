// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputScalarListRequiredResponse {
  /// class members

  final InputScalarListRequired_InputScalarListRequired?
  InputScalarListRequired;

  // keywordargs constructor
  InputScalarListRequiredResponse({this.InputScalarListRequired});
  static InputScalarListRequiredResponse fromJson(JsonObject data) {
    final InputScalarListRequired_InputScalarListRequired?
    InputScalarListRequired_value;

    final JsonObject? InputScalarListRequired$raw =
        data['InputScalarListRequired'];
    if (InputScalarListRequired$raw != null) {
      InputScalarListRequired_value =
          InputScalarListRequired_InputScalarListRequired.fromJson(
            InputScalarListRequired$raw,
          );
    } else {
      InputScalarListRequired_value = null;
    }

    return InputScalarListRequiredResponse(
      InputScalarListRequired: InputScalarListRequired_value,
    );
  }

  InputScalarListRequiredResponse updateWithJson(JsonObject data) {
    final InputScalarListRequired_InputScalarListRequired?
    InputScalarListRequired_value;
    if (data.containsKey('InputScalarListRequired')) {
      final JsonObject? InputScalarListRequired$raw =
          data['InputScalarListRequired'];
      if (InputScalarListRequired$raw != null) {
        InputScalarListRequired_value =
            InputScalarListRequired_InputScalarListRequired.fromJson(
              InputScalarListRequired$raw,
            );
      } else {
        InputScalarListRequired_value = null;
      }
    } else {
      InputScalarListRequired_value = InputScalarListRequired;
    }

    return InputScalarListRequiredResponse(
      InputScalarListRequired: InputScalarListRequired_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarListRequiredResponse &&
            other.InputScalarListRequired == InputScalarListRequired);
  }

  @override
  int get hashCode => InputScalarListRequired.hashCode;

  JsonObject toJson() {
    return {'InputScalarListRequired': InputScalarListRequired?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputScalarListRequired_InputScalarListRequired {
  /// class members

  final bool success;

  // keywordargs constructor
  InputScalarListRequired_InputScalarListRequired({required this.success});
  static InputScalarListRequired_InputScalarListRequired fromJson(
    JsonObject data,
  ) {
    final bool success_value;

    success_value = data['success'];

    return InputScalarListRequired_InputScalarListRequired(
      success: success_value,
    );
  }

  InputScalarListRequired_InputScalarListRequired updateWithJson(
    JsonObject data,
  ) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return InputScalarListRequired_InputScalarListRequired(
      success: success_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputScalarListRequired_InputScalarListRequired &&
            other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputScalarListRequired extends Requestable {
  final InputScalarListRequiredVariables variables;

  RequestInputScalarListRequired({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputScalarListRequired($strings: [String!]!) {
  InputScalarListRequired(strings: $strings) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'InputScalarListRequired',
    );
  }
}

class InputScalarListRequiredVariables {
  final List<String> strings;

  InputScalarListRequiredVariables({required this.strings});

  JsonObject toJson() {
    JsonObject data = {};

    data["strings"] = this.strings;

    return data;
  }

  InputScalarListRequiredVariables updateWith({List<String>? strings}) {
    final List<String> strings$next;

    if (strings != null) {
      strings$next = strings;
    } else {
      strings$next = this.strings;
    }

    return InputScalarListRequiredVariables(strings: strings$next);
  }
}
