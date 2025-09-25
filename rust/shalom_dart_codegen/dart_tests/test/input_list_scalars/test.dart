import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '../input_list_scalars/__graphql__/schema.shalom.dart';
import '__graphql__/InputScalarInsideInputTypeMutation.shalom.dart';
import '__graphql__/InputScalarListMaybeMutation.shalom.dart';
import '__graphql__/InputScalarListRequiredMutation.shalom.dart';
import '__graphql__/InputScalarListOptionalMutation.shalom.dart';

void main() {
  group('List of input scalars', () {
    test('required', () {
      final variables = InputScalarListRequiredMutationVariables(
        strings: ['tag1', 'tag2', 'tag3'],
      );
      expect(variables.toJson(), {
        'strings': ['tag1', 'tag2', 'tag3'],
      });
      final newVariables = variables.updateWith(strings: ['tag4', 'tag5']);
      expect(newVariables.toJson(), {
        'strings': ['tag4', 'tag5'],
      });
    });

    test('maybe', () {
      final variables = InputScalarListMaybeMutationVariables(ints: None());
      expect(variables.toJson(), {});
      final some = variables.updateWith(ints: Some(Some([1, 2, 3])));
      expect(some.toJson(), {
        'ints': [1, 2, 3],
      });
      final someWithNullValue = some.updateWith(ints: Some(Some(null)));
      expect(someWithNullValue.toJson(), {'ints': null});
    });

    test("optional", () {
      final vars = InputScalarListOptionalMutationVariables();
      expect(vars.toJson(), {"names": null});
      final varsWithValues = vars.updateWith(names: Some(['Alice', 'Bob']));
      expect(varsWithValues.toJson(), {
        "names": ['Alice', 'Bob'],
      });
    });
  });

  test('List of input scalars inside input object', () {
    final vars = InputScalarInsideInputTypeMutationVariables(
      user: UserInput(
        tags: ['tag1', 'tag2', 'tag3'],
        ids: Some(null),
        scores: None(),
      ),
    );
    expect(vars.toJson(), {
      'user': {
        'tags': ['tag1', 'tag2', 'tag3'],
        'ids': null,
      },
    });

    final varsUpdated = vars.updateWith(
      user: vars.user.updateWith(
        tags: ['1'],
        ids: Some(Some(["12", "3", "5"])),
        scores: Some(Some([0])),
      ),
    );
    expect(varsUpdated.toJson(), {
      'user': {
        'tags': ['1'],
        'ids': ['12', '3', '5'],
        'scores': [0],
      },
    });
  });
}
