class RequestGetBoolean {
  /// class memberes

  final bool boolean;

  // keywordargs constructor

  RequestGetBoolean({required this.boolean});

  static RequestGetBoolean FromJson(Map<String, dynamic> data) {
    final boolean_value = data['boolean'] as bool;

    return RequestGetBoolean(boolean: boolean_value);
  }
}
