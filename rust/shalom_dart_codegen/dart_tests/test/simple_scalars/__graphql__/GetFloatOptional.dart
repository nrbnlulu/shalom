class RequestGetFloatOptional {
  /// class memberes

  final double floatOptional;

  // keywordargs constructor

  RequestGetFloatOptional({required this.floatOptional});

  static RequestGetFloatOptional FromJson(Map<String, dynamic> data) {
    final floatOptional_value = data['floatOptional'] as double;

    return RequestGetFloatOptional(floatOptional: floatOptional_value);
  }
}
