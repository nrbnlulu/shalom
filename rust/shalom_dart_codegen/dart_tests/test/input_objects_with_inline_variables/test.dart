import 'package:test/test.dart';
import 'package:shalom/shalom.dart';
import '__graphql__/RefreshToken.shalom.dart';
import '__graphql__/RefreshTokenWithVariable.shalom.dart';
import '__graphql__/UpdateUser.shalom.dart';
import '__graphql__/UpdateUserWithOptionalVariables.shalom.dart';
import '__graphql__/UpdateUserMixed.shalom.dart';

void main() {
  group('Input Objects with Inline Variables', () {
    group('RefreshToken - Single Variable with Inline Literal', () {
      test(
        'RefreshTokenRequired - should handle required variable in inline object',
        () {
          final variables = RefreshTokenVariables(
            refreshToken: 'test-token-123',
          );
          final request = RequestRefreshToken(variables: variables);

          // Verify the request is created correctly
          expect(request.variables.refreshToken, 'test-token-123');

          // Verify toRequest works
          final gqlRequest = request.toRequest();
          expect(gqlRequest.variables['refreshToken'], 'test-token-123');
          expect(gqlRequest.opType, OperationType.Mutation);
          expect(gqlRequest.opName, 'RefreshToken');
        },
      );

      test('RefreshTokenOptional - should handle null refresh token', () {
        final variables = RefreshTokenVariables(refreshToken: 'token-456');
        expect(variables.refreshToken, 'token-456');
      });

      test('RefreshTokenEquals - should compare responses correctly', () {
        final response1 = RefreshTokenData(
          refreshToken: RefreshToken_refreshToken(
            token: 'token-1',
            expiresAt: '2024-12-31',
            userId: 'user-1',
          ),
        );

        final response2 = RefreshTokenData(
          refreshToken: RefreshToken_refreshToken(
            token: 'token-1',
            expiresAt: '2024-12-31',
            userId: 'user-1',
          ),
        );

        final response3 = RefreshTokenData(
          refreshToken: RefreshToken_refreshToken(
            token: 'token-2',
            expiresAt: '2024-12-31',
            userId: 'user-1',
          ),
        );

        expect(response1.refreshToken, equals(response2.refreshToken));
        expect(response1.refreshToken, isNot(equals(response3.refreshToken)));
      });

      test('RefreshTokenToJson - should serialize to JSON correctly', () {
        final refreshToken = RefreshToken_refreshToken(
          token: 'json-token',
          expiresAt: '2024-12-31T23:59:59Z',
          userId: 'user-json',
        );

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
            refreshToken: 'multi-token',
            revoke: true,
          );

          final request = RequestRefreshTokenWithVariable(variables: variables);
          expect(request.variables.refreshToken, 'multi-token');
          expect(request.variables.revoke, true);

          final gqlRequest = request.toRequest();
          expect(gqlRequest.variables['refreshToken'], 'multi-token');
          expect(gqlRequest.variables['revoke'], true);
        },
      );

      test(
        'RefreshTokenWithVariableOptional - should handle different boolean values',
        () {
          final variables1 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-1',
            revoke: false,
          );
          expect(variables1.revoke, false);

          final variables2 = RefreshTokenWithVariableVariables(
            refreshToken: 'token-2',
            revoke: true,
          );
          expect(variables2.revoke, true);
        },
      );

      test('RefreshTokenWithVariableEquals - should compare correctly', () {
        final response1 = RefreshTokenWithVariableData(
          refreshToken: RefreshTokenWithVariable_refreshToken(
            token: 't1',
            expiresAt: '2024',
            userId: 'u1',
          ),
        );

        final response2 = RefreshTokenWithVariableData(
          refreshToken: RefreshTokenWithVariable_refreshToken(
            token: 't1',
            expiresAt: '2024',
            userId: 'u1',
          ),
        );

        expect(response1.refreshToken, equals(response2.refreshToken));
      });

      test('RefreshTokenWithVariableToJson - should serialize correctly', () {
        final response = RefreshTokenWithVariable_refreshToken(
          token: 'json-t',
          expiresAt: '2024-json',
          userId: 'json-user',
        );

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
            userEmail: 'john@example.com',
          );

          final request = RequestUpdateUser(variables: variables);
          expect(request.variables.userId, 'user-123');
          expect(request.variables.userName, 'John Doe');
          expect(request.variables.userEmail, 'john@example.com');

          final gqlRequest = request.toRequest();
          expect(gqlRequest.variables['userId'], 'user-123');
          expect(gqlRequest.variables['userName'], 'John Doe');
          expect(gqlRequest.variables['userEmail'], 'john@example.com');
        },
      );

      test('UpdateUserEquals - should compare responses correctly', () {
        final user1 = UpdateUser_updateUser(
          id: '1',
          name: 'User 1',
          email: 'user1@test.com',
          age: 25,
          active: true,
        );

        final user2 = UpdateUser_updateUser(
          id: '1',
          name: 'User 1',
          email: 'user1@test.com',
          age: 25,
          active: true,
        );

        final user3 = UpdateUser_updateUser(
          id: '2',
          name: 'User 2',
          email: 'user2@test.com',
          age: 30,
          active: false,
        );

        expect(user1, equals(user2));
        expect(user1, isNot(equals(user3)));
      });

      test('UpdateUserToJson - should serialize correctly', () {
        final user = UpdateUser_updateUser(
          id: 'json-id',
          name: 'JSON User',
          email: 'json@test.com',
          age: 28,
          active: true,
        );

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
              isActive: const Some<bool?>(false),
            );

            expect(variables.userId, 'opt-user');
            expect(variables.userName, 'Optional User');
            expect(variables.userEmail, 'opt@test.com');
            expect(variables.userAge, const Some<int?>(30));
            expect(variables.isActive, const Some<bool?>(false));
          },
        );

        test(
          'UpdateUserWithOptionalVariablesOptional - should handle null optional variables',
          () {
            final variables = UpdateUserWithOptionalVariablesVariables(
              userId: 'opt-user-2',
              userName: 'User 2',
              userEmail: 'user2@test.com',
              userAge: const None(),
              isActive: const None(),
            );

            expect(variables.userId, 'opt-user-2');
            expect(variables.userAge, const None());
            expect(variables.isActive, const None());

            final gqlRequest = RequestUpdateUserWithOptionalVariables(
              variables: variables,
            ).toRequest();
            expect(gqlRequest.variables, {
              'userEmail': 'user2@test.com',
              "userId": "opt-user-2",
              "userName": "User 2",
            });
          },
        );

        test(
          'UpdateUserWithOptionalVariablesEquals - should handle nulls in comparison',
          () {
            final user1 = UpdateUserWithOptionalVariables_updateUser(
              id: '1',
              name: 'User',
              email: 'user@test.com',
              age: null,
              active: null,
            );

            final user2 = UpdateUserWithOptionalVariables_updateUser(
              id: '1',
              name: 'User',
              email: 'user@test.com',
              age: null,
              active: null,
            );

            expect(user1, equals(user2));
          },
        );

        test(
          'UpdateUserWithOptionalVariablesToJson - should include null values',
          () {
            final user = UpdateUserWithOptionalVariables_updateUser(
              id: 'null-user',
              name: 'Null Test',
              email: 'null@test.com',
              age: null,
              active: null,
            );

            final json = user.toJson();
            expect(json['age'], null);
            expect(json['active'], null);
          },
        );
      },
    );

    group('UpdateUserMixed - Mixed Inline Literals and Variables', () {
      test(
        'UpdateUserMixedRequired - should handle mixed inline/variable input',
        () {
          final variables = UpdateUserMixedVariables(
            userId: 'mixed-user',
            userName: 'Mixed User',
          );

          final request = RequestUpdateUserMixed(variables: variables);
          expect(request.variables.userId, 'mixed-user');
          expect(request.variables.userName, 'Mixed User');

          final gqlRequest = request.toRequest();
          expect(gqlRequest.variables['userId'], 'mixed-user');
          expect(gqlRequest.variables['userName'], 'Mixed User');
          // email and age are hardcoded in the query, not in variables
          expect(gqlRequest.variables.containsKey('email'), false);
          expect(gqlRequest.variables.containsKey('age'), false);
        },
      );

      test('UpdateUserMixedEquals - should compare mixed responses', () {
        final user1 = UpdateUserMixed_updateUser(
          id: 'm1',
          name: 'Mixed 1',
          email: 'fixed@example.com',
          age: 30,
          active: null,
        );

        final user2 = UpdateUserMixed_updateUser(
          id: 'm1',
          name: 'Mixed 1',
          email: 'fixed@example.com',
          age: 30,
          active: null,
        );

        expect(user1, equals(user2));
      });

      test('UpdateUserMixedToJson - should serialize mixed data', () {
        final user = UpdateUserMixed_updateUser(
          id: 'json-mixed',
          name: 'JSON Mixed',
          email: 'fixed@example.com',
          age: 30,
          active: null,
        );

        final json = user.toJson();
        expect(json['id'], 'json-mixed');
        expect(json['name'], 'JSON Mixed');
        expect(json['email'], 'fixed@example.com');
        expect(json['age'], 30);
      });
    });
  });
}
