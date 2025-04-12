typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetIDOptional {
  /// class members

  final String? idOptional;

  // keywordargs constructor

  RequestGetIDOptional({this.idOptional});
  static RequestGetIDOptional fromJson(JsonObject data) {
    final String? idOptional_value = data['idOptional'];

    return RequestGetIDOptional(idOptional: idOptional_value);
  }

  RequestGetIDOptional updateWithJson(JsonObject data) {
    final String? idOptional_value;
    if (data.containsKey('idOptional')) {
      idOptional_value = data['idOptional'];
    } else {
      idOptional_value = idOptional;
    }

    return RequestGetIDOptional(idOptional: idOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetIDOptional &&
            other.idOptional == idOptional &&
            true);
  }

  @override
  int get hashCode => idOptional.hashCode;

  JsonObject toJson() {
    return {'idOptional': idOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
