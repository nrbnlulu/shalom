class RequestGetFloatOptional {
  /// class memberes

  final double floatOptional;

  // keywordargs constructor

  RequestGetFloatOptional({required this.floatOptional});

  static RequestGetFloatOptional fromJson(Map<String, dynamic> data) {
    final floatOptional_value = data['floatOptional'] as double;

    return RequestGetFloatOptional(floatOptional: floatOptional_value);
  }

  RequestGetFloatOptional updateWithJson(Map<String, dynamic> data) {
    final floatOptional_value;
    if (data.containsKey('floatOptional')) {
      floatOptional_value = data['floatOptional'] as double;
    } else {
      floatOptional_value = floatOptional;
    }

    return RequestGetFloatOptional(floatOptional: floatOptional_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetFloatOptional) return false;

    if (other.floatOptional != floatOptional) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'floatOptional': floatOptional};
  }
}
