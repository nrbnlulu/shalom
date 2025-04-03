class RequestGetBoolean {
  /// class memberes

  final bool boolean;

  // keywordargs constructor

  RequestGetBoolean({required this.boolean});

  static RequestGetBoolean fromJson(Map<String, dynamic> data) {
    final boolean_value = data['boolean'] as bool;

    return RequestGetBoolean(boolean: boolean_value);
  }

  RequestGetBoolean updateWithJson(Map<String, dynamic> data) {
    final boolean_value;
    if (data.containsKey('boolean')) {
      boolean_value = data['boolean'] as bool;
    } else {
      boolean_value = boolean;
    }

    return RequestGetBoolean(boolean: boolean_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetBoolean) return false;

    if (other.boolean != boolean) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'boolean': boolean};
  }
}
