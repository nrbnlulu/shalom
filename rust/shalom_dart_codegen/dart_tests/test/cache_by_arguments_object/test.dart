import 'dart:async';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/getUser.shalom.dart';
import '__graphql__/filterUsers.shalom.dart';
import '__graphql__/schema.shalom.dart';

void main() {
  group('Cache by arguments object', () {
    test('getUserRequired - cache key includes variable arguments', () {
      final ctx = ShalomCtx.withCapacity();
      final variables1 = getUserVariables(id: "user1");
      final variables2 = getUserVariables(id: "user2");

      final userData1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };
      final userData2 = {
        "user": {
          "id": "user2",
          "name": "Bob",
          "email": "bob@example.com",
          "age": 30,
        },
      };

      // First request with user1
      final result1 = getUserResponse.fromResponse(
        userData1,
        ctx: ctx,
        variables: variables1,
      );
      expect(result1.user?.id, "user1");
      expect(result1.user?.name, "Alice");

      // Second request with user2 should not affect first result
      final result2 = getUserResponse.fromResponse(
        userData2,
        ctx: ctx,
        variables: variables2,
      );
      expect(result2.user?.id, "user2");
      expect(result2.user?.name, "Bob");

      // First result should still be cached and unchanged
      final cachedResult1 = getUserResponse.fromCache(ctx, variables1);
      expect(cachedResult1.user?.id, "user1");
      expect(cachedResult1.user?.name, "Alice");
    });

    test('getUserOptional - cache key handles null variables', () {
      final ctx = ShalomCtx.withCapacity();

      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      // Request with default variables should work
      final result = getUserResponse.fromResponse(
        userData,
        ctx: ctx,
        variables: getUserVariables(id: "user1"),
      );
      expect(result.user?.id, "user1");
      expect(result.user?.name, "Alice");
    });

    test(
      'getUserCacheNormalization - same variable values use same cache entry',
      () async {
        final ctx = ShalomCtx.withCapacity();
        final variables = getUserVariables(id: "user1");

        final userData1 = {
          "user": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };
        final userData1Updated = {
          "user": {
            "id": "user1",
            "name": "Alice Updated",
            "email": "alice@example.com",
            "age": 26,
          },
        };

        // First request
        var (result, updateCtx) = getUserResponse.fromResponseImpl(
          userData1,
          ctx,
          variables,
        );
        expect(result.user?.name, "Alice");
        expect(result.user?.age, 25);

        final hasChanged = Completer<bool>();
        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = getUserResponse.fromCache(newCtx, variables);
          hasChanged.complete(true);
        });

        // Update with same variable should update cache
        final updatedResult = getUserResponse.fromResponse(
          userData1Updated,
          ctx: ctx,
          variables: variables,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result.user?.name, "Alice Updated");
        expect(result.user?.age, 26);
        expect(result, equals(updatedResult));
      },
    );

    test('equals comparison works with argument-based cache keys', () {
      final variables1 = getUserVariables(id: "user1");
      final variables2 = getUserVariables(id: "user1"); // Same ID
      final variables3 = getUserVariables(id: "user2"); // Different ID

      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result1 = getUserResponse.fromResponse(
        userData,
        variables: variables1,
      );
      final result2 = getUserResponse.fromResponse(
        userData,
        variables: variables2,
      );
      final result3 = getUserResponse.fromResponse(
        userData,
        variables: variables3,
      );

      expect(result1, equals(result2)); // Same data, same variables
      expect(result1.hashCode, equals(result2.hashCode));
    });

    test('toJson serialization works with argument-based responses', () {
      final variables = getUserVariables(id: "user1");
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result = getUserResponse.fromResponse(
        userData,
        variables: variables,
      );
      final json = result.toJson();

      expect(json, equals(userData));
    });

    group('Maybe type argument handling', () {
      test('filterUsersRequired - None() vs Some(null) vs Some(value)', () {
        final ctx = ShalomCtx.withCapacity();
        final userData = {
          "userFilterMaybe": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };

        // Test None() - no filter provided
        final variablesNone = filterUsersVariables();
        final resultNone = filterUsersResponse.fromResponse(
          userData,
          ctx: ctx,
          variables: variablesNone,
        );
        expect(resultNone.userFilterMaybe.id, "user1");

        // Test Some(null) - explicitly null filter
        final variablesSomeNull = filterUsersVariables(filter: Some(null));
        final resultSomeNull = filterUsersResponse.fromResponse(
          userData,
          ctx: ctx,
          variables: variablesSomeNull,
        );
        expect(resultSomeNull.userFilterMaybe.id, "user1");

        // Test Some(value) - actual filter value
        final variablesSomeValue = filterUsersVariables(
          filter: Some(UserFilter(nameLike: "Alice")),
        );
        final (resultSomeValue, updateCtx) = filterUsersResponse
            .fromResponseImpl(userData, ctx, variablesSomeValue);
        expect(resultSomeValue.userFilterMaybe.id, "user1");

        // Verify different cache keys are created
        final cacheData = ctx.getCachedRecord("ROOT_QUERY");
        final keys = cacheData.keys.toList();
        expect(
          keys.length,
          equals(3),
          reason:
              "Should have 3 different cache keys for different Maybe states",
        );

        // Verify the specific cache key patterns
        expect(
          keys.any((k) => k.toString().contains("filter:None")),
          isTrue,
          reason: "Should have None() cache key",
        );
        expect(
          keys.any((k) => k.toString().contains("filter:Some(null)")),
          isTrue,
          reason: "Should have Some(null) cache key",
        );
        expect(
          keys.any(
            (k) => k.toString().contains(
                  "filter:Some({age: null, id: null, nameLike: Alice})",
                ),
          ),
          isTrue,
          reason: "Should have Some(value) cache key with proper toString",
        );
      });

      test('filterUsersOptional - cache keys differentiate Maybe states', () {
        final ctx = ShalomCtx.withCapacity();
        final userData = {
          "userFilterMaybe": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };

        // Cache with None()
        final variablesNone = filterUsersVariables();
        filterUsersResponse.fromResponse(
          userData,
          ctx: ctx,
          variables: variablesNone,
        );

        // Cache with Some(null) - should be separate cache entry
        final variablesSomeNull = filterUsersVariables(filter: Some(null));
        filterUsersResponse.fromResponse(
          userData,
          ctx: ctx,
          variables: variablesSomeNull,
        );

        // Cache with Some(value) - should be separate cache entry
        final variablesSomeValue = filterUsersVariables(
          filter: Some(UserFilter(nameLike: "Alice")),
        );
        filterUsersResponse.fromResponse(
          userData,
          ctx: ctx,
          variables: variablesSomeValue,
        );

        // All should be cached separately
        final cachedNone = filterUsersResponse.fromCache(ctx, variablesNone);
        final cachedSomeNull = filterUsersResponse.fromCache(
          ctx,
          variablesSomeNull,
        );
        final cachedSomeValue = filterUsersResponse.fromCache(
          ctx,
          variablesSomeValue,
        );

        expect(cachedNone.userFilterMaybe.id, "user1");
        expect(cachedSomeNull.userFilterMaybe.id, "user1");
        expect(cachedSomeValue.userFilterMaybe.id, "user1");
      });

      test(
        'filterUsersCacheNormalization - Maybe state changes update correctly',
        () async {
          final ctx = ShalomCtx.withCapacity();
          final variablesNone = filterUsersVariables();

          final userData1 = {
            "userFilterMaybe": {
              "id": "user1",
              "name": "Alice",
              "email": "alice@example.com",
              "age": 25,
            },
          };
          final userData2 = {
            "userFilterMaybe": {
              "id": "user1",
              "name": "Alice Updated",
              "email": "alice@example.com",
              "age": 26,
            },
          };

          // First request with None()
          var (result, updateCtx) = filterUsersResponse.fromResponseImpl(
            userData1,
            ctx,
            variablesNone,
          );
          expect(result.userFilterMaybe.name, "Alice");

          final hasChanged = Completer<bool>();
          final sub = ctx.subscribe(updateCtx.dependantRecords);
          sub.streamController.stream.listen((newCtx) {
            result = filterUsersResponse.fromCache(newCtx, variablesNone);
            hasChanged.complete(true);
          });

          // Update with same None() state should update cache
          final updatedResult = filterUsersResponse.fromResponse(
            userData2,
            ctx: ctx,
            variables: variablesNone,
          );

          await hasChanged.future.timeout(Duration(seconds: 1));
          expect(result.userFilterMaybe.name, "Alice Updated");
          expect(result, equals(updatedResult));
        },
      );

      test('Maybe equals comparison works correctly', () {
        final userData = {
          "userFilterMaybe": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };

        final variablesNone1 = filterUsersVariables();
        final variablesNone2 = filterUsersVariables();
        final variablesSomeNull1 = filterUsersVariables(filter: Some(null));
        final variablesSomeNull2 = filterUsersVariables(filter: Some(null));
        final variablesSomeValue1 = filterUsersVariables(
          filter: Some(UserFilter(nameLike: "Alice")),
        );
        final variablesSomeValue2 = filterUsersVariables(
          filter: Some(UserFilter(nameLike: "Alice")),
        );

        final resultNone1 = filterUsersResponse.fromResponse(
          userData,
          variables: variablesNone1,
        );
        final resultNone2 = filterUsersResponse.fromResponse(
          userData,
          variables: variablesNone2,
        );
        final resultSomeNull1 = filterUsersResponse.fromResponse(
          userData,
          variables: variablesSomeNull1,
        );
        final resultSomeNull2 = filterUsersResponse.fromResponse(
          userData,
          variables: variablesSomeNull2,
        );
        final resultSomeValue1 = filterUsersResponse.fromResponse(
          userData,
          variables: variablesSomeValue1,
        );
        final resultSomeValue2 = filterUsersResponse.fromResponse(
          userData,
          variables: variablesSomeValue2,
        );

        // Same Maybe states should be equal
        expect(resultNone1, equals(resultNone2));
        expect(resultSomeNull1, equals(resultSomeNull2));
        expect(resultSomeValue1, equals(resultSomeValue2));

        // Same Maybe states should have same hash codes
        expect(resultNone1.hashCode, equals(resultNone2.hashCode));
        expect(resultSomeNull1.hashCode, equals(resultSomeNull2.hashCode));
        expect(resultSomeValue1.hashCode, equals(resultSomeValue2.hashCode));
      });

      test('Maybe toJson serialization works correctly', () {
        final userData = {
          "userFilterMaybe": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };

        final variablesNone = filterUsersVariables();
        final variablesSomeNull = filterUsersVariables(filter: Some(null));
        final variablesSomeValue = filterUsersVariables(
          filter: Some(UserFilter(nameLike: "Alice")),
        );

        final resultNone = filterUsersResponse.fromResponse(
          userData,
          variables: variablesNone,
        );
        final resultSomeNull = filterUsersResponse.fromResponse(
          userData,
          variables: variablesSomeNull,
        );
        final resultSomeValue = filterUsersResponse.fromResponse(
          userData,
          variables: variablesSomeValue,
        );

        final jsonNone = resultNone.toJson();
        final jsonSomeNull = resultSomeNull.toJson();
        final jsonSomeValue = resultSomeValue.toJson();

        expect(jsonNone, equals(userData));
        expect(jsonSomeNull, equals(userData));
        expect(jsonSomeValue, equals(userData));
      });
    });
  });
}
