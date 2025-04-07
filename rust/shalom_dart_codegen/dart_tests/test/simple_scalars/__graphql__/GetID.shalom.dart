class RequestGetID {
  final String id;

  RequestGetID({required this.id});

  factory RequestGetID.fromJson(Map<String, dynamic> json) =>
      RequestGetID(id: json['id'] as String);

  RequestGetID updateWithJson(Map<String, dynamic> data) {
    return RequestGetID(
      id: data.containsKey('id') ? data['id'] as String : this.id,
    );
  }

  Map<String, dynamic> toJson() => {'id': id};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetID && other.id == id && true);

  @override
  int get hashCode => Object.hashAll([id]);
}
