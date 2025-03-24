
class Person {
  
  final String name;
  
  final int? age;
  
  final String id;
  
  final double? height;
  
  final bool male;
  

  Person({
    
    required this.name,
    
    this.age,
    
    required this.id,
    
    this.height,
    
    required this.male,
    
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      
      name: json['name'] as String,
      
      age: json['age'] as int?,
      
      id: json['id'] as String,
      
      height: json['height'] as double?,
      
      male: json['male'] as bool,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'name': name,
      
      'age': age,
      
      'id': id,
      
      'height': height,
      
      'male': male,
      
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person
      
      && other.name == name
      
      && other.age == age
      
      && other.id == id
      
      && other.height == height
      
      && other.male == male
      ;
  }

  @override
  int get hashCode => Object.hash(
    
    name,
    
    age,
    
    id,
    
    height,
    
    male
    
  );
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
  int get hashCode => Object.hash(
    
    person
    
  );
}
