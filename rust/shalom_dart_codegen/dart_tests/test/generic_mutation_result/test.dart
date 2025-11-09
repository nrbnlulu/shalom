import 'package:test/test.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/UpdateUser.shalom.dart';
import '__graphql__/DeleteUser.shalom.dart';
import '__graphql__/ScheduleTask.shalom.dart';
import '__graphql__/GlobalErrorFrag.shalom.dart';
import 'package:dart_tests/date_time.dart';

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

    group('Scalar Data Field Tests', () {
      test('deleteUserScalarRequired', () {
        final variables = DeleteUserVariables(id: '1');
        final successData = {
          'deleteUser': {
            'success': true,
            'error': null,
          }
        };

        final result =
            DeleteUserResponse.fromResponse(successData, variables: variables);

        // Check that MutationResult was used with scalar type
        expect(result.deleteUser, isA<MutationResult>());
        expect(result.deleteUser,
            isA<MutationResult<bool?, DeleteUser_deleteUser_error?>>());

        // Verify data is the scalar Boolean value
        expect(result.deleteUser.data, true);
        expect(result.deleteUser.error, isNull);
        expect(result.deleteUser.isSuccess, true);
        expect(result.deleteUser.hasError, false);
      });

      test('deleteUserScalarOptional', () {
        final variables = DeleteUserVariables(id: '1');
        final dataWithNullSuccess = {
          'deleteUser': {
            'success': null,
            'error': null,
          }
        };

        final result = DeleteUserResponse.fromResponse(dataWithNullSuccess,
            variables: variables);

        // Verify nullable scalar handling
        expect(result.deleteUser.data, isNull);
        expect(result.deleteUser.error, isNull);
        expect(result.deleteUser.isSuccess, false);
        expect(result.deleteUser.hasError, false);
      });

      test('deleteUserScalarEquals', () {
        final variables = DeleteUserVariables(id: '1');
        final successData = {
          'deleteUser': {
            'success': true,
            'error': null,
          }
        };

        final result1 =
            DeleteUserResponse.fromResponse(successData, variables: variables);
        final result2 =
            DeleteUserResponse.fromResponse(successData, variables: variables);

        // Test equality of responses with scalar data
        expect(result1.deleteUser, equals(result2.deleteUser));
        expect(result1.deleteUser.data, equals(result2.deleteUser.data));
      });

      test('deleteUserScalarToJson', () {
        final variables = DeleteUserVariables(id: '1');
        final successData = {
          'deleteUser': {
            'success': true,
            'error': null,
          }
        };

        final result =
            DeleteUserResponse.fromResponse(successData, variables: variables);

        // Verify toJson works with scalar data
        final json = result.toJson();
        expect(json['deleteUser']['success'], true);
        expect(json['deleteUser']['error'], isNull);
      });

      test('deleteUserScalarWithError', () {
        final variables = DeleteUserVariables(id: '1');
        final errorData = {
          'deleteUser': {
            'success': false,
            'error': {
              '__typename': 'UnauthorizedError',
              'message': 'Not authorized to delete user',
              'code': 'UNAUTHORIZED',
            },
          }
        };

        final result =
            DeleteUserResponse.fromResponse(errorData, variables: variables);

        // Verify scalar data with error present
        expect(result.deleteUser.data, false);
        expect(result.deleteUser.error, isNotNull);
        expect(result.deleteUser.isSuccess, false);
        expect(result.deleteUser.hasError, true);

        final error = result.deleteUser.error!;
        expect(error, isA<DeleteUser_deleteUser_error_UnauthorizedError>());
        final unauthorizedError =
            error as DeleteUser_deleteUser_error_UnauthorizedError;
        expect(unauthorizedError.message, 'Not authorized to delete user');
        expect(unauthorizedError.code, 'UNAUTHORIZED');
      });

      test('deleteUserScalarCacheNormalization', () {
        final variables = DeleteUserVariables(id: '1');
        final successData = {
          'deleteUser': {
            'success': true,
            'error': null,
          }
        };

        final result =
            DeleteUserResponse.fromResponse(successData, variables: variables);

        // Test that scalar data can be written to and read from cache
        final cache = <String, dynamic>{};
        result.writeToCache(cache);

        // Read back from cache
        final resultFromCache =
            DeleteUserResponse.readFromCache(cache, variables: variables);

        expect(resultFromCache, isNotNull);
        expect(resultFromCache!.deleteUser.data, true);
        expect(resultFromCache.deleteUser.error, isNull);
        expect(resultFromCache.deleteUser, equals(result.deleteUser));
      });
    });

    group('Custom Scalar Data Field Tests', () {
      test('scheduleTaskCustomScalarRequired', () {
        final scheduledTime = DateTime(
          year: 2024,
          month: 1,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
        );
        final variables = ScheduleTaskVariables(
          taskId: 'task-123',
          scheduledAt: scheduledTime,
        );
        final successData = {
          'scheduleTask': {
            'scheduledAt': '2024-01-15T10:30:45Z',
            'error': null,
          }
        };

        final result = ScheduleTaskResponse.fromResponse(successData,
            variables: variables);

        // Check that MutationResult was used with custom scalar type
        expect(result.scheduleTask, isA<MutationResult>());
        expect(result.scheduleTask,
            isA<MutationResult<DateTime?, ScheduleTask_scheduleTask_error?>>());

        // Verify data is the custom scalar DateTime value
        expect(result.scheduleTask.data, isNotNull);
        expect(result.scheduleTask.data!.year, 2024);
        expect(result.scheduleTask.data!.month, 1);
        expect(result.scheduleTask.data!.day, 15);
        expect(result.scheduleTask.data!.hour, 10);
        expect(result.scheduleTask.data!.minute, 30);
        expect(result.scheduleTask.data!.second, 45);
        expect(result.scheduleTask.error, isNull);
        expect(result.scheduleTask.isSuccess, true);
        expect(result.scheduleTask.hasError, false);
      });

      test('scheduleTaskCustomScalarOptional', () {
        final scheduledTime = DateTime(
          year: 2024,
          month: 1,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
        );
        final variables = ScheduleTaskVariables(
          taskId: 'task-123',
          scheduledAt: scheduledTime,
        );
        final dataWithNullScheduledAt = {
          'scheduleTask': {
            'scheduledAt': null,
            'error': null,
          }
        };

        final result = ScheduleTaskResponse.fromResponse(
            dataWithNullScheduledAt,
            variables: variables);

        // Verify nullable custom scalar handling
        expect(result.scheduleTask.data, isNull);
        expect(result.scheduleTask.error, isNull);
        expect(result.scheduleTask.isSuccess, false);
        expect(result.scheduleTask.hasError, false);
      });

      test('scheduleTaskCustomScalarEquals', () {
        final scheduledTime = DateTime(
          year: 2024,
          month: 1,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
        );
        final variables = ScheduleTaskVariables(
          taskId: 'task-123',
          scheduledAt: scheduledTime,
        );
        final successData = {
          'scheduleTask': {
            'scheduledAt': '2024-01-15T10:30:45Z',
            'error': null,
          }
        };

        final result1 = ScheduleTaskResponse.fromResponse(successData,
            variables: variables);
        final result2 = ScheduleTaskResponse.fromResponse(successData,
            variables: variables);

        // Test equality of responses with custom scalar data
        expect(result1.scheduleTask, equals(result2.scheduleTask));
        expect(result1.scheduleTask.data, equals(result2.scheduleTask.data));
      });

      test('scheduleTaskCustomScalarToJson', () {
        final scheduledTime = DateTime(
          year: 2024,
          month: 1,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
        );
        final variables = ScheduleTaskVariables(
          taskId: 'task-123',
          scheduledAt: scheduledTime,
        );
        final successData = {
          'scheduleTask': {
            'scheduledAt': '2024-01-15T10:30:45Z',
            'error': null,
          }
        };

        final result = ScheduleTaskResponse.fromResponse(successData,
            variables: variables);

        // Verify toJson works with custom scalar data
        final json = result.toJson();
        expect(json['scheduleTask']['scheduledAt'], '2024-01-15T10:30:45Z');
        expect(json['scheduleTask']['error'], isNull);
      });

      test('scheduleTaskCustomScalarWithError', () {
        final scheduledTime = DateTime(
          year: 2024,
          month: 1,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
        );
        final variables = ScheduleTaskVariables(
          taskId: 'task-123',
          scheduledAt: scheduledTime,
        );
        final errorData = {
          'scheduleTask': {
            'scheduledAt': null,
            'error': {
              '__typename': 'ValidationError',
              'message': 'Invalid schedule time',
              'field': 'scheduledAt',
            },
          }
        };

        final result =
            ScheduleTaskResponse.fromResponse(errorData, variables: variables);

        // Verify custom scalar data with error present
        expect(result.scheduleTask.data, isNull);
        expect(result.scheduleTask.error, isNotNull);
        expect(result.scheduleTask.isSuccess, false);
        expect(result.scheduleTask.hasError, true);

        final error = result.scheduleTask.error!;
        expect(error, isA<ScheduleTask_scheduleTask_error_ValidationError>());
        final validationError =
            error as ScheduleTask_scheduleTask_error_ValidationError;
        expect(validationError.message, 'Invalid schedule time');
        expect(validationError.field, 'scheduledAt');
      });

      test('scheduleTaskCustomScalarCacheNormalization', () {
        final scheduledTime = DateTime(
          year: 2024,
          month: 1,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
        );
        final variables = ScheduleTaskVariables(
          taskId: 'task-123',
          scheduledAt: scheduledTime,
        );
        final successData = {
          'scheduleTask': {
            'scheduledAt': '2024-01-15T10:30:45Z',
            'error': null,
          }
        };

        final result = ScheduleTaskResponse.fromResponse(successData,
            variables: variables);

        // Test that custom scalar data can be written to and read from cache
        final cache = <String, dynamic>{};
        result.writeToCache(cache);

        // Read back from cache
        final resultFromCache =
            ScheduleTaskResponse.readFromCache(cache, variables: variables);

        expect(resultFromCache, isNotNull);
        expect(resultFromCache!.scheduleTask.data, isNotNull);
        expect(resultFromCache.scheduleTask.data!.year, 2024);
        expect(resultFromCache.scheduleTask.data!.month, 1);
        expect(resultFromCache.scheduleTask.data!.day, 15);
        expect(resultFromCache.scheduleTask.data!.hour, 10);
        expect(resultFromCache.scheduleTask.data!.minute, 30);
        expect(resultFromCache.scheduleTask.data!.second, 45);
        expect(resultFromCache.scheduleTask.error, isNull);
        expect(resultFromCache.scheduleTask, equals(result.scheduleTask));
      });
    });
  });
}
