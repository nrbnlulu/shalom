import "GlobalObjects.shalom.dart";

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetStringOptional {
  /// class members

  final String? stringOptional;

  // keywordargs constructor

  RequestGetStringOptional({this.stringOptional});
  static RequestGetStringOptional fromJson(JsonObject data) {
    final String? stringOptional_value = data['stringOptional'];

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }

  RequestGetStringOptional updateWithJson(JsonObject data) {
    final String? stringOptional_value;
    if (data.containsKey('stringOptional')) {
      stringOptional_value = data['stringOptional'];
    } else {
      stringOptional_value = stringOptional;
    }

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetStringOptional &&
            other.stringOptional == stringOptional &&
            true);
  }

  @override
  int get hashCode => stringOptional.hashCode;

  JsonObject toJson() {
    return {'stringOptional': stringOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------
