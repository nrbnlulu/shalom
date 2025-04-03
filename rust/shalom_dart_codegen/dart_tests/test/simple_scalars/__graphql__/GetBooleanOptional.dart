class RequestGetBooleanOptional {
  /// class memberes

  final bool? booleanOptional;

  // keywordargs constructor

  RequestGetBooleanOptional({required this.booleanOptional});

  static RequestGetBooleanOptional fromJson(Map<String, dynamic> data) {
    final booleanOptional_value = data['booleanOptional'] as bool?;

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }

  RequestGetBooleanOptional updateWithJson(Map<String, dynamic> data) {
    final booleanOptional_value;
    if (data.containsKey('booleanOptional')) {
      booleanOptional_value = data['booleanOptional'] as bool?;
    } else {
      booleanOptional_value = booleanOptional;
    }

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetBooleanOptional) return false;

    if (other.booleanOptional != booleanOptional) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'booleanOptional': booleanOptional};
  }
}
