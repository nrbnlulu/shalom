// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class InputCustomScalarListOptionalWithDefaultResponse {
  /// class members

  final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault?
  InputCustomScalarListOptionalWithDefault;

  // keywordargs constructor
  InputCustomScalarListOptionalWithDefaultResponse({
    this.InputCustomScalarListOptionalWithDefault,
  });
  static InputCustomScalarListOptionalWithDefaultResponse fromJson(
    JsonObject data,
  ) {
    final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault?
    InputCustomScalarListOptionalWithDefault_value;
    final InputCustomScalarListOptionalWithDefault$raw =
        data["InputCustomScalarListOptionalWithDefault"];
    InputCustomScalarListOptionalWithDefault_value =
        InputCustomScalarListOptionalWithDefault$raw == null
            ? null
            : InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault.fromJson(
              InputCustomScalarListOptionalWithDefault$raw,
            );

    return InputCustomScalarListOptionalWithDefaultResponse(
      InputCustomScalarListOptionalWithDefault:
          InputCustomScalarListOptionalWithDefault_value,
    );
  }

  InputCustomScalarListOptionalWithDefaultResponse updateWithJson(
    JsonObject data,
  ) {
    final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault?
    InputCustomScalarListOptionalWithDefault_value;
    if (data.containsKey('InputCustomScalarListOptionalWithDefault')) {
      final InputCustomScalarListOptionalWithDefault$raw =
          data["InputCustomScalarListOptionalWithDefault"];
      InputCustomScalarListOptionalWithDefault_value =
          InputCustomScalarListOptionalWithDefault$raw == null
              ? null
              : InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault.fromJson(
                InputCustomScalarListOptionalWithDefault$raw,
              );
    } else {
      InputCustomScalarListOptionalWithDefault_value =
          InputCustomScalarListOptionalWithDefault;
    }

    return InputCustomScalarListOptionalWithDefaultResponse(
      InputCustomScalarListOptionalWithDefault:
          InputCustomScalarListOptionalWithDefault_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InputCustomScalarListOptionalWithDefaultResponse &&
            other.InputCustomScalarListOptionalWithDefault ==
                InputCustomScalarListOptionalWithDefault);
  }

  @override
  int get hashCode => InputCustomScalarListOptionalWithDefault.hashCode;

  JsonObject toJson() {
    return {
      'InputCustomScalarListOptionalWithDefault':
          this.InputCustomScalarListOptionalWithDefault?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault {
  /// class members

  final bool success;

  final String? message;

  // keywordargs constructor
  InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault({
    required this.success,

    this.message,
  });
  static InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault
  fromJson(JsonObject data) {
    final bool success_value;
    final success$raw = data["success"];
    success_value = success$raw as bool;

    final String? message_value;
    final message$raw = data["message"];
    message_value = message$raw as String?;

    return InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault(
      success: success_value,

      message: message_value,
    );
  }

  InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault
  updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      final success$raw = data["success"];
      success_value = success$raw as bool;
    } else {
      success_value = success;
    }

    final String? message_value;
    if (data.containsKey('message')) {
      final message$raw = data["message"];
      message_value = message$raw as String?;
    } else {
      message_value = message;
    }

    return InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault(
      success: success_value,

      message: message_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other
                is InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault &&
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

class RequestInputCustomScalarListOptionalWithDefault extends Requestable {
  final InputCustomScalarListOptionalWithDefaultVariables variables;

  RequestInputCustomScalarListOptionalWithDefault({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation InputCustomScalarListOptionalWithDefault($defaultItems: [Point!] = null) {
  InputCustomScalarListOptionalWithDefault(defaultItems: $defaultItems) {
    success
    message
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'InputCustomScalarListOptionalWithDefault',
    );
  }
}

class InputCustomScalarListOptionalWithDefaultVariables {
  final List<rmhlxei.Point>? defaultItems;

  InputCustomScalarListOptionalWithDefaultVariables({this.defaultItems});

  JsonObject toJson() {
    JsonObject data = {};

    data["defaultItems"] =
        this.defaultItems
            ?.map((e) => rmhlxei.pointScalarImpl.serialize(e))
            .toList();

    return data;
  }

  InputCustomScalarListOptionalWithDefaultVariables updateWith({
    Option<List<rmhlxei.Point>?> defaultItems = const None(),
  }) {
    final List<rmhlxei.Point>? defaultItems$next;

    switch (defaultItems) {
      case Some(value: final updateData):
        defaultItems$next = updateData;
      case None():
        defaultItems$next = this.defaultItems;
    }

    return InputCustomScalarListOptionalWithDefaultVariables(
      defaultItems: defaultItems$next,
    );
  }
}
