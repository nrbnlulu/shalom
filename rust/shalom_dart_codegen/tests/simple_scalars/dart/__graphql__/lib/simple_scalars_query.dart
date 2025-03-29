import 'simple_scalars_schema.dart';


class HelloWorldData {
  final Person? person;

  HelloWorldData({this.person});

  factory HelloWorldData.fromJson(Map<String, dynamic> json) {
    return HelloWorldData(
      person: json['person'] != null 
        ? Person.fromJson(json['person'] as Map<String, dynamic>) 
        : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'person': person?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelloWorldData && other.person == person;
  }

  @override
  int get hashCode => person.hashCode;
}
