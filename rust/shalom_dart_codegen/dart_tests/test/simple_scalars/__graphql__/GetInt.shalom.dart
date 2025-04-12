typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetInt {
  /// class members

  final int intField;

  // keywordargs constructor

  RequestGetInt({required this.intField});
  static RequestGetInt fromJson(JsonObject data) {
    final int intField_value = data['intField'];

    return RequestGetInt(intField: intField_value);
  }

  RequestGetInt updateWithJson(JsonObject data) {
    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'];
    } else {
      intField_value = intField;
    }

    return RequestGetInt(intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetInt && other.intField == intField && true);
  }

  @override
  int get hashCode => intField.hashCode;

  JsonObject toJson() {
    return {'intField': intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
