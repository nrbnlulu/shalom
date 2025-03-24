import 'package:test/test.dart';
import 'schema.dart';

void main() {
  group('GraphQL Serialization', () {
    test('Person and Query classes should correctly serialize and deserialize', () {
      final graphqlInput = {
        'person': {
          'name': 'John Doe',
          'age': 30,
          'id': '12345',
          'height': 1.75,
          'male': true,
        },
      };

      final query = Query.fromJson(graphqlInput);

      expect(query.person, isNotNull);
      expect(query.person?.name, equals('John Doe'));
      expect(query.person?.age, equals(30));
      expect(query.person?.id, equals('12345'));
      expect(query.person?.height, equals(1.75));
      expect(query.person?.male, equals(true));

      final serializedJson = query.toJson();

      expect(serializedJson, equals(graphqlInput));
    });

    test('Person class should handle missing optional fields correctly', () {
      final graphqlInput = {
        'person': {
          'name': 'Jane Doe',
          'id': '67890',
          'male': false,
        },
      };

      final query = Query.fromJson(graphqlInput);

      expect(query.person, isNotNull);
      expect(query.person?.name, equals('Jane Doe'));
      expect(query.person?.age, isNull);
      expect(query.person?.id, equals('67890'));
      expect(query.person?.height, isNull);
      expect(query.person?.male, equals(false));

      final serializedJson = query.toJson();

      expect(serializedJson, equals(graphqlInput));
    });

    test('Query class should handle null person field correctly', () {
      final graphqlInput = {
        'person': null,
      };

      final query = Query.fromJson(graphqlInput);

      expect(query.person, isNull);

      final serializedJson = query.toJson();

      expect(serializedJson, equals(graphqlInput));
    });
  });
}