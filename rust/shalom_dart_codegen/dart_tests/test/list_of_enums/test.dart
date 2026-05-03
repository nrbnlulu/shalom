import "dart:async";

import "package:shalom/shalom.dart";
import 'package:test/test.dart';
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetStatusesRequired.shalom.dart";
import "__graphql__/GetStatusesOptional.shalom.dart";
import "__graphql__/GetOptionalStatuses.shalom.dart";
import "__graphql__/GetStatusesFullyOptional.shalom.dart";

void main() {
  // Test data for required list
  final statusesRequiredData = {
    "statusesRequired": ["PENDING", "PROCESSING", "COMPLETED"],
  };

  final statusesRequiredDataChanged = {
    "statusesRequired": ["FAILED", "PROCESSING", "COMPLETED"],
  };

  final statusesRequiredLengthChanged = {
    "statusesRequired": ["PENDING", "PROCESSING"],
  };

  final statusesRequiredEmptyData = {"statusesRequired": []};

  group('List of Enums Required - [Status!]!', () {
    test('statusesRequired deserialize', () {
      final result = GetStatusesRequiredResponse.fromJson(
        statusesRequiredData,
      );
      expect(result.statusesRequired.length, 3);
      expect(result.statusesRequired[0], Status.PENDING);
      expect(result.statusesRequired[1], Status.PROCESSING);
      expect(result.statusesRequired[2], Status.COMPLETED);
    });

    test('statusesRequired deserialize empty list', () {
      final result = GetStatusesRequiredResponse.fromJson(
        statusesRequiredEmptyData,
      );
      expect(result.statusesRequired, []);
    });

    test('statusesRequired toJson', () {
      final initial = GetStatusesRequiredResponse.fromJson(
        statusesRequiredData,
      );
      final json = initial.toJson();
      expect(json, statusesRequiredData);
    });

    test('statusesRequired toJson empty list', () {
      final initial = GetStatusesRequiredResponse.fromJson(
        statusesRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, statusesRequiredEmptyData);
    });

    test('statusesRequired equals', () {
      final result1 = GetStatusesRequiredResponse.fromJson(
        statusesRequiredData,
      );
      final result2 = GetStatusesRequiredResponse.fromJson(
        statusesRequiredData,
      );
      final result3 = GetStatusesRequiredResponse.fromJson(
        statusesRequiredDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('statusesRequired cacheNormalization - inner value change', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesRequiredResponse.fromJson(
        statusesRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesRequiredResponse.fromJson(
        statusesRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesRequired[0], Status.FAILED);
    });

    test('statusesRequired cacheNormalization - list length changed', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesRequiredResponse.fromJson(
        statusesRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesRequiredResponse.fromJson(
        statusesRequiredLengthChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesRequired.length, 2);
    });
  });

  // Test data for optional list
  final statusesOptionalData = {
    "statusesOptional": ["COMPLETED", "FAILED"],
  };

  final statusesOptionalDataChanged = {
    "statusesOptional": ["PENDING", "FAILED"],
  };

  final statusesOptionalNullData = {"statusesOptional": null};
  final statusesOptionalEmptyData = {"statusesOptional": []};

  group('List of Enums Optional - [Status!]', () {
    test('statusesOptional deserialize', () {
      final result = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
      );
      expect(result.statusesOptional?.length, 2);
      expect(result.statusesOptional?[0], Status.COMPLETED);
      expect(result.statusesOptional?[1], Status.FAILED);
    });

    test('statusesOptional deserialize null', () {
      final result = GetStatusesOptionalResponse.fromJson(
        statusesOptionalNullData,
      );
      expect(result.statusesOptional, isNull);
    });

    test('statusesOptional deserialize empty list', () {
      final result = GetStatusesOptionalResponse.fromJson(
        statusesOptionalEmptyData,
      );
      expect(result.statusesOptional, []);
    });

    test('statusesOptional toJson', () {
      final initial = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
      );
      final json = initial.toJson();
      expect(json, statusesOptionalData);
    });

    test('statusesOptional toJson null', () {
      final initial = GetStatusesOptionalResponse.fromJson(
        statusesOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, statusesOptionalNullData);
    });

    test('statusesOptional toJson empty list', () {
      final initial = GetStatusesOptionalResponse.fromJson(
        statusesOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, statusesOptionalEmptyData);
    });

    test('statusesOptional equals', () {
      final result1 = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
      );
      final result2 = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
      );
      final result3 = GetStatusesOptionalResponse.fromJson(
        statusesOptionalNullData,
      );
      final result4 = GetStatusesOptionalResponse.fromJson(
        statusesOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });

    test('statusesOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesOptionalResponse.fromJson(
        statusesOptionalNullData,
        ctx,
      );

      expect(result.statusesOptional, isNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesOptional?.length, 2);
    });

    test('statusesOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
        ctx,
      );

      expect(result.statusesOptional, isNotNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesOptionalResponse.fromJson(
        statusesOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesOptional, isNull);
    });

    test('statusesOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesOptionalResponse.fromJson(
        statusesOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesOptionalResponse.fromJson(
        statusesOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesOptional?[0], Status.PENDING);
    });
  });

  // Test data for optional items in list
  final optionalStatusesData = {
    "optionalStatuses": ["PROCESSING", null, "COMPLETED"],
  };

  final optionalStatusesDataChanged = {
    "optionalStatuses": ["PENDING", null, "COMPLETED"],
  };

  group('Optional Enums in List - [Status]!', () {
    test('optionalStatuses deserialize with nulls', () {
      final result = GetOptionalStatusesResponse.fromJson(
        optionalStatusesData,
      );
      expect(result.optionalStatuses.length, 3);
      expect(result.optionalStatuses[0], Status.PROCESSING);
      expect(result.optionalStatuses[1], isNull);
      expect(result.optionalStatuses[2], Status.COMPLETED);
    });

    test('optionalStatuses toJson', () {
      final initial = GetOptionalStatusesResponse.fromJson(
        optionalStatusesData,
      );
      final json = initial.toJson();
      expect(json, optionalStatusesData);
    });

    test('optionalStatuses equals', () {
      final result1 = GetOptionalStatusesResponse.fromJson(
        optionalStatusesData,
      );
      final result2 = GetOptionalStatusesResponse.fromJson(
        optionalStatusesData,
      );
      final result3 = GetOptionalStatusesResponse.fromJson(
        optionalStatusesDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalStatuses cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetOptionalStatusesResponse.fromJson(
        optionalStatusesData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetOptionalStatusesResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetOptionalStatusesResponse.fromJson(
        optionalStatusesDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.optionalStatuses[0], Status.PENDING);
    });
  });

  // Test data for fully optional
  final statusesFullyOptionalData = {
    "statusesFullyOptional": ["FAILED", null],
  };

  final statusesFullyOptionalDataChanged = {
    "statusesFullyOptional": ["COMPLETED", null],
  };

  final statusesFullyOptionalNullData = {"statusesFullyOptional": null};
  final statusesFullyOptionalEmptyData = {"statusesFullyOptional": []};

  group('Fully Optional - [Status]', () {
    test('statusesFullyOptional deserialize with nulls', () {
      final result = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
      );
      expect(result.statusesFullyOptional?.length, 2);
      expect(result.statusesFullyOptional?[0], Status.FAILED);
      expect(result.statusesFullyOptional?[1], isNull);
    });

    test('statusesFullyOptional deserialize null', () {
      final result = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalNullData,
      );
      expect(result.statusesFullyOptional, isNull);
    });

    test('statusesFullyOptional deserialize empty list', () {
      final result = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalEmptyData,
      );
      expect(result.statusesFullyOptional, []);
    });

    test('statusesFullyOptional toJson', () {
      final initial = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
      );
      final json = initial.toJson();
      expect(json, statusesFullyOptionalData);
    });

    test('statusesFullyOptional toJson null', () {
      final initial = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, statusesFullyOptionalNullData);
    });

    test('statusesFullyOptional equals', () {
      final result1 = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
      );
      final result2 = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
      );
      final result3 = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('statusesFullyOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalNullData,
        ctx,
      );

      expect(result.statusesFullyOptional, isNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesFullyOptional?.length, 2);
    });

    test('statusesFullyOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
        ctx,
      );

      expect(result.statusesFullyOptional, isNotNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesFullyOptional, isNull);
    });

    test('statusesFullyOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesFullyOptionalResponse.fromJson(
        statusesFullyOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesFullyOptional?[0], Status.COMPLETED);
    });
  });
}
