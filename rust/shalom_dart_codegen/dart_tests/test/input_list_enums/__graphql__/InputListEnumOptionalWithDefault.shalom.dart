// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputListEnumOptionalWithDefaultResponse {
  /// class members

  final String? InputListEnumOptionalWithDefault;

  // keywordargs constructor
  InputListEnumOptionalWithDefaultResponse({
    this.InputListEnumOptionalWithDefault,
  });

  InputListEnumOptionalWithDefaultResponse updateWithJson(JsonObject data) {
    final String? InputListEnumOptionalWithDefault_value;
    if (data.containsKey('InputListEnumOptionalWithDefault')) {
      final InputListEnumOptionalWithDefault$raw =
          data["InputListEnumOptionalWithDefault"];
      InputListEnumOptionalWithDefault_value =
          InputListEnumOptionalWithDefault$raw as String?;
    } else {
      InputListEnumOptionalWithDefault_value = InputListEnumOptionalWithDefault;
    }

    return InputListEnumOptionalWithDefaultResponse(
      InputListEnumOptionalWithDefault: InputListEnumOptionalWithDefault_value,
    );
  }

  static InputListEnumOptionalWithDefaultResponse fromJson(JsonObject data) {
    final String? InputListEnumOptionalWithDefault_value;
    final InputListEnumOptionalWithDefault$raw =
        data["InputListEnumOptionalWithDefault"];
    InputListEnumOptionalWithDefault_value =
        InputListEnumOptionalWithDefault$raw as String?;

    return InputListEnumOptionalWithDefaultResponse(
      InputListEnumOptionalWithDefault: InputListEnumOptionalWithDefault_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputListEnumOptionalWithDefaultResponse &&
            other.InputListEnumOptionalWithDefault ==
                InputListEnumOptionalWithDefault);
  }

  @override
  int get hashCode => InputListEnumOptionalWithDefault.hashCode;

  JsonObject toJson() {
    return {
      'InputListEnumOptionalWithDefault': this.InputListEnumOptionalWithDefault,
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestInputListEnumOptionalWithDefault extends Requestable {
  final InputListEnumOptionalWithDefaultVariables variables;

  RequestInputListEnumOptionalWithDefault({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation InputListEnumOptionalWithDefault($foo: [Gender!] = null) {
  InputListEnumOptionalWithDefault(foo: $foo)
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'InputListEnumOptionalWithDefault',
    );
  }
}

class InputListEnumOptionalWithDefaultVariables {
  final List<Gender>? foo;

  InputListEnumOptionalWithDefaultVariables({this.foo});

  JsonObject toJson() {
    JsonObject data = {};

    data["foo"] = this.foo?.map((e) => e.name).toList();

    return data;
  }

  InputListEnumOptionalWithDefaultVariables updateWith({
    Option<List<Gender>?> foo = const None(),
  }) {
    final List<Gender>? foo$next;

    switch (foo) {
      case Some(value: final updateData):
        foo$next = updateData;
      case None():
        foo$next = this.foo;
    }

    return InputListEnumOptionalWithDefaultVariables(foo: foo$next);
  }
}
