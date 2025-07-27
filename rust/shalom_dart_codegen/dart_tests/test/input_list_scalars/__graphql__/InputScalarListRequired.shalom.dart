// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputScalarListRequiredResponse {
  /// class members

  final InputScalarListRequired_InputScalarListRequired?
  InputScalarListRequired;

  // keywordargs constructor
  InputScalarListRequiredResponse({this.InputScalarListRequired});
  static InputScalarListRequiredResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final InputScalarListRequired_InputScalarListRequired?
    InputScalarListRequired_value;
    final InputScalarListRequired$raw = data["InputScalarListRequired"];
    InputScalarListRequired_value =
        InputScalarListRequired$raw == null
            ? null
            : InputScalarListRequired_InputScalarListRequired.fromJson(
              InputScalarListRequired$raw,
              context,
            );

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
    return {'InputScalarListRequired': this.InputScalarListRequired?.toJson()};
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
    ShalomContext? context,
  ) {
    final bool success_value;
    final success$raw = data["success"];
    success_value = success$raw as bool;

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
    return {'success': this.success};
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
      opName: 'InputScalarListRequired',
    );
  }
}

class InputScalarListRequiredVariables {
  final List<String> strings;

  InputScalarListRequiredVariables({required this.strings});

  JsonObject toJson() {
    JsonObject data = {};

    data["strings"] = this.strings.map((e) => e).toList();

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
