typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetFloatOptional {
  /// class members

  final double? floatOptional;

  // keywordargs constructor

  RequestGetFloatOptional({this.floatOptional});
  static RequestGetFloatOptional fromJson(JsonObject data) {
    final double? floatOptional_value = data['floatOptional'];

    return RequestGetFloatOptional(floatOptional: floatOptional_value);
  }

  RequestGetFloatOptional updateWithJson(JsonObject data) {
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
      floatOptional_value = data['floatOptional'];
    } else {
      floatOptional_value = floatOptional;
    }

    return RequestGetFloatOptional(floatOptional: floatOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetFloatOptional &&
            other.floatOptional == floatOptional &&
            true);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------
