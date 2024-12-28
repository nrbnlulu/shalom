import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';

import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';

class MockFromJson  {
  final String name;

  MockFromJson(this.name);

  static MockFromJson fromJsonObject(JsonObject json) {
    return MockFromJson(json['name']);
  }
}

void main() {

  group('GraphQLResult tests', () {
    test('GraphQLResult fromJson with data', () {
      final json = {
        'data': {'name': 'Test'},
        'errors': null
      };

      final result = GraphQLResult<MockFromJson>.fromJson(json, (json) => MockFromJson.fromJsonObject(json));

      expect(result.data, isNotNull);
      expect(result.data!.name, 'Test');
      expect(result.errors, isNull);
    });

    test('GraphQLResult fromJson with errors', () {
      final json = {
        'data': null,
        'errors': [
          [
            {'message': 'Error 1'},
            {'message': 'Error 2'}
          ]
        ]
      };

      final result = GraphQLResult<MockFromJson>.fromJson(json, (json) => MockFromJson.fromJsonObject(json));

      expect(result.data, isNull);
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors![0].length, 2);
      expect(result.errors![0][0]['message'], 'Error 1');
      expect(result.errors![0][1]['message'], 'Error 2');
    });

    test('GraphQLResult fromJson with data and errors', () {
      final json = {
        'data': {'name': 'Test'},
        'errors': [
          [
            {'message': 'Error 1'}
          ]
        ]
      };

      final result = GraphQLResult<MockFromJson>.fromJson(json, (json) => MockFromJson.fromJsonObject(json));

      expect(result.data, isNotNull);
      expect(result.data!.name, 'Test');
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors![0].length, 1);
      expect(result.errors![0][0]['message'], 'Error 1');
    });
  });
}
