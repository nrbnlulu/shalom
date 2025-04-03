class RequestGetIntOptional {
  /// class memberes

  final int? intOptional;

  // keywordargs constructor

  RequestGetIntOptional({required this.intOptional});

  static RequestGetIntOptional fromJson(Map<String, dynamic> data) {
    final intOptional_value = data['intOptional'] as int?;

    return RequestGetIntOptional(intOptional: intOptional_value);
  }

  RequestGetIntOptional updateWithJson(Map<String, dynamic> data) {
    final intOptional_value;
    if (data.containsKey('intOptional')) {
      intOptional_value = data['intOptional'] as int?;
    } else {
      intOptional_value = intOptional;
    }

    return RequestGetIntOptional(intOptional: intOptional_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetIntOptional) return false;

    if (other.intOptional != intOptional) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'intOptional': intOptional};
  }
}
