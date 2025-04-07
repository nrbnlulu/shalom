class RequestGetString {
  final String string;

  RequestGetString({required this.string});

  factory RequestGetString.fromJson(Map<String, dynamic> json) =>
      RequestGetString(string: json['string'] as String);

  RequestGetString updateWithJson(Map<String, dynamic> data) {
    return RequestGetString(
      string:
          data.containsKey('string') ? data['string'] as String : this.string,
    );
  }

  Map<String, dynamic> toJson() => {'string': string};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetString && other.string == string && true);

  @override
  int get hashCode => Object.hashAll([string]);
}
