import 'package:test/test.dart';
import 'package:__graphql__/simple_scalars_schema.dart';

void main() {
  group('Person', () {
    test('should create a Person object from JSON', () {
      final json = {
        'name': 'John Doe',
        'dateOfBirth': '1990-01-01T00:00:00.000',
        'age': 31
      };

      final person = Person.fromJson(json);

      expect(person.name, 'John Doe');
      expect(person.dateOfBirth, DateTime.parse('1990-01-01T00:00:00.000'));
      expect(person.age, 31);
    });

    test('should convert a Person object to JSON', () {
      final person = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );

      final json = person.toJson();

      expect(json['name'], 'John Doe');
      expect(json['dateOfBirth'], '1990-01-01T00:00:00.000');
      expect(json['age'], 31);
    });

    test('should compare two Person objects for equality', () {
      final person1 = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );
      final person2 = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );

      expect(person1, person2);
    });

    test('should generate a unique hashCode for Person', () {
      final person = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );

      final hashCode = person.hashCode;

      expect(hashCode, isNotNull);
    });
  });

  group('Query', () {
    test('should create a Query object from JSON', () {
      final json = {
        'person': {
          'name': 'John Doe',
          'dateOfBirth': '1990-01-01T00:00:00.000',
          'age': 31
        }
      };

      final query = Query.fromJson(json);

      expect(query.person?.name, 'John Doe');
      expect(query.person?.dateOfBirth, DateTime.parse('1990-01-01T00:00:00.000'));
      expect(query.person?.age, 31);
    });

    test('should convert a Query object to JSON', () {
      final person = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );
      final query = Query(person: person);

      final json = query.toJson();

      expect(json['person']['name'], 'John Doe');
      expect(json['person']['dateOfBirth'], '1990-01-01T00:00:00.000');
      expect(json['person']['age'], 31);
    });

    test('should compare two Query objects for equality', () {
      final person1 = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );
      final query1 = Query(person: person1);

      final person2 = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );
      final query2 = Query(person: person2);

      expect(query1, query2);
    });

    test('should generate a unique hashCode for Query', () {
      final person = Person(
        name: 'John Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        age: 31,
      );
      final query = Query(person: person);

      final hashCode = query.hashCode;

      expect(hashCode, isNotNull);
    });
  });
}
