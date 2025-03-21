
enum Person {
  final String value_;
  const Person(this.value_);
  name(Name);
  age(Age);
  dateOfBirth(Date_of_birth);
  

  static const Person fromString(String value) {
    switch (value) {
      case 'name':
        return Person.name;
      case 'age':
        return Person.age;
      case 'dateOfBirth':
        return Person.dateOfBirth;
      
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }

}

enum Query {
  final String value_;
  const Query(this.value_);
  person(Person);
  

  static const Query fromString(String value) {
    switch (value) {
      case 'person':
        return Query.person;
      
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }

}


