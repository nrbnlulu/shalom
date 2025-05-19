import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetIntResponse {
  /// class members

  final int intField;

  // keywordargs constructor
  GetIntResponse({required this.intField});
  static GetIntResponse fromJson(JsonObject data) {
    final int intField_value = data['intField'];

    return GetIntResponse(intField: intField_value);
  }

  GetIntResponse updateWithJson(JsonObject data) {
    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'];
    } else {
      intField_value = intField;
    }

    return GetIntResponse(intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntResponse && other.intField == intField);
  }

  @override
  int get hashCode => intField.hashCode;

  JsonObject toJson() {
    return {'intField': intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetInt extends Requestable {
  RequestGetInt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetInt {
  intField
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetInt',
    );
  }
}
