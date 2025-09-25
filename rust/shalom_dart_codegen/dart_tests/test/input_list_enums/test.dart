import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/InputListEnumRequired.shalom.dart';
import '__graphql__/InputListEnumOptionalWithDefault.shalom.dart';
import '__graphql__/InputListEnumMaybe.shalom.dart';
import '__graphql__/InputListEnumInsideInputObject.shalom.dart';

void main() {
  group('List of input enums', () {
    test('enumListRequired', () {
      final variables = InputListEnumRequiredVariables(
        foo: [Gender.MALE, Gender.FEMALE, Gender.ANDRIGONOS],
      );
      expect(variables.toJson(), {
        'foo': ['MALE', 'FEMALE', 'ANDRIGONOS'],
      });

      final newVariables = variables.updateWith(
        foo: [Gender.FEMALE, Gender.ANDRIGONOS],
      );
      expect(newVariables.toJson(), {
        'foo': ['FEMALE', 'ANDRIGONOS'],
      });

      expect(newVariables.foo, [Gender.FEMALE, Gender.ANDRIGONOS]);
      expect(newVariables == variables, false);

      final request =
          RequestInputListEnumRequired(variables: variables).toRequest();
      expect(request.variables, {
        'foo': ['MALE', 'FEMALE', 'ANDRIGONOS'],
      });
    });

    test('enumListOptionalWithDefault', () {
      final variables = InputListEnumOptionalWithDefaultVariables();
      expect(variables.toJson(), {'foo': null});

      final withValues = variables.updateWith(
        foo: Some([Gender.MALE, Gender.FEMALE]),
      );
      expect(withValues.toJson(), {
        'foo': ['MALE', 'FEMALE'],
      });

      final withNull = withValues.updateWith(foo: Some(null));
      expect(withNull.toJson(), {'foo': null});

      final request = RequestInputListEnumOptionalWithDefault(
        variables: variables,
      ).toRequest();
      expect(request.variables, {'foo': null});
    });

    test('enumListMaybe', () {
      final variables = InputListEnumMaybeVariables(foo: None());
      expect(variables.toJson(), {});

      final some = variables.updateWith(
        foo: Some(Some([Gender.MALE, Gender.FEMALE])),
      );
      expect(some.toJson(), {
        'foo': ['MALE', 'FEMALE'],
      });

      final someWithNullValue = some.updateWith(foo: Some(Some(null)));
      expect(someWithNullValue.toJson(), {'foo': null});

      final backToNone = someWithNullValue.updateWith(foo: Some(None()));
      expect(backToNone.toJson(), {});

      final request = RequestInputListEnumMaybe(variables: some).toRequest();
      expect(request.variables, {
        'foo': ['MALE', 'FEMALE'],
      });
    });

    test('enumListInsideInputObject', () {
      final variables = InputListEnumInsideInputObjectVariables(
        input: ObjectWithListOfInput(
          genders: [Gender.MALE, Gender.FEMALE],
          optionalGenders: Some([Gender.ANDRIGONOS]),
        ),
      );
      expect(variables.toJson(), {
        'input': {
          'genders': ['MALE', 'FEMALE'],
          'optionalGenders': ['ANDRIGONOS'],
        },
      });

      final updatedVariables = variables.updateWith(
        input: variables.input.updateWith(
          genders: [Gender.FEMALE, Gender.ANDRIGONOS],
          optionalGenders: Some(Some(null)),
        ),
      );
      expect(updatedVariables.toJson(), {
        'input': {
          'genders': ['FEMALE', 'ANDRIGONOS'],
          'optionalGenders': null,
        },
      });

      final withoutOptional = variables.updateWith(
        input: variables.input.updateWith(optionalGenders: Some(None())),
      );
      expect(withoutOptional.toJson(), {
        'input': {
          'genders': ['MALE', 'FEMALE'],
        },
      });

      final request = RequestInputListEnumInsideInputObject(
        variables: variables,
      ).toRequest();
      expect(request.variables, {
        'input': {
          'genders': ['MALE', 'FEMALE'],
          'optionalGenders': ['ANDRIGONOS'],
        },
      });
    });
  });
}
