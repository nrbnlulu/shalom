class RequestGetStringOptional {
  /// class memberes

  final String? stringOptional;

  // keywordargs constructor

  RequestGetStringOptional({required this.stringOptional});

  static RequestGetStringOptional FromJson(Map<String, dynamic> data) {
    final stringOptional_value = data['stringOptional'] as String?;

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }
}
