import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '../input_list_scalars/__graphql__/schema.shalom.dart';
import '__graphql__/InputScalarInsideInputType.shalom.dart';
import '__graphql__/InputScalarListMaybe.shalom.dart';
import '__graphql__/InputScalarListRequired.shalom.dart';
import '__graphql__/InputScalarListOptional.shalom.dart';

void main() {
  group('List of scalars - Mutation variables', () {
    test('UpdateStringList variables', () {
      final variables = InputScalarListRequiredVariables(
        strings: ['tag1', 'tag2', 'tag3'],
      );
      expect(variables.toJson(), {
        'strings': ['tag1', 'tag2', 'tag3'],
      });
    });

    test('UpdateIntList variables with null list', () {
      final variables = InputScalarListMaybeVariables(ints: None());
      expect(variables.toJson(), {});
    });

    test('UpdateIntList variables with values and nulls', () {
      final variables = InputScalarListMaybeVariables(
        ints: Some([1, null, 3, null, 5]),
      );
      expect(variables.toJson(), {
        'ints': [1, null, 3, null, 5],
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

      expect(user.toJson(), {'tags': [], 'ids': []});
    });

    test('CreateUser mutation with UserInput', () {
      final variables = InputScalarInsideInputTypeVariables(
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

  group('Optional list scalars', () {
    test('InputScalarListOptional with value', () {
      final variables = InputScalarListOptionalVariables(
        names: Some(['John', 'Jane']),
      );
      expect(variables.toJson(), {
        'names': ['John', 'Jane'],
      });
    });

    test('InputScalarListOptional with None', () {
      final variables = InputScalarListOptionalVariables(names: None());
      expect(variables.toJson(), {});
    });

    test('InputScalarListOptional with empty list', () {
      final variables = InputScalarListOptionalVariables(names: Some([]));
      expect(variables.toJson(), {'names': []});
    });
  });
}
