// ignore_for_file: non_constant_identifier_names

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
    final bool boolean_value;
    if (data.containsKey('boolean')) {
      boolean_value = data['boolean'] as bool;
    } else {
      boolean_value = boolean;
    }

    return RequestGetBoolean(boolean: boolean_value);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RequestGetBoolean) return false;

    if (other.boolean != boolean) return false;

    return true;
  }

  @override
  int get hashCode => boolean.hashCode;

  Map<String, dynamic> toJson() {
    return {'boolean': boolean};
  }
}
