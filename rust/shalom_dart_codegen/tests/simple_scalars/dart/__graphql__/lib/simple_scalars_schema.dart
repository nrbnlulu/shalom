
class Person {
  
  final DateTime dateOfBirth;
  
  final String? name;
  
  final int age;
  

  Person({
    
    required this.dateOfBirth,
    
    this.name,
    
    required this.age,
    
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String) ,
      
      name: json['name'] as String?,
      
      age: json['age'] as int,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      
      'name': name,
      
      'age': age,
      
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person
      
      && other.dateOfBirth == dateOfBirth
      
      && other.name == name
      
      && other.age == age
      ;
  }

  @override
  int get hashCode => Object.hashAll([
    
      dateOfBirth,
    
      name,
    
      age
    
  ]);
}

class Query {
  
  final Person? person;
  

  Query({
    
    this.person,
    
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      
      person: json['person'] != null ? Person.fromJson(json['person'] as Map<String, dynamic>) : null,
      
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
    return other is Query
      
      && other.person == person
      ;
  }

  @override
  int get hashCode => Object.hashAll([
    
      person
    
  ]);
}
