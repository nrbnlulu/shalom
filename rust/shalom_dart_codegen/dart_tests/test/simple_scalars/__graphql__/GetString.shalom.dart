// ignore_for_file: non_constant_identifier_names

class RequestGetString {
  /// class memberes

  final String string;

  // keywordargs constructor

  RequestGetString({required this.string});

  static RequestGetString fromJson(Map<String, dynamic> data) {
    return RequestGetString(string: data['string'] as String);
  }

  RequestGetString updateWithJson(Map<String, dynamic> data) {
    return RequestGetString(
      string:
          data.containsKey('string') ? data['string'] as String : this.string,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetString && other.string == string && true);
  }

  @override
  int get hashCode => Object.hashAll([string]);

  Map<String, dynamic> toJson() {
    return {'string': string};
  }
}
