// ignore_for_file: non_constant_identifier_names

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
    final String string_value;
    if (data.containsKey('string')) {
      string_value = data['string'] as String;
    } else {
      string_value = string;
    }

    return RequestGetString(string: string_value);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RequestGetString) return false;

    if (other.string != string) return false;

    return true;
  }

  @override
  int get hashCode => string.hashCode;

  Map<String, dynamic> toJson() {
    return {'string': string};
  }
}
