// ignore_for_file: non_constant_identifier_names

class RequestGetFloatOptional {
  /// class memberes

  final double? floatOptional;

  // keywordargs constructor

  RequestGetFloatOptional({this.floatOptional});
  static RequestGetFloatOptional fromJson(Map<String, dynamic> data) {
    final double? floatOptional_value;
    floatOptional_value = data['floatOptional'] as double?;

    return RequestGetFloatOptional(floatOptional: floatOptional_value);
  }

  RequestGetFloatOptional updateWithJson(Map<String, dynamic> data) {
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
      floatOptional_value = data['floatOptional'] as double?;
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

  Map<String, dynamic> toJson() {
    return {'floatOptional': floatOptional};
  }
}
