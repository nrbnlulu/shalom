import 'package:test/test.dart';
import 'package:__graphql__/simple_scalars_schema.dart';
import 'package:__graphql__/simple_scalars_query.dart';

void main() {
  group('HelloWorldData', () {
    // Test for fromJson method.
    test('fromJson creates a HelloWorldData object', () {
      final json = {
        'person': {
          'name': 'John Doe',
          'age': 30,
          'dateOfBirth': '1991-01-01'
        }
      };
      final helloWorldData = HelloWorldData.fromJson(json);

      expect(helloWorldData.person?.name, 'John Doe');
      expect(helloWorldData.person?.age, 30);
      expect(helloWorldData.person?.dateOfBirth, DateTime.parse('1991-01-01'));
    });

    // Test for toJson method.
    test('toJson converts HelloWorldData to JSON correctly', () {
      final person = Person(name: 'John Doe', age: 30, dateOfBirth: DateTime.parse('1991-01-01'));
      final helloWorldData = HelloWorldData(person: person);
      
      final json = helloWorldData.toJson();

      expect(json['person']['name'], 'John Doe');
      expect(json['person']['age'], 30);
      expect(json['person']['dateOfBirth'], '1991-01-01T00:00:00.000');
    });

    test('equality operator compares HelloWorldData correctly', () {
        final person1 = Person(name: 'John Doe', age: 30, dateOfBirth: DateTime.parse('1991-01-01'));
        final person2 = Person(name: 'John Doe', age: 30, dateOfBirth: DateTime.parse('1991-01-01'));
        final helloWorldData1 = HelloWorldData(person: person1);
        final helloWorldData2 = HelloWorldData(person: person2);
        
        expect(helloWorldData1, equals(helloWorldData2));
        });
    });

    // Test for hashCode method.
    test('hashCode is consistent with equality operator', () {
      final person1 = Person(name: 'John Doe', age: 30, dateOfBirth: DateTime.parse('1991-01-01'));
      final helloWorldData1 = HelloWorldData(person: person1);
      final helloWorldData2 = HelloWorldData(person: person1);

      expect(helloWorldData1.hashCode, equals(helloWorldData2.hashCode));
    });
}
