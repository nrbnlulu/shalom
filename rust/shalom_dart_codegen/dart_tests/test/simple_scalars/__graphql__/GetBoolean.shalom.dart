class RequestGetBoolean {
  final bool boolean;

  // keywordargs constructor
  RequestGetBoolean({required this.boolean});

  factory RequestGetBoolean.fromJson(Map<String, dynamic> json) =>
      RequestGetBoolean(boolean: json['boolean'] as bool);

  RequestGetBoolean updateWithJson(Map<String, dynamic> data) {
    return RequestGetBoolean(
      boolean:
          data.containsKey('boolean') ? data['boolean'] as bool : this.boolean,
    );
  }

  Map<String, dynamic> toJson() => {'boolean': boolean};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetBoolean && other.boolean == boolean && true);

  @override
  int get hashCode => Object.hashAll([boolean]);
}

/// class memberes
