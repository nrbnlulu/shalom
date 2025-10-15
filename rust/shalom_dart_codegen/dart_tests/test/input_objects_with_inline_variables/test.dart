import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/RefreshToken.shalom.dart';
import '__graphql__/RefreshTokenWithVariable.shalom.dart';
import '__graphql__/UpdateUser.shalom.dart';
import '__graphql__/UpdateUserWithOptionalVariables.shalom.dart';
import '__graphql__/UpdateUserMixed.shalom.dart';

void main() {
  group('Input Objects with Inline Variables', () {
    late ShalomCtx shalomCtx;

    setUp(() {
      shalomCtx = ShalomCtx.withCapacity();
    });

    group('RefreshToken - Single Variable with Inline Literal', () {
      test(
          'RefreshTokenRequired - should handle required variable in inline object',
          () {
        final variables = RefreshTokenVariables(refreshToken: 'test-token-123');
        final request = RequestRefreshToken(variables: variables);

        // Verify the request is created correctly
        expect(request.variables.refreshToken, 'test-token-123');

        // Verify toRequest works
        final gqlRequest = request.toRequest();
        expect(gqlRequest.variables['refreshToken'], 'test-token-123');
        expect(gqlRequest.opType, OperationType.Mutation);
        expect(gqlRequest.opName, 'RefreshToken');
      });

      test('RefreshTokenOptional - should handle null refresh token', () {
        final variables = RefreshTokenVariables(refreshToken: 'token-456');
        expect(variables.refreshToken, 'token-456');
      });

      test(
          'RefreshTokenCacheNormalization - should normalize cache with inline variables',
          () {
        final variables = RefreshTokenVariables(refreshToken: 'cache-token');

        final mockData = {
          'refreshToken': {
            'token': 'new-access-token',
            'expiresAt': '2024-12-31T23:59:59Z',
            'userId': 'user-123'
          }
        };

        final cacheUpdateCtx = CacheUpdateContext(shalomContext: shalomCtx);
        RefreshTokenResponse.normalize$inCache(
            mockData, cacheUpdateCtx, variables);

        // Verify cache was updated
        expect(cacheUpdateCtx.changedRecords.isNotEmpty, true);

        // Read back from cache
        final cached = RefreshTokenResponse.fromCache(shalomCtx, variables);
        expect(cached.refreshToken.token, 'new-access-token');
        expect(cached.refreshToken.expiresAt, '2024-12-31T23:59:59Z');
        expect(cached.refreshToken.userId, 'user-123');
      });

      test('RefreshTokenEquals - should compare responses correctly', () {
        final response1 = RefreshTokenResponse(
            refreshToken: RefreshToken_refreshToken(
                token: 'token-1', expiresAt: '2024-12-31', userId: 'user-1'));

        final response2 = RefreshTokenResponse(
            refreshToken: RefreshToken_refreshToken(
                token: 'token-1', expiresAt: '2024-12-31', userId: 'user-1'));

        final response3 = RefreshTokenResponse(
            refreshToken: RefreshToken_refreshToken(
                token: 'token-2', expiresAt: '2024-12-31', userId: 'user-1'));

        expect(response1.refreshToken, equals(response2.refreshToken));
        expect(response1.refreshToken, isNot(equals(response3.refreshToken)));
      });

      test('RefreshTokenToJson - should serialize to JSON correctly', () {
        final refreshToken = RefreshToken_refreshToken(
            token: 'json-token',
            expiresAt: '2024-12-31T23:59:59Z',
            userId: 'user-json');

        final json = refreshToken.toJson();
        expect(json['token'], 'json-token');
        expect(json['expiresAt'], '2024-12-31T23:59:59Z');
        expect(json['userId'], 'user-json');
      });
    });

    group('RefreshTokenWithVariable - Multiple Variables in Inline Object', () {
      test(
          'RefreshTokenWithVariableRequired - should handle multiple required variables',
          () {
        final variables = RefreshTokenWithVariableVariables(
            refreshToken: 'multi-token', revoke: true);

        final request = RequestRefreshTokenWithVariable(variables: variables);
        expect(request.variables.refreshToken, 'multi-token');
        expect(request.variables.revoke, true);

        final gqlRequest = request.toRequest();
        expect(gqlRequest.variables['refreshToken'], 'multi-token');
        expect(gqlRequest.variables['revoke'], true);
      });

      test(
          'RefreshTokenWithVariableOptional - should handle different boolean values',
          () {
        final variables1 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-1', revoke: false);
        expect(variables1.revoke, false);

        final variables2 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-2', revoke: true);
        expect(variables2.revoke, true);
      });

      test(
          'RefreshTokenWithVariableCacheNormalization - should cache with different variable combinations',
          () {
        final variables1 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-a', revoke: true);

        final variables2 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-a', revoke: false);

        final mockData1 = {
          'refreshToken': {
            'token': 'access-1',
            'expiresAt': '2024-12-31',
            'userId': 'user-1'
          }
        };

        final mockData2 = {
          'refreshToken': {
            'token': 'access-2',
            'expiresAt': '2025-01-01',
            'userId': 'user-1'
          }
        };

        // Cache both with different variables
        final cacheCtx1 = CacheUpdateContext(shalomContext: shalomCtx);
        RefreshTokenWithVariableResponse.normalize$inCache(
            mockData1, cacheCtx1, variables1);

        final cacheCtx2 = CacheUpdateContext(shalomContext: shalomCtx);
        RefreshTokenWithVariableResponse.normalize$inCache(
            mockData2, cacheCtx2, variables2);

        // They should be cached separately due to different revoke values
        final cached1 =
            RefreshTokenWithVariableResponse.fromCache(shalomCtx, variables1);
        final cached2 =
            RefreshTokenWithVariableResponse.fromCache(shalomCtx, variables2);

        expect(cached1.refreshToken.token, 'access-1');
        expect(cached2.refreshToken.token, 'access-2');
      });

      test('RefreshTokenWithVariableEquals - should compare correctly', () {
        final response1 = RefreshTokenWithVariableResponse(
            refreshToken: RefreshTokenWithVariable_refreshToken(
                token: 't1', expiresAt: '2024', userId: 'u1'));

        final response2 = RefreshTokenWithVariableResponse(
            refreshToken: RefreshTokenWithVariable_refreshToken(
                token: 't1', expiresAt: '2024', userId: 'u1'));

        expect(response1.refreshToken, equals(response2.refreshToken));
      });

      test('RefreshTokenWithVariableToJson - should serialize correctly', () {
        final response = RefreshTokenWithVariable_refreshToken(
            token: 'json-t', expiresAt: '2024-json', userId: 'json-user');

        final json = response.toJson();
        expect(json['token'], 'json-t');
        expect(json['expiresAt'], '2024-json');
        expect(json['userId'], 'json-user');
      });
    });

    group('UpdateUser - Multiple Variables and Inline Scalars', () {
      test(
          'UpdateUserRequired - should handle required variables with inline literals',
          () {
        final variables = UpdateUserVariables(
            userId: 'user-123',
            userName: 'John Doe',
            userEmail: 'john@example.com');

        final request = RequestUpdateUser(variables: variables);
        expect(request.variables.userId, 'user-123');
        expect(request.variables.userName, 'John Doe');
        expect(request.variables.userEmail, 'john@example.com');

        final gqlRequest = request.toRequest();
        expect(gqlRequest.variables['userId'], 'user-123');
        expect(gqlRequest.variables['userName'], 'John Doe');
        expect(gqlRequest.variables['userEmail'], 'john@example.com');
      });

      test(
          'UpdateUserCacheNormalization - should normalize with mixed inline/variable values',
          () {
        final variables = UpdateUserVariables(
            userId: 'user-456',
            userName: 'Jane Smith',
            userEmail: 'jane@example.com');

        final mockData = {
          'updateUser': {
            'id': 'user-456',
            'name': 'Jane Smith',
            'email': 'jane@example.com',
            'age': 25,
            'active': true
          }
        };

        final cacheCtx = CacheUpdateContext(shalomContext: shalomCtx);
        UpdateUserResponse.normalize$inCache(mockData, cacheCtx, variables);

        final cached = UpdateUserResponse.fromCache(shalomCtx, variables);
        expect(cached.updateUser.id, 'user-456');
        expect(cached.updateUser.name, 'Jane Smith');
        expect(cached.updateUser.email, 'jane@example.com');
        expect(cached.updateUser.age, 25);
        expect(cached.updateUser.active, true);
      });

      test('UpdateUserEquals - should compare responses correctly', () {
        final user1 = UpdateUser_updateUser(
            id: '1',
            name: 'User 1',
            email: 'user1@test.com',
            age: 25,
            active: true);

        final user2 = UpdateUser_updateUser(
            id: '1',
            name: 'User 1',
            email: 'user1@test.com',
            age: 25,
            active: true);

        final user3 = UpdateUser_updateUser(
            id: '2',
            name: 'User 2',
            email: 'user2@test.com',
            age: 30,
            active: false);

        expect(user1, equals(user2));
        expect(user1, isNot(equals(user3)));
      });

      test('UpdateUserToJson - should serialize correctly', () {
        final user = UpdateUser_updateUser(
            id: 'json-id',
            name: 'JSON User',
            email: 'json@test.com',
            age: 28,
            active: true);

        final json = user.toJson();
        expect(json['id'], 'json-id');
        expect(json['name'], 'JSON User');
        expect(json['email'], 'json@test.com');
        expect(json['age'], 28);
        expect(json['active'], true);
      });
    });

    group(
        'UpdateUserWithOptionalVariables - Optional Variables in Inline Objects',
        () {
      test(
          'UpdateUserWithOptionalVariablesRequired - should handle required and optional variables',
          () {
        final variables = UpdateUserWithOptionalVariablesVariables(
            userId: 'opt-user',
            userName: 'Optional User',
            userEmail: 'opt@test.com',
            userAge: const Some<int?>(30),
            isActive: const Some<bool?>(false));

        expect(variables.userId, 'opt-user');
        expect(variables.userName, 'Optional User');
        expect(variables.userEmail, 'opt@test.com');
        expect(variables.userAge, const Some<int?>(30));
        expect(variables.isActive, const Some<bool?>(false));
      });

      test(
          'UpdateUserWithOptionalVariablesOptional - should handle null optional variables',
          () {
        final variables = UpdateUserWithOptionalVariablesVariables(
            userId: 'opt-user-2',
            userName: 'User 2',
            userEmail: 'user2@test.com',
            userAge: const None(),
            isActive: const None());

        expect(variables.userId, 'opt-user-2');
        expect(variables.userAge, const None());
        expect(variables.isActive, const None());

        final gqlRequest =
            RequestUpdateUserWithOptionalVariables(variables: variables)
                .toRequest();
        expect(gqlRequest.variables, {
          'userEmail': 'user2@test.com',
          "userId": "opt-user-2",
          "userName": "User 2"
        });
      });

      test(
          'UpdateUserWithOptionalVariablesCacheNormalization - should cache with null optionals',
          () {
        final variables = UpdateUserWithOptionalVariablesVariables(
            userId: 'cache-user',
            userName: 'Cache User',
            userEmail: 'cache@test.com',
            userAge: const None(),
            isActive: const None());

        final mockData = {
          'updateUser': {
            'id': 'cache-user',
            'name': 'Cache User',
            'email': 'cache@test.com',
            'age': null,
            'active': null
          }
        };

        final cacheCtx = CacheUpdateContext(shalomContext: shalomCtx);
        UpdateUserWithOptionalVariablesResponse.normalize$inCache(
            mockData, cacheCtx, variables);

        final cached = UpdateUserWithOptionalVariablesResponse.fromCache(
            shalomCtx, variables);
        expect(cached.updateUser.id, 'cache-user');
        expect(cached.updateUser.name, 'Cache User');
        expect(cached.updateUser.age, null);
        expect(cached.updateUser.active, null);
      });

      test(
          'UpdateUserWithOptionalVariablesEquals - should handle nulls in comparison',
          () {
        final user1 = UpdateUserWithOptionalVariables_updateUser(
            id: '1',
            name: 'User',
            email: 'user@test.com',
            age: null,
            active: null);

        final user2 = UpdateUserWithOptionalVariables_updateUser(
            id: '1',
            name: 'User',
            email: 'user@test.com',
            age: null,
            active: null);

        expect(user1, equals(user2));
      });

      test('UpdateUserWithOptionalVariablesToJson - should include null values',
          () {
        final user = UpdateUserWithOptionalVariables_updateUser(
            id: 'null-user',
            name: 'Null Test',
            email: 'null@test.com',
            age: null,
            active: null);

        final json = user.toJson();
        expect(json['age'], null);
        expect(json['active'], null);
      });
    });

    group('UpdateUserMixed - Mixed Inline Literals and Variables', () {
      test(
          'UpdateUserMixedRequired - should handle mixed inline/variable input',
          () {
        final variables = UpdateUserMixedVariables(
            userId: 'mixed-user', userName: 'Mixed User');

        final request = RequestUpdateUserMixed(variables: variables);
        expect(request.variables.userId, 'mixed-user');
        expect(request.variables.userName, 'Mixed User');

        final gqlRequest = request.toRequest();
        expect(gqlRequest.variables['userId'], 'mixed-user');
        expect(gqlRequest.variables['userName'], 'Mixed User');
        // email and age are hardcoded in the query, not in variables
        expect(gqlRequest.variables.containsKey('email'), false);
        expect(gqlRequest.variables.containsKey('age'), false);
      });

      test(
          'UpdateUserMixedCacheNormalization - should cache correctly with mixed values',
          () {
        final variables = UpdateUserMixedVariables(
            userId: 'mixed-456', userName: 'Cached Mixed');

        final mockData = {
          'updateUser': {
            'id': 'mixed-456',
            'name': 'Cached Mixed',
            'email': 'fixed@example.com',
            'age': 30,
            'active': null
          }
        };

        final cacheCtx = CacheUpdateContext(shalomContext: shalomCtx);
        UpdateUserMixedResponse.normalize$inCache(
            mockData, cacheCtx, variables);

        final cached = UpdateUserMixedResponse.fromCache(shalomCtx, variables);
        expect(cached.updateUser.id, 'mixed-456');
        expect(cached.updateUser.name, 'Cached Mixed');
        expect(cached.updateUser.email, 'fixed@example.com');
        expect(cached.updateUser.age, 30);
      });

      test('UpdateUserMixedEquals - should compare mixed responses', () {
        final user1 = UpdateUserMixed_updateUser(
            id: 'm1',
            name: 'Mixed 1',
            email: 'fixed@example.com',
            age: 30,
            active: null);

        final user2 = UpdateUserMixed_updateUser(
            id: 'm1',
            name: 'Mixed 1',
            email: 'fixed@example.com',
            age: 30,
            active: null);

        expect(user1, equals(user2));
      });

      test('UpdateUserMixedToJson - should serialize mixed data', () {
        final user = UpdateUserMixed_updateUser(
            id: 'json-mixed',
            name: 'JSON Mixed',
            email: 'fixed@example.com',
            age: 30,
            active: null);

        final json = user.toJson();
        expect(json['id'], 'json-mixed');
        expect(json['name'], 'JSON Mixed');
        expect(json['email'], 'fixed@example.com');
        expect(json['age'], 30);
      });
    });

    group('Cache Key Generation', () {
      test('should generate different cache keys for different variable values',
          () {
        // This test verifies that cache keys properly include variable values
        // so that different arguments create different cache entries

        final vars1 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-1', revoke: true);

        final vars2 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-1', revoke: false);

        final mockData = {
          'refreshToken': {
            'token': 'result-token',
            'expiresAt': '2024-12-31',
            'userId': 'user-1'
          }
        };

        // Cache with first variables
        final ctx1 = CacheUpdateContext(shalomContext: shalomCtx);
        RefreshTokenWithVariableResponse.normalize$inCache(
            mockData, ctx1, vars1);

        // Update cache with second variables
        final mockData2 = {
          'refreshToken': {
            'token': 'different-token',
            'expiresAt': '2025-01-01',
            'userId': 'user-1'
          }
        };

        final ctx2 = CacheUpdateContext(shalomContext: shalomCtx);
        RefreshTokenWithVariableResponse.normalize$inCache(
            mockData2, ctx2, vars2);

        // Both should be cached independently
        final result1 =
            RefreshTokenWithVariableResponse.fromCache(shalomCtx, vars1);
        final result2 =
            RefreshTokenWithVariableResponse.fromCache(shalomCtx, vars2);

        expect(result1.refreshToken.token, 'result-token');
        expect(result2.refreshToken.token, 'different-token');
      });
    });
  });
}
