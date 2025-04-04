// ignore_for_file: non_constant_identifier_names

class RequestGetID {
  /// class memberes

  final String id;

  // keywordargs constructor

  RequestGetID({required this.id});

  static RequestGetID fromJson(Map<String, dynamic> data) {
    final id_value = data['id'] as String;

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
    if (other is! RequestGetID) return false;

    if (other.id != id) return false;

    return true;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
