class RequestGetInt {
  /// class memberes

  final int intField;

  // keywordargs constructor

  RequestGetInt({required this.intField});

  static RequestGetInt fromJson(Map<String, dynamic> data) {
    final intField_value = data['intField'] as int;

    return RequestGetInt(intField: intField_value);
  }

  RequestGetInt updateWithJson(Map<String, dynamic> data) {
    final intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'] as int;
    } else {
      intField_value = intField;
    }

    return RequestGetInt(intField: intField_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetInt) return false;

    if (other.intField != intField) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'intField': intField};
  }
}
