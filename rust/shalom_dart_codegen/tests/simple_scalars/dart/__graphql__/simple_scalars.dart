
class Person {
  
  final String? name;
  
  final int age;
  
  final DateTime dateOfBirth;
  

  Person({
    
    this.name,
    
    required this.age,
    
    required this.dateOfBirth,
    
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      
      name: json['name'] as String?,
      
      age: json['age'] as int,
      
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'name': name,
      
      'age': age,
      
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person
      
      && other.name == name
      
      && other.age == age
      
      && other.dateOfBirth == dateOfBirth
      ;
  }

  @override
  int get hashCode => Object.hashAll([
    
      name,
    
      age,
    
      dateOfBirth
    
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
