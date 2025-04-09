// ignore_for_file: non_constant_identifier_names

class RequestGetID {
  /// class memberes

  final String id;

  // keywordargs constructor

  RequestGetID({required this.id});
  static RequestGetID fromJson(Map<String, dynamic> data) {
    final String id_value;
    id_value = data['id'] as String;

    return RequestGetID(id: id_value);
  }

  RequestGetID updateWithJson(Map<String, dynamic> data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'] as String;
    } else {
      id_value = id;
    }

    return RequestGetID(id: id_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetID && other.id == id && true);
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
