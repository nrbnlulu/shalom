import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/TestQuery.shalom.dart';

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
}
