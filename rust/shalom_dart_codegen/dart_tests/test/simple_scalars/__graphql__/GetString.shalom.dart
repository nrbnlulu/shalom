typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetString {
  /// class members

  final String string;

  // keywordargs constructor

  RequestGetString({required this.string});
  static RequestGetString fromJson(JsonObject data) {
    final String string_value = data['string'];

    return RequestGetString(string: string_value);
  }

  RequestGetString updateWithJson(JsonObject data) {
    final String string_value;
    if (data.containsKey('string')) {
      string_value = data['string'];
    } else {
      string_value = string;
    }

    return RequestGetString(string: string_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetString && other.string == string && true);
  }

  @override
  int get hashCode => string.hashCode;

  JsonObject toJson() {
    return {'string': string};
  }
}

// ------------ OBJECT DEFINITIONS -------------
