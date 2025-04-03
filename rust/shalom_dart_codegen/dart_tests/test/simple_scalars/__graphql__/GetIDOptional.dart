class RequestGetIDOptional {
  /// class memberes

  final String idOptional;

  // keywordargs constructor

  RequestGetIDOptional({required this.idOptional});

  static RequestGetIDOptional FromJson(Map<String, dynamic> data) {
    final idOptional_value = data['idOptional'] as String;

    return RequestGetIDOptional(idOptional: idOptional_value);
  }
}
