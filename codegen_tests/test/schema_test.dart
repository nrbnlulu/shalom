import 'package:test/test.dart';
import 'package:codegen_tests/schema.dart'; 

void main() {
  group('Person Class', () {
    test('Person.fromJson should correctly deserialize JSON with all fields', () {
      final json = {
        'name': 'John Doe',
        'age': 30,
        'id': '12345',
        'height': 1.75,
        'male': true,
      };

      final person = Person.fromJson(json);

      expect(person.name, equals('John Doe'));
      expect(person.age, equals(30));
      expect(person.id, equals('12345'));
      expect(person.height, equals(1.75));
      expect(person.male, isTrue);
    });

    test('Person.fromJson should handle missing optional fields correctly', () {
      final json = {
        'name': 'Jane Doe',
        'id': '54321',
        'male': false,
      };

      final person = Person.fromJson(json);

      expect(person.name, equals('Jane Doe'));
      expect(person.age, isNull); // `age` is optional and missing
      expect(person.id, equals('54321'));
      expect(person.height, isNull); // `height` is optional and missing
      expect(person.male, isFalse);
    });

    test('Person.fromJson should throw an error if required fields are missing', () {
      final json = {
        'age': 30,
        'height': 1.75,
        'male': true,
      };

      expect(() => Person.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Person.fromJson should handle null values for optional fields', () {
      final json = {
        'name': 'Alice',
        'age': null,
        'id': '1234',
        'height': null,
        'male': false,
      };

      final person = Person.fromJson(json);

      expect(person.name, equals('Alice'));
      expect(person.age, isNull); // `age` is explicitly null
      expect(person.id, equals('1234'));
      expect(person.height, isNull); // `height` is explicitly null
      expect(person.male, isFalse);
    });

    test('Person.toJson should correctly serialize with all fields', () {
      final person = Person(
        name: 'John Doe',
        age: 30,
        id: '12345',
        height: 1.75,
        male: true,
      );

      final json = person.toJson();

      expect(json, equals({
        'name': 'John Doe',
        'age': 30,
        'id': '12345',
        'height': 1.75,
        'male': true,
      }));
    });

    test('Person.toJson should correctly serialize with missing optional fields', () {
      final person = Person(
        name: 'Jane Doe',
        id: '54321',
        male: false,
      );

      final json = person.toJson();

      expect(json, equals({
        'name': 'Jane Doe',
        'age': null, // `age` is optional and not set
        'id': '54321',
        'height': null, // `height` is optional and not set
        'male': false,
      }));
    });

    test('Person equality operator should work correctly with missing optional fields', () {
      final person1 = Person(
        name: 'Alice',
        age: null,
        id: '1234',
        height: null,
        male: false,
      );

      final person2 = Person(
        name: 'Alice',
        age: null,
        id: '1234',
        height: null,
        male: false,
      );

      final person3 = Person(
        name: 'Bob',
        age: 25,
        id: '5678',
        height: 1.70,
        male: true,
      );

      expect(person1, equals(person2)); // Same values, should be equal
      expect(person1, isNot(equals(person3))); // Different values, should not be equal
    });

    test('Person.hashCode should be stable when fields are missing', () {
      final person1 = Person(
        name: 'Charlie',
        age: null,
        id: '9999',
        height: null,
        male: true,
      );

      final person2 = Person(
        name: 'Charlie',
        age: null,
        id: '9999',
        height: null,
        male: true,
      );

      expect(person1.hashCode, equals(person2.hashCode));
    });
  });

  group('Query Class', () {
    test('Query.fromJson should correctly deserialize JSON with person field', () {
      final json = {
        'person': {
          'name': 'Jane Doe',
          'age': 28,
          'id': '7777',
          'height': 1.70,
          'male': false,
        },
      };

      final query = Query.fromJson(json);

      expect(query.person, isNotNull);
      expect(query.person?.name, equals('Jane Doe'));
      expect(query.person?.age, equals(28));
      expect(query.person?.id, equals('7777'));
      expect(query.person?.height, equals(1.70));
      expect(query.person?.male, isFalse);
    });

    test('Query.fromJson should correctly deserialize when person is null', () {
      final json = {
        'person': null,
      };

      final query = Query.fromJson(json);

      expect(query.person, isNull);
    });

    test('Query.fromJson should throw an error if person field is invalid', () {
      final json = {
        'person': 'invalid', // `person` should be a Map, not a String
      };

      expect(() => Query.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Query.toJson should correctly serialize with person field', () {
      final query = Query(
        person: Person(
          name: 'Jane Doe',
          age: 28,
          id: '7777',
          height: 1.70,
          male: false,
        ),
      );

      final json = query.toJson();

      expect(json, equals({
        'person': {
          'name': 'Jane Doe',
          'age': 28,
          'id': '7777',
          'height': 1.70,
          'male': false,
        },
      }));
    });

    test('Query.toJson should correctly serialize when person is null', () {
      final query = Query(person: null);

      final json = query.toJson();

      expect(json, equals({'person': null}));
    });

    test('Query equality operator should work correctly with null person field', () {
      final query1 = Query(
        person: Person(
          name: 'Eve',
          age: 35,
          id: '5555',
          height: 1.60,
          male: false,
        ),
      );

      final query2 = Query(
        person: Person(
          name: 'Eve',
          age: 35,
          id: '5555',
          height: 1.60,
          male: false,
        ),
      );

      final query3 = Query(person: null);

      expect(query1, equals(query2)); // Same values, should be equal
      expect(query1, isNot(equals(query3))); // Different person values, should not be equal
    });

    test('Query.hashCode should be stable with null person field', () {
      final query1 = Query(
        person: Person(
          name: 'Frank',
          age: 50,
          id: '6666',
          height: 1.85,
          male: true,
        ),
      );

      final query2 = Query(
        person: Person(
          name: 'Frank',
          age: 50,
          id: '6666',
          height: 1.85,
          male: true,
        ),
      );

      expect(query1.hashCode, equals(query2.hashCode));
    });
  });
}


