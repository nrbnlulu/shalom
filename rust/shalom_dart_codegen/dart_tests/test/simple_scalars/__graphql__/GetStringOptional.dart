class RequestGetStringOptional {
  /// class memberes

  final String? stringOptional;

  // keywordargs constructor

  RequestGetStringOptional({required this.stringOptional});

  static RequestGetStringOptional fromJson(Map<String, dynamic> data) {
    final stringOptional_value = data['stringOptional'] as String?;

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }

  RequestGetStringOptional updateWithJson(Map<String, dynamic> data) {
    final stringOptional_value;
    if (data.containsKey('stringOptional')) {
      stringOptional_value = data['stringOptional'] as String?;
    } else {
      stringOptional_value = stringOptional;
    }

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetStringOptional) return false;

    if (other.stringOptional != stringOptional) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'stringOptional': stringOptional};
  }
}
