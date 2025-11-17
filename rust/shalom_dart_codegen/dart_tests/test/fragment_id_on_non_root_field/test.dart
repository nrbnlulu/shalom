import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/schema.shalom.dart";
import "__graphql__/UpdateUser.shalom.dart";
import "__graphql__/GetUser.shalom.dart";

void main() {
  // Test data for UpdateUser mutation with successful result
  final updateUserSuccessData = {
    "updateUser": {
      "data": {
        "id": "user1",
        "name": "Alice Smith",
        "email": "alice@example.com",
        "age": 30,
        "bio": "Software engineer",
      },
      "error": null,
    },
  };

  // Test data for UpdateUser mutation with error
  final updateUserErrorData = {
    "updateUser": {
      "data": null,
      "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid email format",
        "details": "The email must contain @ symbol",
      },
    },
  };

  // Test data for UpdateUser with both data and error (edge case)
  final updateUserBothData = {
    "updateUser": {
      "data": {
        "id": "user1",
        "name": "Bob Jones",
        "email": "bob@example.com",
        "age": 25,
        "bio": null,
      },
      "error": {
        "code": "PARTIAL_UPDATE",
        "message": "Some fields were not updated",
        "details": null,
      },
    },
  };

  // Test data for GetUser query
  final getUserData = {
    "user": {
      "id": "user1",
      "name": "Alice Smith",
      "email": "alice@example.com",
      "age": 30,
      "bio": "Software engineer",
    },
  };

  // Updated user data with changed fields
  final updateUserChangedData = {
    "updateUser": {
      "data": {
        "id": "user1",
        "name": "Alice Johnson",
        "email": "alice.j@example.com",
        "age": 31,
        "bio": "Senior Software Engineer",
      },
      "error": null,
    },
  };

  group('Fragment with ID on non-root field - UpdateUser', () {
    group('fragmentRequired - Basic field access', () {
      test('with data present', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(
            id: "user1",
            name: Some("Alice Smith"),
            email: Some("alice@example.com"),
          ),
        );
        final result = UpdateUserResponse.fromResponse(
          updateUserSuccessData,
          variables: variables,
        );

        // Access fields from the fragment on data field
        expect(result.updateUser.data?.id, "user1");
        expect(result.updateUser.data?.name, "Alice Smith");
        expect(result.updateUser.data?.email, "alice@example.com");
        expect(result.updateUser.data?.age, 30);
        expect(result.updateUser.data?.bio, "Software engineer");
        expect(result.updateUser.error, null);
      });

      test('with error present', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", email: Some("invalid-email")),
        );
        final result = UpdateUserResponse.fromResponse(
          updateUserErrorData,
          variables: variables,
        );

        // Access fields from the fragment on error field
        expect(result.updateUser.data, null);
        expect(result.updateUser.error?.code, "VALIDATION_ERROR");
        expect(result.updateUser.error?.message, "Invalid email format");
        expect(
          result.updateUser.error?.details,
          "The email must contain @ symbol",
        );
      });
    });

    group('fragmentOptional - Both fields present', () {
      test('with both data and error', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", name: Some("Bob Jones")),
        );
        final result = UpdateUserResponse.fromResponse(
          updateUserBothData,
          variables: variables,
        );

        // Both data and error should be accessible
        expect(result.updateUser.data?.id, "user1");
        expect(result.updateUser.data?.name, "Bob Jones");
        expect(result.updateUser.data?.bio, null);

        expect(result.updateUser.error?.code, "PARTIAL_UPDATE");
        expect(result.updateUser.error?.details, null);
      });
    });

    group('equals - Equality works correctly', () {
      test('equal responses', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(
            id: "user1",
            name: Some("Alice Smith"),
            email: Some("alice@example.com"),
          ),
        );
        final result1 = UpdateUserResponse.fromResponse(
          updateUserSuccessData,
          variables: variables,
        );
        final result2 = UpdateUserResponse.fromResponse(
          updateUserSuccessData,
          variables: variables,
        );

        expect(result1, equals(result2));
        expect(result1.updateUser, equals(result2.updateUser));
        expect(result1.updateUser.data, equals(result2.updateUser.data));
      });

      test('different responses', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", name: Some("Alice Smith")),
        );
        final result1 = UpdateUserResponse.fromResponse(
          updateUserSuccessData,
          variables: variables,
        );
        final result2 = UpdateUserResponse.fromResponse(
          updateUserErrorData,
          variables: variables,
        );

        expect(result1, isNot(equals(result2)));
        expect(result1.updateUser.data, isNot(equals(result2.updateUser.data)));
      });
    });

    group('toJson - Serialization works', () {
      test('with data present', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(
            id: "user1",
            name: Some("Alice Smith"),
            email: Some("alice@example.com"),
          ),
        );
        final result = UpdateUserResponse.fromResponse(
          updateUserSuccessData,
          variables: variables,
        );
        final json = result.toJson();

        expect(json, equals(updateUserSuccessData));
      });

      test('with error present', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", email: Some("invalid")),
        );
        final result = UpdateUserResponse.fromResponse(
          updateUserErrorData,
          variables: variables,
        );
        final json = result.toJson();

        expect(json, equals(updateUserErrorData));
      });
    });

    group('fragmentCacheNormalization - Cache updates correctly', () {
      test('user data is normalized by ID', () async {
        final ctx = ShalomCtx.withCapacity();
        final variables = UpdateUserVariables(
          input: UpdateUserInput(
            id: "user1",
            name: Some("Alice Smith"),
            email: Some("alice@example.com"),
          ),
        );

        // First, fetch user with GetUser query
        var (
          getUserResult,
          getUserUpdateCtx,
        ) = GetUserResponse.fromResponseImpl(
          getUserData,
          ctx,
          GetUserVariables(id: "user1"),
        );

        expect(getUserResult.user?.id, "user1");
        expect(getUserResult.user?.name, "Alice Smith");
        expect(getUserResult.user?.age, 30);

        // Set up subscription to detect changes
        final hasChanged = Completer<bool>();
        final sub = ctx.subscribe(getUserUpdateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          getUserResult = GetUserResponse.fromCache(
            newCtx,
            GetUserVariables(id: "user1"),
          );
          hasChanged.complete(true);
        });

        // Now update the user with UpdateUser mutation
        final updateResult = UpdateUserResponse.fromResponse(
          updateUserChangedData,
          variables: variables,
          ctx: ctx,
        );

        // Wait for cache update notification
        await hasChanged.future.timeout(Duration(seconds: 1));

        // The GetUser query should now return updated data because User:user1 was normalized
        expect(getUserResult.user?.id, "user1");
        expect(getUserResult.user?.name, "Alice Johnson");
        expect(getUserResult.user?.email, "alice.j@example.com");
        expect(getUserResult.user?.age, 31);
        expect(getUserResult.user?.bio, "Senior Software Engineer");

        // Also verify the mutation result has the correct data
        expect(updateResult.updateUser.data?.name, "Alice Johnson");
        expect(updateResult.updateUser.data?.age, 31);
      });

      test('null to data updates correctly', () async {
        final ctx = ShalomCtx.withCapacity();
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", email: Some("invalid")),
        );

        // Start with error (data is null)
        var (result, updateCtx) = UpdateUserResponse.fromResponseImpl(
          updateUserErrorData,
          ctx,
          variables,
        );

        expect(result.updateUser.data, null);
        expect(result.updateUser.error, isNotNull);

        // Set up subscription
        final hasChanged = Completer<bool>();
        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = UpdateUserResponse.fromCache(newCtx, variables);
          hasChanged.complete(true);
        });

        // Update to success (error becomes null, data is present)
        final _ = UpdateUserResponse.fromResponse(
          updateUserSuccessData,
          variables: variables,
          ctx: ctx,
        );

        // Wait for update
        await hasChanged.future.timeout(Duration(seconds: 1));

        expect(result.updateUser.data, isNotNull);
        expect(result.updateUser.data?.id, "user1");
        expect(result.updateUser.error, null);
      });
    });
  });
}
