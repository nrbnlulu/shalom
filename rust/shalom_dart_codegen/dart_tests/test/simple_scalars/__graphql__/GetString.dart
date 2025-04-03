class RequestGetString {
  /// class memberes

  final String string;

  // keywordargs constructor

  RequestGetString({required this.string});

  static RequestGetString fromJson(Map<String, dynamic> data) {
    final string_value = data['string'] as String;

    return RequestGetString(string: string_value);
  }

  RequestGetString updateWithJson(Map<String, dynamic> data) {
    final string_value;
    if (data.containsKey('string')) {
      string_value = data['string'] as String;
    } else {
      string_value = string;
    }

    return RequestGetString(string: string_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetString) return false;

    if (other.string != string) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'string': string};
  }
}
