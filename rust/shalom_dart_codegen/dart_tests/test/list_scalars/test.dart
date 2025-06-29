import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetStringList.shalom.dart';
import '__graphql__/GetStringListOptional.shalom.dart';
import '__graphql__/GetStringListWithNulls.shalom.dart';
import '__graphql__/GetStringListFullyOptional.shalom.dart';
import '__graphql__/GetIntList.shalom.dart';
import '__graphql__/GetIntListOptional.shalom.dart';
import '__graphql__/GetFloatList.shalom.dart';
import '__graphql__/GetFloatListWithNulls.shalom.dart';
import '__graphql__/GetBooleanList.shalom.dart';
import '__graphql__/GetIDList.shalom.dart';
import '__graphql__/UpdateStringList.shalom.dart';
import '__graphql__/UpdateIntList.shalom.dart';
import '__graphql__/UpdateFloatList.shalom.dart';
import '__graphql__/UpdateBooleanList.shalom.dart';
import '__graphql__/UpdateIDList.shalom.dart';
import '__graphql__/CreateUser.shalom.dart';
import '__graphql__/schema.shalom.dart';

void main() {
  group('List of scalars - Response deserialization', () {
    test('[String!]! - non-null list of non-null strings', () {
      final result = GetStringListResponse.fromJson({
        'stringList': ['hello', 'world', 'test'],
      });
      expect(result.stringList, ['hello', 'world', 'test']);
      expect(result.stringList.length, 3);
    });

    test('[String!]! - empty list', () {
      final result = GetStringListResponse.fromJson({'stringList': []});
      expect(result.stringList, []);
      expect(result.stringList.isEmpty, true);
    });

    test('[String!] - optional list with values', () {
      final result = GetStringListOptionalResponse.fromJson({
        'stringListOptional': ['value1', 'value2'],
      });
      expect(result.stringListOptional, ['value1', 'value2']);
    });

    test('[String!] - optional list with null', () {
      final result = GetStringListOptionalResponse.fromJson({
        'stringListOptional': null,
      });
      expect(result.stringListOptional, isNull);
    });

    test('[String]! - non-null list with null elements', () {
      final result = GetStringListWithNullsResponse.fromJson({
        'stringListWithNulls': ['hello', null, 'world', null],
      });
      expect(result.stringListWithNulls, ['hello', null, 'world', null]);
      expect(result.stringListWithNulls.length, 4);
    });

    test('[String] - fully optional', () {
      final result = GetStringListFullyOptionalResponse.fromJson({
        'stringListFullyOptional': ['test', null],
      });
      expect(result.stringListFullyOptional, ['test', null]);
    });

    test('[String] - fully optional with null list', () {
      final result = GetStringListFullyOptionalResponse.fromJson({
        'stringListFullyOptional': null,
      });
      expect(result.stringListFullyOptional, isNull);
    });

    test('[Int!]! - non-null list of non-null integers', () {
      final result = GetIntListResponse.fromJson({
        'intList': [1, 2, 3, 4, 5],
      });
      expect(result.intList, [1, 2, 3, 4, 5]);
    });

    test('[Int] - optional list with null elements', () {
      final result = GetIntListOptionalResponse.fromJson({
        'intListOptional': [100, null, 200, null, 300],
      });
      expect(result.intListOptional, [100, null, 200, null, 300]);
    });

    test('[Float!]! - non-null list of non-null floats', () {
      final result = GetFloatListResponse.fromJson({
        'floatList': [1.1, 2.2, 3.3],
      });
      expect(result.floatList, [1.1, 2.2, 3.3]);
    });

    test('[Float]! - non-null list with null float elements', () {
      final result = GetFloatListWithNullsResponse.fromJson({
        'floatListWithNulls': [1.5, null, 3.5],
      });
      expect(result.floatListWithNulls, [1.5, null, 3.5]);
    });

    test('[Boolean!]! - non-null list of non-null booleans', () {
      final result = GetBooleanListResponse.fromJson({
        'booleanList': [true, false, true, true, false],
      });
      expect(result.booleanList, [true, false, true, true, false]);
    });

    test('[ID!]! - non-null list of non-null IDs', () {
      final result = GetIDListResponse.fromJson({
        'idList': ['id1', 'id2', 'id3'],
      });
      expect(result.idList, ['id1', 'id2', 'id3']);
    });
  });

  group('List of scalars - toJson', () {
    test('[String!]! toJson', () {
      final data = {
        'stringList': ['a', 'b', 'c'],
      };
      final response = GetStringListResponse.fromJson(data);
      expect(response.toJson(), data);
    });

    test('[String] toJson with nulls', () {
      final data = {
        'stringListFullyOptional': ['test', null, 'value'],
      };
      final response = GetStringListFullyOptionalResponse.fromJson(data);
      expect(response.toJson(), data);
    });

    test('[Int!]! toJson', () {
      final data = {
        'intList': [10, 20, 30],
      };
      final response = GetIntListResponse.fromJson(data);
      expect(response.toJson(), data);
    });
  });

  group('List of scalars - Mutation variables', () {
    test('UpdateStringList variables', () {
      final variables = UpdateStringListVariables(
        strings: ['tag1', 'tag2', 'tag3'],
      );
      expect(variables.toJson(), {
        'strings': ['tag1', 'tag2', 'tag3'],
      });
    });

    test('UpdateIntList variables with null list', () {
      final variables = UpdateIntListVariables(ints: None());
      expect(variables.toJson(), {'ints': null});
    });

    test('UpdateIntList variables with values and nulls', () {
      final variables = UpdateIntListVariables(
        ints: Some([1, null, 3, null, 5]),
      );
      expect(variables.toJson(), {
        'ints': [1, null, 3, null, 5],
      });
    });

    test('UpdateFloatList variables', () {
      final variables = UpdateFloatListVariables(floats: [1.1, 2.2, 3.3]);
      expect(variables.toJson(), {
        'floats': [1.1, 2.2, 3.3],
      });
    });

    test('UpdateBooleanList variables', () {
      final variables = UpdateBooleanListVariables(
        booleans: [true, true, false, true],
      );
      expect(variables.toJson(), {
        'booleans': [true, true, false, true],
      });
    });

    test('UpdateIDList variables', () {
      final variables = UpdateIDListVariables(ids: ['uuid1', 'uuid2', 'uuid3']);
      expect(variables.toJson(), {
        'ids': ['uuid1', 'uuid2', 'uuid3'],
      });
    });
  });

  group('List of scalars - Input objects', () {
    test('UserInput with all list fields', () {
      final user = UserInput(
        tags: ['programming', 'dart', 'graphql'],
        scores: Some([95, 87, null, 100]),
        ids: Some(['user1', 'user2']),
      );

      expect(user.toJson(), {
        'tags': ['programming', 'dart', 'graphql'],
        'scores': [95, 87, null, 100],
        'ids': ['user1', 'user2'],
      });
    });

    test('UserInput with empty lists', () {
      final user = UserInput(tags: [], scores: None(), ids: Some([]));

      expect(user.toJson(), {'tags': [], 'scores': null, 'ids': []});
    });

    test('CreateUser mutation with UserInput', () {
      final variables = CreateUserVariables(
        user: UserInput(
          tags: ['tag1', 'tag2'],
          scores: Some([100, 200, null]),
          ids: Some(['id1', 'id2', 'id3']),
        ),
      );

      expect(variables.toJson(), {
        'user': {
          'tags': ['tag1', 'tag2'],
          'scores': [100, 200, null],
          'ids': ['id1', 'id2', 'id3'],
        },
      });
    });
  });
}
