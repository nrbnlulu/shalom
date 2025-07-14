// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListEnumRequiredResponse {
  /// class members

  final String? InputListEnumRequired;

  // keywordargs constructor
  InputListEnumRequiredResponse({this.InputListEnumRequired});
  static InputListEnumRequiredResponse fromJson(JsonObject data) {
    final String? InputListEnumRequired_value;
    final InputListEnumRequired$raw = data["InputListEnumRequired"];
    InputListEnumRequired_value = InputListEnumRequired$raw as String?;

    return InputListEnumRequiredResponse(
      InputListEnumRequired: InputListEnumRequired_value,
    );
  }

  static InputListEnumRequiredResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = InputListEnumRequiredResponse.fromJson(data);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListEnumRequiredResponse &&
            other.InputListEnumRequired == InputListEnumRequired);
  }

  @override
  int get hashCode => InputListEnumRequired.hashCode;

  JsonObject toJson() {
    return {'InputListEnumRequired': this.InputListEnumRequired};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputListEnumRequired extends Requestable {
  final InputListEnumRequiredVariables variables;

  RequestInputListEnumRequired({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputListEnumRequired($foo: [Gender!]!) {
  InputListEnumRequired(foo: $foo)
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'InputListEnumRequired',
    );
  }
}

class InputListEnumRequiredVariables {
  final List<Gender> foo;

  InputListEnumRequiredVariables({required this.foo});

  JsonObject toJson() {
    JsonObject data = {};

    data["foo"] = this.foo.map((e) => e.name).toList();

    return data;
  }

  InputListEnumRequiredVariables updateWith({List<Gender>? foo}) {
    final List<Gender> foo$next;

    if (foo != null) {
      foo$next = foo;
    } else {
      foo$next = this.foo;
    }

    return InputListEnumRequiredVariables(foo: foo$next);
  }
}
