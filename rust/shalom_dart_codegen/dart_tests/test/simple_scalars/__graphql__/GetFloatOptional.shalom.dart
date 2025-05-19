import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetFloatOptionalResponse {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptionalResponse({this.floatOptional});
  static GetFloatOptionalResponse fromJson(JsonObject data) {
    final double? floatOptional_value = data['floatOptional'];

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  GetFloatOptionalResponse updateWithJson(JsonObject data) {
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
      floatOptional_value = data['floatOptional'];
    } else {
      floatOptional_value = floatOptional;
    }

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptionalResponse &&
            other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
  RequestGetFloatOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatOptional {
  floatOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetFloatOptional',
    );
  }
}
