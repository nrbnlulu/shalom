// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListEnumMaybeResponse {
  /// class members

  String? InputListEnumMaybe;

  // keywordargs constructor
  InputListEnumMaybeResponse({this.InputListEnumMaybe});
  static InputListEnumMaybeResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String? InputListEnumMaybe_value;
    final InputListEnumMaybe$raw = data["InputListEnumMaybe"];

    InputListEnumMaybe_value = InputListEnumMaybe$raw as String?;

    return InputListEnumMaybeResponse(
      InputListEnumMaybe: InputListEnumMaybe_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListEnumMaybeResponse &&
            other.InputListEnumMaybe == InputListEnumMaybe);
  }

  @override
  int get hashCode => InputListEnumMaybe.hashCode;

  JsonObject toJson() {
    return {'InputListEnumMaybe': this.InputListEnumMaybe};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputListEnumMaybe extends Requestable {
  final InputListEnumMaybeVariables variables;

  RequestInputListEnumMaybe({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation InputListEnumMaybe($foo: [Gender!]) {
  InputListEnumMaybe(foo: $foo)
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'InputListEnumMaybe',
    );
  }
}

class InputListEnumMaybeVariables {
  final Option<List<Gender>?> foo;

  InputListEnumMaybeVariables({this.foo = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (foo.isSome()) {
      final value = this.foo.some();
      data["foo"] = value?.map((e) => e.name).toList();
    }

    return data;
  }

  InputListEnumMaybeVariables updateWith({
    Option<Option<List<Gender>?>> foo = const None(),
  }) {
    final Option<List<Gender>?> foo$next;

    switch (foo) {
      case Some(value: final updateData):
        foo$next = updateData;
      case None():
        foo$next = this.foo;
    }

    return InputListEnumMaybeVariables(foo: foo$next);
  }
}
