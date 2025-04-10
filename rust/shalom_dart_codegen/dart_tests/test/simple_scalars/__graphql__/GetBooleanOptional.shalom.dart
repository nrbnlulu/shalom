typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetBooleanOptional {
  /// class members

  final bool? booleanOptional;

  // keywordargs constructor

  RequestGetBooleanOptional({this.booleanOptional});
  static RequestGetBooleanOptional fromJson(JsonObject data) {
    final bool? booleanOptional_value = data['booleanOptional'];

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }

  RequestGetBooleanOptional updateWithJson(JsonObject data) {
    final bool? booleanOptional_value;
    if (data.containsKey('booleanOptional')) {
      booleanOptional_value = data['booleanOptional'];
    } else {
      booleanOptional_value = booleanOptional;
    }

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetBooleanOptional &&
            other.booleanOptional == booleanOptional &&
            true);
  }

  @override
  int get hashCode => booleanOptional.hashCode;

  JsonObject toJson() {
    return {'booleanOptional': booleanOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------
