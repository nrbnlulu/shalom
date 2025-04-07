class RequestGetFloatOptional {
  final double? floatOptional;

  RequestGetFloatOptional({this.floatOptional});

  factory RequestGetFloatOptional.fromJson(Map<String, dynamic> json) =>
      RequestGetFloatOptional(floatOptional: json['floatOptional'] as double?);

  RequestGetFloatOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetFloatOptional(
      floatOptional:
          data.containsKey('floatOptional')
              ? data['floatOptional'] as double?
              : this.floatOptional,
    );
  }

  Map<String, dynamic> toJson() => {'floatOptional': floatOptional};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetFloatOptional &&
          other.floatOptional == floatOptional &&
          true);

  @override
  int get hashCode => Object.hashAll([floatOptional]);
}
