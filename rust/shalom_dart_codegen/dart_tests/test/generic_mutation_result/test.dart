import 'package:test/test.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/UpdateUser.shalom.dart';
import '__graphql__/GlobalErrorFrag.shalom.dart';

void main() {
  group('Generic Mutation Result', () {
    test('mutationResultGenericClassExists', () {
      // Test that the generic MutationResult class was generated
      final result = MutationResult<String, String>(data: 'test', error: null);

      expect(result, isA<MutationResult<String, String>>());
      expect(result.data, 'test');
      expect(result.error, isNull);
    });

    test('mutationResultIsSuccess', () {
      final successResult =
          MutationResult<String, String>(data: 'test', error: null);
      final errorResult =
          MutationResult<String, String>(data: null, error: 'error');
      final bothResult =
          MutationResult<String, String>(data: 'test', error: 'error');

      expect(successResult.isSuccess, true);
      expect(successResult.hasError, false);

      expect(errorResult.isSuccess, false);
      expect(errorResult.hasError, true);

      expect(bothResult.isSuccess, false);
      expect(bothResult.hasError, true);
    });

    test('mutationResultEquals', () {
      final result1 = MutationResult<String, String>(data: 'test', error: null);
      final result2 = MutationResult<String, String>(data: 'test', error: null);
      final result3 =
          MutationResult<String, String>(data: null, error: 'error');

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('mutationResultToString', () {
      final result = MutationResult<String, String>(data: 'test', error: null);

      expect(result.toString(), 'MutationResult(data: test, error: null)');
    });

    test('updateUserResponseTypeCheck', () {
      final variables = UpdateUserVariables(id: '1', name: 'John Doe');
      final successData = {
        'updateUser': {
          'data': {
            'id': '1',
            'name': 'John Doe',
            'email': 'john@example.com',
          },
          'error': null,
        }
      };

      final result =
          UpdateUserResponse.fromResponse(successData, variables: variables);

      // Check that MutationResult was used instead of individual class
      expect(result.updateUser, isA<MutationResult>());

      // The field type is correct
      expect(
          result.updateUser,
          isA<
              MutationResult<UpdateUser_updateUser_data?,
                  UpdateUser_updateUser_error?>>());
    });

    test('mutationResultTypeParameters', () {
      // Verify that the generic type parameters work correctly
      final result = MutationResult<String?, int?>(data: 'test', error: null);

      expect(result, isA<MutationResult<String?, int?>>());
      expect(result.data, 'test');
      expect(result.error, isNull);

      final result2 = MutationResult<String?, int?>(data: null, error: 42);
      expect(result2.data, isNull);
      expect(result2.error, 42);
    });
  });
}
