typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetBoolean {
  /// class members

  final bool boolean;

  // keywordargs constructor

  RequestGetBoolean({required this.boolean});
  static RequestGetBoolean fromJson(JsonObject data) {
    final bool boolean_value = data['boolean'];

    return RequestGetBoolean(boolean: boolean_value);
  }

  RequestGetBoolean updateWithJson(JsonObject data) {
    final bool boolean_value;
    if (data.containsKey('boolean')) {
      boolean_value = data['boolean'];
    } else {
      boolean_value = boolean;
    }

    return RequestGetBoolean(boolean: boolean_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetBoolean && other.boolean == boolean && true);
  }

  @override
  int get hashCode => boolean.hashCode;

  JsonObject toJson() {
    return {'boolean': boolean};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------
