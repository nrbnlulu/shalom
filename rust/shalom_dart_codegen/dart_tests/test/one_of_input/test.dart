import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/TestQuery.shalom.dart';
import '__graphql__/TestListQuery.shalom.dart';
import '__graphql__/TestComplexQuery.shalom.dart';

void main() {
  group('TestOneOf', () {
    test('equality same variant', () {
      final input1 = TestOneOf.a('test');
      final input2 = TestOneOf.a('test');
      final input3 = TestOneOf.a('different');
      expect(input1 == input2, isTrue);
      expect(input1 == input3, isFalse);
    });

    test('equality different variants', () {
      final inputA = TestOneOf.a('test');
      final inputB = TestOneOf.b(42);
      expect(inputA == inputB, isFalse);
    });

    test('toJson a', () {
      final input = TestOneOf.a('test');
      expect(input.toJson(), equals({'a': 'test'}));
    });

    test('toJson b', () {
      final input = TestOneOf.b(42);
      expect(input.toJson(), equals({'b': 42}));
    });

    test('toJson c', () {
      final input = TestOneOf.c(true);
      expect(input.toJson(), equals({'c': true}));
    });
  });

  group('TestQueryResponse', () {
    test('fromResponse', () {
      final jsonResponse = {
        'test': {'id': '1', 'value': 'hello'}
      };
      final variables = TestQueryVariables(input: TestOneOf.a('test'));
      final response =
          TestQueryResponse.fromResponse(jsonResponse, variables: variables);
      expect(response.test.id, '1');
      expect(response.test.value, 'hello');
    });
  });
  group('TestListQuery', () {
    group('variables', () {
      test('toJson with list of different variants', () {
        final variables = TestListQueryVariables(
          input: [
            TestOneOf.a('test'),
            TestOneOf.b(42),
            TestOneOf.c(true),
          ],
        );
        expect(
            variables.toJson(),
            equals({
              'input': [
                {'a': 'test'},
                {'b': 42},
                {'c': true},
              ],
            }));
      });
    });

    test('fromResponse', () {
      final jsonResponse = {'testList': 'success'};
      final variables = TestListQueryVariables(input: []);
      final response = TestListQueryResponse.fromResponse(jsonResponse,
          variables: variables);
      expect(response.testList, 'success');
    });
  });

  group('ComplexOneOf', () {
    test('equality same variant', () {
      final input1 = ComplexOneOf.scalarField('test');
      final input2 = ComplexOneOf.scalarField('test');
      final input3 = ComplexOneOf.scalarField('different');
      expect(input1 == input2, isTrue);
      expect(input1 == input3, isFalse);
    });

    test('equality different variants', () {
      final inputScalar = ComplexOneOf.scalarField('test');
      final inputEnum = ComplexOneOf.enumField(SomeEnum.A);
      expect(inputScalar == inputEnum, isFalse);
    });

    test('toJson scalarField', () {
      final input = ComplexOneOf.scalarField('test');
      expect(input.toJson(), equals({'scalarField': 'test'}));
    });

    test('toJson objectField', () {
      final obj = Result(id: '1', value: 'val');
      final input = ComplexOneOf.objectField(obj);
      expect(
          input.toJson(),
          equals({
            'objectField': {'id': '1', 'value': 'val'}
          }));
    });

    test('toJson listField', () {
      final input = ComplexOneOf.listField([1, 2, 3]);
      expect(
          input.toJson(),
          equals({
            'listField': [1, 2, 3]
          }));
    });

    test('toJson enumField', () {
      final input = ComplexOneOf.enumField(SomeEnum.A);
      expect(input.toJson(), equals({'enumField': 'A'}));
    });
  });

  group('TestComplexQueryResponse', () {
    test('fromResponse', () {
      final jsonResponse = {'testComplex': 'success'};
      final variables = TestComplexQueryVariables(
        input: ComplexOneOf.scalarField('test'),
      );
      final response = TestComplexQueryResponse.fromResponse(
        jsonResponse,
        variables: variables,
      );
      expect(response.testComplex, 'success');
    });
  });
}
