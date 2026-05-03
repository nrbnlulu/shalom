import "dart:async";

import "package:shalom/shalom.dart";
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
      final result = GetUsersRequiredResponse.fromJson(usersRequiredData);
      expect(result.usersRequired.length, 3);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[0].age, 30);
      expect(result.usersRequired[1].id, "2");
      expect(result.usersRequired[1].name, "Bob");
    });

    test('usersRequired deserialize with empty list', () {
      final result = GetUsersRequiredResponse.fromJson(
        usersRequiredEmptyData,
      );
      expect(result.usersRequired, []);
    });

    test('usersRequired toJson', () {
      final initial = GetUsersRequiredResponse.fromJson(usersRequiredData);
      final json = initial.toJson();
      expect(json, usersRequiredData);
    });

    test('usersRequired toJson with empty list', () {
      final initial = GetUsersRequiredResponse.fromJson(
        usersRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, usersRequiredEmptyData);
    });

    test('usersRequired equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = GetUsersRequiredResponse.fromJson(
        usersRequiredData,
        ctx: ctx,
      );
      final result2 = GetUsersRequiredResponse.fromJson(
        usersRequiredData,
        ctx: ctx,
      );
      final result3 = GetUsersRequiredResponse.fromJson(
        usersRequiredDataChanged,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('usersRequired cacheNormalization - inner field change', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetUsersRequiredResponse.fromJson(
        usersRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersRequiredResponse.fromJson(
        usersRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired[0].name, "Alice Updated");
      expect(result.usersRequired[0].age, 31);
    });

    test('usersRequired cacheNormalization - list length changed', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetUsersRequiredResponse.fromJson(
        usersRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersRequiredResponse.fromJson(
        usersRequiredDataLengthChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired.length, 2);
    });

    test(
      'usersRequired cacheNormalization - object ID changed at index',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (result, updateCtx) = GetUsersRequiredResponse.fromJson(
          usersRequiredData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetUsersRequiredResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetUsersRequiredResponse.fromJson(
          usersRequiredDataIdChanged,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.usersRequired[1].id, "4");
        expect(result.usersRequired[1].name, "David");
      },
    );

    test('usersRequired cacheNormalization - no overlapping deps', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetUsersRequiredPartialResponse.fromJson(
        usersRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersRequiredPartialResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      // Change fields that are not part of the partial query (email, age only)
      final dataWithOnlyAgeChanged = {
        "usersRequired": [
          {
            "id": "1",
            "name": "Alice",
            "email": "alice_updated@example.com",
            "age": 31,
          },
          {
            "id": "2",
            "name": "Bob",
            "email": "bob_updated@example.com",
            "age": 26,
          },
          {
            "id": "3",
            "name": "Charlie",
            "email": "charlie_updated@example.com",
            "age": 36,
          },
        ],
      };

      final _ = GetUsersRequiredResponse.fromJson(
        dataWithOnlyAgeChanged,
        ctx: ctx,
      );

      // we don't expect any change as the changed fields (age, email) are not part of the deps
      await Future.delayed(Duration(milliseconds: 500));
      expect(hasChanged.isCompleted, false);

      // But name change should trigger update
      final dataWithNameChange = {
        "usersRequired": [
          {
            "id": "1",
            "name": "Alice Changed",
            "email": "alice@example.com",
            "age": 30,
          },
          {"id": "2", "name": "Bob", "email": "bob@example.com", "age": 25},
          {
            "id": "3",
            "name": "Charlie",
            "email": "charlie@example.com",
            "age": 35,
          },
        ],
      };

      final nextResult = GetUsersRequiredPartialResponse.fromJson(
        dataWithNameChange,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired[0].name, "Alice Changed");
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
      final result = GetUsersOptionalResponse.fromJson(usersOptionalData);
      expect(result.usersOptional?.length, 2);
      expect(result.usersOptional?[0].id, "1");
      expect(result.usersOptional?[0].name, "Alice");
    });

    test('usersOptional deserialize with null', () {
      final result = GetUsersOptionalResponse.fromJson(
        usersOptionalNullData,
      );
      expect(result.usersOptional, isNull);
    });

    test('usersOptional deserialize with empty list', () {
      final result = GetUsersOptionalResponse.fromJson(
        usersOptionalEmptyData,
      );
      expect(result.usersOptional, []);
    });

    test('usersOptional toJson', () {
      final initial = GetUsersOptionalResponse.fromJson(usersOptionalData);
      final json = initial.toJson();
      expect(json, usersOptionalData);
    });

    test('usersOptional toJson with null', () {
      final initial = GetUsersOptionalResponse.fromJson(
        usersOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, usersOptionalNullData);
    });

    test('usersOptional toJson with empty list', () {
      final initial = GetUsersOptionalResponse.fromJson(
        usersOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, usersOptionalEmptyData);
    });

    test('usersOptional equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = GetUsersOptionalResponse.fromJson(
        usersOptionalData,
        ctx: ctx,
      );
      final result2 = GetUsersOptionalResponse.fromJson(
        usersOptionalData,
        ctx: ctx,
      );
      final result3 = GetUsersOptionalResponse.fromJson(
        usersOptionalNullData,
        ctx: ctx,
      );
      final result4 = GetUsersOptionalResponse.fromJson(
        usersOptionalNullData,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });

    test('usersOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetUsersOptionalResponse.fromJson(
        usersOptionalNullData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersOptionalResponse.fromJson(
        usersOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersOptional?.length, 2);
    });

    test('usersOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetUsersOptionalResponse.fromJson(
        usersOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersOptionalResponse.fromJson(
        usersOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersOptional, isNull);
    });

    test('usersOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetUsersOptionalResponse.fromJson(
        usersOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersOptionalResponse.fromJson(
        usersOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersOptional?[0].name, "Alice Updated");
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
      final result = GetOptionalUsersResponse.fromJson(optionalUsersData);
      expect(result.optionalUsers?.length, 2);
      expect(result.optionalUsers?[0]?.id, "1");
      expect(result.optionalUsers?[0]?.name, "Alice");
    });

    test('optionalUsers toJson', () {
      final initial = GetOptionalUsersResponse.fromJson(optionalUsersData);
      final json = initial.toJson();
      expect(json, optionalUsersData);
    });

    test('optionalUsers equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = GetOptionalUsersResponse.fromJson(
        optionalUsersData,
        ctx: ctx,
      );
      final result2 = GetOptionalUsersResponse.fromJson(
        optionalUsersData,
        ctx: ctx,
      );
      final result3 = GetOptionalUsersResponse.fromJson(
        optionalUsersDataChanged,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalUsers cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetOptionalUsersResponse.fromJson(
        optionalUsersData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetOptionalUsersResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetOptionalUsersResponse.fromJson(
        optionalUsersDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.optionalUsers?[0]?.name, "Alice Modified");
    });
  });
}
