// ignore_for_file: non_constant_identifier_names

class RequestGetMultipleFields {
  /// class memberes

  final String id;

  final int intField;

  // keywordargs constructor

  RequestGetMultipleFields({required this.id, required this.intField});
  static RequestGetMultipleFields fromJson(Map<String, dynamic> data) {
    final String id_value = data['id'];

    final int intField_value = data['intField'];

    return RequestGetMultipleFields(id: id_value, intField: intField_value);
  }

  RequestGetMultipleFields updateWithJson(Map<String, dynamic> data) {
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

  Map<String, dynamic> toJson() {
    return {'id': id, 'intField': intField};
  }
}
