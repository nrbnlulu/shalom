import "GlobalObjects.shalom.dart";

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetMultipleFields {
  /// class members

  final String id;

  final int intField;

  // keywordargs constructor

  RequestGetMultipleFields({required this.id, required this.intField});
  static RequestGetMultipleFields fromJson(JsonObject data) {
    final String id_value = data['id'];

    final int intField_value = data['intField'];

    return RequestGetMultipleFields(id: id_value, intField: intField_value);
  }

  RequestGetMultipleFields updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'];
    } else {
      intField_value = intField;
    }

    return RequestGetMultipleFields(id: id_value, intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetMultipleFields &&
            other.id == id &&
            other.intField == intField &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, intField]);

  JsonObject toJson() {
    return {'id': id, 'intField': intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------
