
class Person {
  
  final String? name;
  
  final DateTime dateOfBirth;
  
  final int age;
  

  Person({
    
    this.name,
    
    required this.dateOfBirth,
    
    required this.age,
    
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      
      name: json['name'] as String?,
      
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
      
      age: json['age'] as int,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'name': name,
      
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      
      'age': age,
      
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person
      
      && other.name == name
      
      && other.dateOfBirth == dateOfBirth
      
      && other.age == age
      ;
  }

  @override
  int get hashCode => Object.hashAll([
    
      name,
    
      dateOfBirth,
    
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
