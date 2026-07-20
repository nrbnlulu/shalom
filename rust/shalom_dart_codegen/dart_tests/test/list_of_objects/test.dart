import 'package:test/test.dart';
import "__graphql__/GetUsersRequired.shalom.dart";
import "__graphql__/GetUsersOptional.shalom.dart";
import "__graphql__/GetOptionalUsers.shalom.dart";
import "__graphql__/GetUsersRequiredPartial.shalom.dart";

void main() {
  final usersRequiredData = {
    "usersRequired": [
      {"id": "1", "name": "Alice", "email": "alice@example.com", "age": 30},
      {"id": "2", "name": "Bob", "email": "bob@example.com", "age": 25},
      {"id": "3", "name": "Charlie", "email": "charlie@example.com", "age": 35},
    ],
  };

  final usersRequiredDataChanged = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice Updated",
        "email": "alice@example.com",
        "age": 31,
      },
      {"id": "2", "name": "Bob", "email": "bob@example.com", "age": 25},
      {"id": "3", "name": "Charlie", "email": "charlie@example.com", "age": 35},
    ],
  };

  final usersRequiredDataLengthChanged = {
    "usersRequired": [
      {"id": "1", "name": "Alice", "email": "alice@example.com", "age": 30},
      {"id": "2", "name": "Bob", "email": "bob@example.com", "age": 25},
    ],
  };

  final usersRequiredDataIdChanged = {
    "usersRequired": [
      {"id": "1", "name": "Alice", "email": "alice@example.com", "age": 30},
      {"id": "4", "name": "David", "email": "david@example.com", "age": 28},
      {"id": "3", "name": "Charlie", "email": "charlie@example.com", "age": 35},
    ],
  };

  final usersRequiredEmptyData = {"usersRequired": []};

  group('List of Objects Required', () {
    test('usersRequired deserialize', () {
      final result = GetUsersRequiredData.fromJson(usersRequiredData);
      expect(result.usersRequired.length, 3);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[0].age, 30);
      expect(result.usersRequired[1].id, "2");
      expect(result.usersRequired[1].name, "Bob");
    });

    test('usersRequired deserialize with empty list', () {
      final result = GetUsersRequiredData.fromJson(usersRequiredEmptyData);
      expect(result.usersRequired, []);
    });

    test('usersRequired toJson', () {
      final initial = GetUsersRequiredData.fromJson(usersRequiredData);
      final json = initial.toJson();
      expect(json, usersRequiredData);
    });

    test('usersRequired toJson with empty list', () {
      final initial = GetUsersRequiredData.fromJson(usersRequiredEmptyData);
      final json = initial.toJson();
      expect(json, usersRequiredEmptyData);
    });
  });

  final usersOptionalData = {
    "usersOptional": [
      {"id": "1", "name": "Alice", "email": "alice@example.com"},
      {"id": "2", "name": "Bob", "email": "bob@example.com"},
    ],
  };

  final usersOptionalDataChanged = {
    "usersOptional": [
      {"id": "1", "name": "Alice Updated", "email": "alice@example.com"},
      {"id": "2", "name": "Bob", "email": "bob@example.com"},
    ],
  };

  final usersOptionalNullData = {"usersOptional": null};
  final usersOptionalEmptyData = {"usersOptional": []};

  group('List of Objects Optional', () {
    test('usersOptional deserialize', () {
      final result = GetUsersOptionalData.fromJson(usersOptionalData);
      expect(result.usersOptional?.length, 2);
      expect(result.usersOptional?[0].id, "1");
      expect(result.usersOptional?[0].name, "Alice");
    });

    test('usersOptional deserialize with null', () {
      final result = GetUsersOptionalData.fromJson(usersOptionalNullData);
      expect(result.usersOptional, isNull);
    });

    test('usersOptional deserialize with empty list', () {
      final result = GetUsersOptionalData.fromJson(usersOptionalEmptyData);
      expect(result.usersOptional, []);
    });

    test('usersOptional toJson', () {
      final initial = GetUsersOptionalData.fromJson(usersOptionalData);
      final json = initial.toJson();
      expect(json, usersOptionalData);
    });

    test('usersOptional toJson with null', () {
      final initial = GetUsersOptionalData.fromJson(usersOptionalNullData);
      final json = initial.toJson();
      expect(json, usersOptionalNullData);
    });

    test('usersOptional toJson with empty list', () {
      final initial = GetUsersOptionalData.fromJson(usersOptionalEmptyData);
      final json = initial.toJson();
      expect(json, usersOptionalEmptyData);
    });
  });

  final optionalUsersData = {
    "optionalUsers": [
      {"id": "1", "name": "Alice"},
      {"id": "2", "name": "Bob"},
    ],
  };

  final optionalUsersDataChanged = {
    "optionalUsers": [
      {"id": "1", "name": "Alice Modified"},
      {"id": "2", "name": "Bob"},
    ],
  };

  group('Optional Objects in List', () {
    test('optionalUsers deserialize', () {
      final result = GetOptionalUsersData.fromJson(optionalUsersData);
      expect(result.optionalUsers?.length, 2);
      expect(result.optionalUsers?[0]?.id, "1");
      expect(result.optionalUsers?[0]?.name, "Alice");
    });

    test('optionalUsers toJson', () {
      final initial = GetOptionalUsersData.fromJson(optionalUsersData);
      final json = initial.toJson();
      expect(json, optionalUsersData);
    });
  });
}
