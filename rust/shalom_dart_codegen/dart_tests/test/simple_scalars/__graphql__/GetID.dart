class RequestGetID {
  /// class memberes

  final String id;

  // keywordargs constructor

  RequestGetID({required this.id});

  static RequestGetID FromJson(Map<String, dynamic> data) {
    final id_value = data['id'] as String;

    return RequestGetID(id: id_value);
  }
}
