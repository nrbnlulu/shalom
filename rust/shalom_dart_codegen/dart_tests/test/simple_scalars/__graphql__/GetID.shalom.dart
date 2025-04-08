// ignore_for_file: non_constant_identifier_names

class RequestGetID {
  /// class memberes

  final String id;

  // keywordargs constructor

  RequestGetID({required this.id});

  static RequestGetID fromJson(Map<String, dynamic> data) {
    return RequestGetID(id: data['id'] as String);
  }

  RequestGetID updateWithJson(Map<String, dynamic> data) {
    return RequestGetID(
      id: data.containsKey('id') ? data['id'] as String : this.id,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetID && other.id == id && true);
  }

  @override
  int get hashCode => Object.hashAll([id]);

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
