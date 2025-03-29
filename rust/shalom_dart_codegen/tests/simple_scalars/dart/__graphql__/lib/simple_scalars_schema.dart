
class Person {
  
  final int age;
  
  final String? name;
  
  final DateTime dateOfBirth;
  

  Person({
    
    required this.age,
    
    this.name,
    
    required this.dateOfBirth,
    
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      
      age: json['age'] as int,
      
      name: json['name'] as String?,
      
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String) ,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'age': age,
      
      'name': name,
      
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person
      
      && other.age == age
      
      && other.name == name
      
      && other.dateOfBirth == dateOfBirth
      ;
  }

  @override
  int get hashCode => Object.hashAll([
    
      age,
    
      name,
    
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
