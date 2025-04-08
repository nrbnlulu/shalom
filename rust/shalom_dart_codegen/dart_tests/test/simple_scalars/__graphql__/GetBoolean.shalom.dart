// ignore_for_file: non_constant_identifier_names

class RequestGetBoolean {
  /// class memberes

  final bool boolean;

  // keywordargs constructor

  RequestGetBoolean({required this.boolean});

  static RequestGetBoolean fromJson(Map<String, dynamic> data) {
    return RequestGetBoolean(boolean: data['boolean'] as bool);
  }

  RequestGetBoolean updateWithJson(Map<String, dynamic> data) {
    return RequestGetBoolean(
      boolean:
          data.containsKey('boolean') ? data['boolean'] as bool : this.boolean,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetBoolean && other.boolean == boolean && true);
  }

  @override
  int get hashCode => Object.hashAll([boolean]);

  Map<String, dynamic> toJson() {
    return {'boolean': boolean};
  }
}
