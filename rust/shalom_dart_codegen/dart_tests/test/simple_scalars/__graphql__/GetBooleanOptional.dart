class RequestGetBooleanOptional {
  /// class memberes

  final bool? booleanOptional;

  // keywordargs constructor

  RequestGetBooleanOptional({required this.booleanOptional});

  static RequestGetBooleanOptional FromJson(Map<String, dynamic> data) {
    final booleanOptional_value = data['booleanOptional'] as bool?;

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }
}
