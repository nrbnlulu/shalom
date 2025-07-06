// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListEnumMaybeResponse {
  /// class members

  final String? InputListEnumMaybe;

  // keywordargs constructor
  InputListEnumMaybeResponse({this.InputListEnumMaybe});
  static InputListEnumMaybeResponse fromJson(JsonObject data) {
    final String? InputListEnumMaybe_value;

    InputListEnumMaybe_value = data['InputListEnumMaybe'];

    return InputListEnumMaybeResponse(
      InputListEnumMaybe: InputListEnumMaybe_value,
    );
  }

  InputListEnumMaybeResponse updateWithJson(JsonObject data) {
    final String? InputListEnumMaybe_value;
    if (data.containsKey('InputListEnumMaybe')) {
      InputListEnumMaybe_value = data['InputListEnumMaybe'];
    } else {
      InputListEnumMaybe_value = InputListEnumMaybe;
    }

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
    return {'InputListEnumMaybe': InputListEnumMaybe};
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
      StringopName: 'InputListEnumMaybe',
    );
  }
}

class InputListEnumMaybeVariables {
  final Option<List<Gender>?> foo;

  InputListEnumMaybeVariables({this.foo = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (foo.isSome()) {
      final value = foo.some();

      data["foo"] = value?.map((e) => e.name).toList();
    }

    return data;
  }

  InputListEnumMaybeVariables updateWith({
    Option<Option<List<Gender>?>> foo = const None(),
  }) {
    final Option<List<Gender>?> foo$next;

    switch (foo) {
      case Some(value: final data):
        foo$next = data;
      case None():
        foo$next = this.foo;
    }

    return InputListEnumMaybeVariables(foo: foo$next);
  }
}
