class RequestGetString {
  /// class memberes

  final String string;

  // keywordargs constructor

  RequestGetString({required this.string});

  static RequestGetString FromJson(Map<String, dynamic> data) {
    final string_value = data['string'] as String;

    return RequestGetString(string: string_value);
  }
}
