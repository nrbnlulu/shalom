import 'package:test/test.dart';
import 'package:shalom/shalom.dart' show Some, None;
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
        final result = UpdateUserResponse.fromJson(
          updateUserSuccessData,
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
        final result = UpdateUserResponse.fromJson(
          updateUserErrorData,
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
        final result = UpdateUserResponse.fromJson(
          updateUserBothData,
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
        final result1 = UpdateUserResponse.fromJson(
          updateUserSuccessData,
        );
        final result2 = UpdateUserResponse.fromJson(
          updateUserSuccessData,
        );

        expect(result1, equals(result2));
        expect(result1.updateUser, equals(result2.updateUser));
        expect(result1.updateUser.data, equals(result2.updateUser.data));
      });

      test('different responses', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", name: Some("Alice Smith")),
        );
        final result1 = UpdateUserResponse.fromJson(
          updateUserSuccessData,
        );
        final result2 = UpdateUserResponse.fromJson(
          updateUserErrorData,
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
        final result = UpdateUserResponse.fromJson(
          updateUserSuccessData,
        );
        final json = result.toJson();

        expect(json, equals(updateUserSuccessData));
      });

      test('with error present', () {
        final variables = UpdateUserVariables(
          input: UpdateUserInput(id: "user1", email: Some("invalid")),
        );
        final result = UpdateUserResponse.fromJson(
          updateUserErrorData,
        );
        final json = result.toJson();

        expect(json, equals(updateUserErrorData));
      });
    });
  });
}
