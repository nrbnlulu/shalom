import "dart:async";
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

    test('cache normalization with different oneOf variants', () async {
      final ctx = ShalomCtx.withCapacity();

      // First request with variant 'a'
      final jsonResponseA = {
        'test': {'id': '1', 'value': 'hello_a'}
      };
      final variablesA = TestQueryVariables(input: TestOneOf.a('test_a'));
      TestQueryResponse.fromResponse(jsonResponseA,
          ctx: ctx, variables: variablesA);

      // Second request with variant 'b' - should be cached separately
      final jsonResponseB = {
        'test': {'id': '2', 'value': 'hello_b'}
      };
      final variablesB = TestQueryVariables(input: TestOneOf.b(42));
      TestQueryResponse.fromResponse(jsonResponseB,
          ctx: ctx, variables: variablesB);

      // Verify both responses are cached correctly
      final cachedA = TestQueryResponse.fromCache(ctx, variablesA);
      final cachedB = TestQueryResponse.fromCache(ctx, variablesB);

      expect(cachedA.test.id, '1');
      expect(cachedA.test.value, 'hello_a');
      expect(cachedB.test.id, '2');
      expect(cachedB.test.value, 'hello_b');
    });

    test('cache normalization with same oneOf variant updates correctly',
        () async {
      final ctx = ShalomCtx.withCapacity();

      // Initial request
      final initialResponse = {
        'test': {'id': '1', 'value': 'initial'}
      };
      final variables = TestQueryVariables(input: TestOneOf.a('test'));
      var (result, updateCtx) = TestQueryResponse.fromResponseImpl(
        initialResponse,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = TestQueryResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      // Updated request with same oneOf variant
      final updatedResponse = {
        'test': {'id': '1', 'value': 'updated'}
      };
      final nextResult = TestQueryResponse.fromResponse(
        updatedResponse,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.test.value, 'updated');
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

    test('listField equality with same elements', () {
      final a = ComplexOneOf.listField([1, 2, 3]);
      final b = ComplexOneOf.listField([1, 2, 3]);
      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('listField equality with different elements', () {
      final a = ComplexOneOf.listField([1, 2, 3]);
      final b = ComplexOneOf.listField([4, 5, 6]);
      expect(a == b, isFalse);
    });

    test('toJson scalarField', () {
      final input = ComplexOneOf.scalarField('test');
      expect(input.toJson(), equals({'scalarField': 'test'}));
    });

    test('toJson objectField', () {
      final obj = ResultInput(id: '1', value: 'val');
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

    test('cache normalization with different complex oneOf variants', () async {
      final ctx = ShalomCtx.withCapacity();

      // Request with scalarField variant
      final jsonResponseScalar = {'testComplex': 'scalar_result'};
      final variablesScalar = TestComplexQueryVariables(
        input: ComplexOneOf.scalarField('test'),
      );
      final _ = TestComplexQueryResponse.fromResponse(
        jsonResponseScalar,
        ctx: ctx,
        variables: variablesScalar,
      );

      // Request with enumField variant - should be cached separately
      final jsonResponseEnum = {'testComplex': 'enum_result'};
      final variablesEnum = TestComplexQueryVariables(
        input: ComplexOneOf.enumField(SomeEnum.A),
      );
      TestComplexQueryResponse.fromResponse(
        jsonResponseEnum,
        ctx: ctx,
        variables: variablesEnum,
      );

      // Verify both responses are cached correctly with different keys
      final cachedScalar =
          TestComplexQueryResponse.fromCache(ctx, variablesScalar);
      final cachedEnum = TestComplexQueryResponse.fromCache(ctx, variablesEnum);

      expect(cachedScalar.testComplex, 'scalar_result');
      expect(cachedEnum.testComplex, 'enum_result');
    });
  });
}
