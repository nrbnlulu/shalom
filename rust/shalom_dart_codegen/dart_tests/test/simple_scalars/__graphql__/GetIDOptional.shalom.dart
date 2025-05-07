import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetIDOptionalResponse {
  /// class members

  final String? idOptional;

  // keywordargs constructor
  GetIDOptionalResponse({this.idOptional});
  static GetIDOptionalResponse fromJson(JsonObject data) {
    final String? idOptional_value = data['idOptional'];

    return GetIDOptionalResponse(idOptional: idOptional_value);
  }

  GetIDOptionalResponse updateWithJson(JsonObject data) {
    final String? idOptional_value;
    if (data.containsKey('idOptional')) {
      idOptional_value = data['idOptional'];
    } else {
      idOptional_value = idOptional;
    }

    return GetIDOptionalResponse(idOptional: idOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIDOptionalResponse && other.idOptional == idOptional);
  }

  @override
  int get hashCode => idOptional.hashCode;

  JsonObject toJson() {
    return {'idOptional': idOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIDOptional extends Requestable {
  final GetIDOptionalVariables variables;

  RequestGetIDOptional({required this.variables});

  @override
  Request toRequest() {
    return Request(
      query: r"""query GetIDOptional {
  idOptional
}""",
      variables: variables.toJson(),
      opType: OperationType.Query,
      StringopName: 'GetIDOptional',
    );
  }
}

class GetIDOptionalVariables {
  GetIDOptionalVariables();

  JsonObject toJson() {
    JsonObject data = {};

    return data;
  }

  static GetIDOptionalVariables fromJson(JsonObject data) {
    return GetIDOptionalVariables();
  }
}
