import "dart:async";

import "package:shalom/shalom.dart";
import 'package:test/test.dart';
import "__graphql__/GetPointsRequired.shalom.dart";
import "__graphql__/GetPointsOptional.shalom.dart";
import "__graphql__/GetOptionalPoints.shalom.dart";
import "__graphql__/GetPointsFullyOptional.shalom.dart";

void main() {
  // Test data for required list (input uses map format)
  final pointsRequiredData = {
    "pointsRequired": [
      {"x": 1, "y": 2},
      {"x": 3, "y": 4},
      {"x": 5, "y": 6},
    ],
  };

  // Expected serialized output (uses string format)
  final pointsRequiredDataSerialized = {
    "pointsRequired": ["POINT (1, 2)", "POINT (3, 4)", "POINT (5, 6)"],
  };

  final pointsRequiredDataChanged = {
    "pointsRequired": [
      {"x": 2, "y": 2},
      {"x": 3, "y": 4},
      {"x": 5, "y": 6},
    ],
  };

  final pointsRequiredLengthChanged = {
    "pointsRequired": [
      {"x": 1, "y": 2},
      {"x": 3, "y": 4},
    ],
  };

  final pointsRequiredEmptyData = {"pointsRequired": []};

  group('List of Custom Scalars Required - [Point!]!', () {
    test('pointsRequired deserialize', () {
      final result = GetPointsRequiredResponse.fromJson(pointsRequiredData);
      expect(result.pointsRequired.length, 3);
      expect(result.pointsRequired[0].x, 1);
      expect(result.pointsRequired[0].y, 2);
      expect(result.pointsRequired[1].x, 3);
      expect(result.pointsRequired[1].y, 4);
      expect(result.pointsRequired[2].x, 5);
      expect(result.pointsRequired[2].y, 6);
    });

    test('pointsRequired deserialize empty list', () {
      final result = GetPointsRequiredResponse.fromJson(
        pointsRequiredEmptyData,
      );
      expect(result.pointsRequired, []);
    });

    test('pointsRequired toJson', () {
      final initial = GetPointsRequiredResponse.fromJson(
        pointsRequiredData,
      );
      final json = initial.toJson();
      expect(json, pointsRequiredDataSerialized);
    });

    test('pointsRequired toJson empty list', () {
      final initial = GetPointsRequiredResponse.fromJson(
        pointsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, pointsRequiredEmptyData);
    });

    test('pointsRequired equals', () {
      final result1 = GetPointsRequiredResponse.fromJson(
        pointsRequiredData,
      );
      final result2 = GetPointsRequiredResponse.fromJson(
        pointsRequiredData,
      );
      final result3 = GetPointsRequiredResponse.fromJson(
        pointsRequiredDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('pointsRequired cacheNormalization - inner value change', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsRequiredResponse.fromJson(
        pointsRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsRequiredResponse.fromJson(
        pointsRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsRequired[0].x, 2);
    });

    test('pointsRequired cacheNormalization - list length changed', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsRequiredResponse.fromJson(
        pointsRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsRequiredResponse.fromJson(
        pointsRequiredLengthChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsRequired.length, 2);
    });
  });

  // Test data for optional list
  final pointsOptionalData = {
    "pointsOptional": [
      {"x": 10, "y": 20},
      {"x": 30, "y": 40},
    ],
  };

  final pointsOptionalDataSerialized = {
    "pointsOptional": ["POINT (10, 20)", "POINT (30, 40)"],
  };

  final pointsOptionalDataChanged = {
    "pointsOptional": [
      {"x": 15, "y": 20},
      {"x": 30, "y": 40},
    ],
  };

  final pointsOptionalNullData = {"pointsOptional": null};
  final pointsOptionalEmptyData = {"pointsOptional": []};

  group('List of Custom Scalars Optional - [Point!]', () {
    test('pointsOptional deserialize', () {
      final result = GetPointsOptionalResponse.fromJson(pointsOptionalData);
      expect(result.pointsOptional?.length, 2);
      expect(result.pointsOptional?[0].x, 10);
      expect(result.pointsOptional?[0].y, 20);
      expect(result.pointsOptional?[1].x, 30);
      expect(result.pointsOptional?[1].y, 40);
    });

    test('pointsOptional deserialize null', () {
      final result = GetPointsOptionalResponse.fromJson(
        pointsOptionalNullData,
      );
      expect(result.pointsOptional, isNull);
    });

    test('pointsOptional deserialize empty list', () {
      final result = GetPointsOptionalResponse.fromJson(
        pointsOptionalEmptyData,
      );
      expect(result.pointsOptional, []);
    });

    test('pointsOptional toJson', () {
      final initial = GetPointsOptionalResponse.fromJson(
        pointsOptionalData,
      );
      final json = initial.toJson();
      expect(json, pointsOptionalDataSerialized);
    });

    test('pointsOptional toJson null', () {
      final initial = GetPointsOptionalResponse.fromJson(
        pointsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, pointsOptionalNullData);
    });

    test('pointsOptional toJson empty list', () {
      final initial = GetPointsOptionalResponse.fromJson(
        pointsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, pointsOptionalEmptyData);
    });

    test('pointsOptional equals', () {
      final result1 = GetPointsOptionalResponse.fromJson(
        pointsOptionalData,
      );
      final result2 = GetPointsOptionalResponse.fromJson(
        pointsOptionalData,
      );
      final result3 = GetPointsOptionalResponse.fromJson(
        pointsOptionalNullData,
      );
      final result4 = GetPointsOptionalResponse.fromJson(
        pointsOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });

    test('pointsOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsOptionalResponse.fromJson(
        pointsOptionalNullData,
        ctx,
      );

      expect(result.pointsOptional, isNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsOptionalResponse.fromJson(
        pointsOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsOptional?.length, 2);
    });

    test('pointsOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsOptionalResponse.fromJson(
        pointsOptionalData,
        ctx,
      );

      expect(result.pointsOptional, isNotNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsOptionalResponse.fromJson(
        pointsOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsOptional, isNull);
    });

    test('pointsOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsOptionalResponse.fromJson(
        pointsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsOptionalResponse.fromJson(
        pointsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsOptional?[0].x, 15);
    });
  });

  // Test data for optional items in list
  final optionalPointsData = {
    "optionalPoints": [
      {"x": 100, "y": 200},
      null,
      {"x": 300, "y": 400},
    ],
  };

  final optionalPointsDataSerialized = {
    "optionalPoints": ["POINT (100, 200)", null, "POINT (300, 400)"],
  };

  final optionalPointsDataChanged = {
    "optionalPoints": [
      {"x": 150, "y": 200},
      null,
      {"x": 300, "y": 400},
    ],
  };

  group('Optional Custom Scalars in List - [Point]!', () {
    test('optionalPoints deserialize with nulls', () {
      final result = GetOptionalPointsResponse.fromJson(optionalPointsData);
      expect(result.optionalPoints.length, 3);
      expect(result.optionalPoints[0]?.x, 100);
      expect(result.optionalPoints[0]?.y, 200);
      expect(result.optionalPoints[1], isNull);
      expect(result.optionalPoints[2]?.x, 300);
      expect(result.optionalPoints[2]?.y, 400);
    });

    test('optionalPoints toJson', () {
      final initial = GetOptionalPointsResponse.fromJson(
        optionalPointsData,
      );
      final json = initial.toJson();
      expect(json, optionalPointsDataSerialized);
    });

    test('optionalPoints equals', () {
      final result1 = GetOptionalPointsResponse.fromJson(
        optionalPointsData,
      );
      final result2 = GetOptionalPointsResponse.fromJson(
        optionalPointsData,
      );
      final result3 = GetOptionalPointsResponse.fromJson(
        optionalPointsDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalPoints cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetOptionalPointsResponse.fromJson(
        optionalPointsData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetOptionalPointsResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetOptionalPointsResponse.fromJson(
        optionalPointsDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.optionalPoints[0]?.x, 150);
    });
  });

  // Test data for fully optional
  final pointsFullyOptionalData = {
    "pointsFullyOptional": [
      {"x": 7, "y": 8},
      null,
    ],
  };

  final pointsFullyOptionalDataSerialized = {
    "pointsFullyOptional": ["POINT (7, 8)", null],
  };

  final pointsFullyOptionalDataChanged = {
    "pointsFullyOptional": [
      {"x": 8, "y": 8},
      null,
    ],
  };

  final pointsFullyOptionalNullData = {"pointsFullyOptional": null};
  final pointsFullyOptionalEmptyData = {"pointsFullyOptional": []};

  group('Fully Optional - [Point]', () {
    test('pointsFullyOptional deserialize with nulls', () {
      final result = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
      );
      expect(result.pointsFullyOptional?.length, 2);
      expect(result.pointsFullyOptional?[0]?.x, 7);
      expect(result.pointsFullyOptional?[0]?.y, 8);
      expect(result.pointsFullyOptional?[1], isNull);
    });

    test('pointsFullyOptional deserialize null', () {
      final result = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalNullData,
      );
      expect(result.pointsFullyOptional, isNull);
    });

    test('pointsFullyOptional deserialize empty list', () {
      final result = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalEmptyData,
      );
      expect(result.pointsFullyOptional, []);
    });

    test('pointsFullyOptional toJson', () {
      final initial = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
      );
      final json = initial.toJson();
      expect(json, pointsFullyOptionalDataSerialized);
    });

    test('pointsFullyOptional toJson null', () {
      final initial = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, pointsFullyOptionalNullData);
    });

    test('pointsFullyOptional equals', () {
      final result1 = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
      );
      final result2 = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
      );
      final result3 = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('pointsFullyOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalNullData,
        ctx,
      );

      expect(result.pointsFullyOptional, isNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsFullyOptional?.length, 2);
    });

    test('pointsFullyOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
        ctx,
      );

      expect(result.pointsFullyOptional, isNotNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsFullyOptional, isNull);
    });

    test('pointsFullyOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsFullyOptionalResponse.fromJson(
        pointsFullyOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsFullyOptional?[0]?.x, 8);
    });
  });
}
