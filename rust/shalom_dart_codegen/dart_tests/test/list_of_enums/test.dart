import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetStatusesRequired.shalom.dart";
import "__graphql__/GetStatusesOptional.shalom.dart";
import "__graphql__/GetOptionalStatuses.shalom.dart";
import "__graphql__/GetStatusesFullyOptional.shalom.dart";

void main() {
  // Test data for required list
  final statusesRequiredData = {
    "statusesRequired": ["PENDING", "PROCESSING", "COMPLETED"]
  };

  final statusesRequiredDataChanged = {
    "statusesRequired": ["FAILED", "PROCESSING", "COMPLETED"]
  };

  final statusesRequiredLengthChanged = {
    "statusesRequired": ["PENDING", "PROCESSING"]
  };

  final statusesRequiredEmptyData = {"statusesRequired": []};

  group('List of Enums Required - [Status!]!', () {
    test('statusesRequired deserialize', () {
      final result =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredData);
      expect(result.statusesRequired.length, 3);
      expect(result.statusesRequired[0], Status.PENDING);
      expect(result.statusesRequired[1], Status.PROCESSING);
      expect(result.statusesRequired[2], Status.COMPLETED);
    });

    test('statusesRequired deserialize empty list', () {
      final result =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredEmptyData);
      expect(result.statusesRequired, []);
    });

    test('statusesRequired toJson', () {
      final initial =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredData);
      final json = initial.toJson();
      expect(json, statusesRequiredData);
    });

    test('statusesRequired toJson empty list', () {
      final initial =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredEmptyData);
      final json = initial.toJson();
      expect(json, statusesRequiredEmptyData);
    });

    test('statusesRequired equals', () {
      final result1 =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredData);
      final result2 =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredData);
      final result3 =
          GetStatusesRequiredResponse.fromResponse(statusesRequiredDataChanged);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('statusesRequired cacheNormalization - inner value change', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesRequiredResponse.fromResponseImpl(
        statusesRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesRequiredResponse.fromResponse(
        statusesRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesRequired[0], Status.FAILED);
    });

    test('statusesRequired cacheNormalization - list length changed', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesRequiredResponse.fromResponseImpl(
        statusesRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesRequiredResponse.fromResponse(
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
    "statusesOptional": ["COMPLETED", "FAILED"]
  };

  final statusesOptionalDataChanged = {
    "statusesOptional": ["PENDING", "FAILED"]
  };

  final statusesOptionalNullData = {"statusesOptional": null};
  final statusesOptionalEmptyData = {"statusesOptional": []};

  group('List of Enums Optional - [Status!]', () {
    test('statusesOptional deserialize', () {
      final result =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalData);
      expect(result.statusesOptional?.length, 2);
      expect(result.statusesOptional?[0], Status.COMPLETED);
      expect(result.statusesOptional?[1], Status.FAILED);
    });

    test('statusesOptional deserialize null', () {
      final result =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalNullData);
      expect(result.statusesOptional, isNull);
    });

    test('statusesOptional deserialize empty list', () {
      final result =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalEmptyData);
      expect(result.statusesOptional, []);
    });

    test('statusesOptional toJson', () {
      final initial =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalData);
      final json = initial.toJson();
      expect(json, statusesOptionalData);
    });

    test('statusesOptional toJson null', () {
      final initial =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalNullData);
      final json = initial.toJson();
      expect(json, statusesOptionalNullData);
    });

    test('statusesOptional toJson empty list', () {
      final initial =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalEmptyData);
      final json = initial.toJson();
      expect(json, statusesOptionalEmptyData);
    });

    test('statusesOptional equals', () {
      final result1 =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalData);
      final result2 =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalData);
      final result3 =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalNullData);
      final result4 =
          GetStatusesOptionalResponse.fromResponse(statusesOptionalNullData);

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });

    test('statusesOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesOptionalResponse.fromResponseImpl(
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

      final nextResult = GetStatusesOptionalResponse.fromResponse(
        statusesOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesOptional?.length, 2);
    });

    test('statusesOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesOptionalResponse.fromResponseImpl(
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

      final nextResult = GetStatusesOptionalResponse.fromResponse(
        statusesOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesOptional, isNull);
    });

    test('statusesOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetStatusesOptionalResponse.fromResponseImpl(
        statusesOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesOptionalResponse.fromResponse(
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
    "optionalStatuses": ["PROCESSING", null, "COMPLETED"]
  };

  final optionalStatusesDataChanged = {
    "optionalStatuses": ["PENDING", null, "COMPLETED"]
  };

  group('Optional Enums in List - [Status]!', () {
    test('optionalStatuses deserialize with nulls', () {
      final result =
          GetOptionalStatusesResponse.fromResponse(optionalStatusesData);
      expect(result.optionalStatuses.length, 3);
      expect(result.optionalStatuses[0], Status.PROCESSING);
      expect(result.optionalStatuses[1], isNull);
      expect(result.optionalStatuses[2], Status.COMPLETED);
    });

    test('optionalStatuses toJson', () {
      final initial =
          GetOptionalStatusesResponse.fromResponse(optionalStatusesData);
      final json = initial.toJson();
      expect(json, optionalStatusesData);
    });

    test('optionalStatuses equals', () {
      final result1 =
          GetOptionalStatusesResponse.fromResponse(optionalStatusesData);
      final result2 =
          GetOptionalStatusesResponse.fromResponse(optionalStatusesData);
      final result3 =
          GetOptionalStatusesResponse.fromResponse(optionalStatusesDataChanged);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalStatuses cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetOptionalStatusesResponse.fromResponseImpl(
        optionalStatusesData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetOptionalStatusesResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetOptionalStatusesResponse.fromResponse(
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
    "statusesFullyOptional": ["FAILED", null]
  };

  final statusesFullyOptionalDataChanged = {
    "statusesFullyOptional": ["COMPLETED", null]
  };

  final statusesFullyOptionalNullData = {"statusesFullyOptional": null};
  final statusesFullyOptionalEmptyData = {"statusesFullyOptional": []};

  group('Fully Optional - [Status]', () {
    test('statusesFullyOptional deserialize with nulls', () {
      final result = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalData);
      expect(result.statusesFullyOptional?.length, 2);
      expect(result.statusesFullyOptional?[0], Status.FAILED);
      expect(result.statusesFullyOptional?[1], isNull);
    });

    test('statusesFullyOptional deserialize null', () {
      final result = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalNullData);
      expect(result.statusesFullyOptional, isNull);
    });

    test('statusesFullyOptional deserialize empty list', () {
      final result = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalEmptyData);
      expect(result.statusesFullyOptional, []);
    });

    test('statusesFullyOptional toJson', () {
      final initial = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalData);
      final json = initial.toJson();
      expect(json, statusesFullyOptionalData);
    });

    test('statusesFullyOptional toJson null', () {
      final initial = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalNullData);
      final json = initial.toJson();
      expect(json, statusesFullyOptionalNullData);
    });

    test('statusesFullyOptional equals', () {
      final result1 = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalData);
      final result2 = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalData);
      final result3 = GetStatusesFullyOptionalResponse.fromResponse(
          statusesFullyOptionalNullData);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('statusesFullyOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetStatusesFullyOptionalResponse.fromResponseImpl(
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

      final nextResult = GetStatusesFullyOptionalResponse.fromResponse(
        statusesFullyOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesFullyOptional?.length, 2);
    });

    test('statusesFullyOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetStatusesFullyOptionalResponse.fromResponseImpl(
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

      final nextResult = GetStatusesFullyOptionalResponse.fromResponse(
        statusesFullyOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesFullyOptional, isNull);
    });

    test('statusesFullyOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetStatusesFullyOptionalResponse.fromResponseImpl(
        statusesFullyOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetStatusesFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetStatusesFullyOptionalResponse.fromResponse(
        statusesFullyOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.statusesFullyOptional?[0], Status.COMPLETED);
    });
  });
}
