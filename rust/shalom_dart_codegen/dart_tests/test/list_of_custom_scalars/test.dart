import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "point.dart";
import "__graphql__/GetPointsRequired.shalom.dart";
import "__graphql__/GetPointsOptional.shalom.dart";
import "__graphql__/GetOptionalPoints.shalom.dart";
import "__graphql__/GetPointsFullyOptional.shalom.dart";

void main() {
  // Test data for required list
  final pointsRequiredData = {
    "pointsRequired": [
      {"x": 1.0, "y": 2.0},
      {"x": 3.0, "y": 4.0},
      {"x": 5.0, "y": 6.0}
    ]
  };

  final pointsRequiredDataChanged = {
    "pointsRequired": [
      {"x": 1.5, "y": 2.0},
      {"x": 3.0, "y": 4.0},
      {"x": 5.0, "y": 6.0}
    ]
  };

  final pointsRequiredLengthChanged = {
    "pointsRequired": [
      {"x": 1.0, "y": 2.0},
      {"x": 3.0, "y": 4.0}
    ]
  };

  final pointsRequiredEmptyData = {"pointsRequired": []};

  group('List of Custom Scalars Required - [Point!]!', () {
    test('pointsRequired deserialize', () {
      final result = GetPointsRequiredResponse.fromResponse(pointsRequiredData);
      expect(result.pointsRequired.length, 3);
      expect(result.pointsRequired[0].x, 1.0);
      expect(result.pointsRequired[0].y, 2.0);
      expect(result.pointsRequired[1].x, 3.0);
      expect(result.pointsRequired[1].y, 4.0);
      expect(result.pointsRequired[2].x, 5.0);
      expect(result.pointsRequired[2].y, 6.0);
    });

    test('pointsRequired deserialize empty list', () {
      final result =
          GetPointsRequiredResponse.fromResponse(pointsRequiredEmptyData);
      expect(result.pointsRequired, []);
    });

    test('pointsRequired toJson', () {
      final initial =
          GetPointsRequiredResponse.fromResponse(pointsRequiredData);
      final json = initial.toJson();
      expect(json, pointsRequiredData);
    });

    test('pointsRequired toJson empty list', () {
      final initial =
          GetPointsRequiredResponse.fromResponse(pointsRequiredEmptyData);
      final json = initial.toJson();
      expect(json, pointsRequiredEmptyData);
    });

    test('pointsRequired equals', () {
      final result1 =
          GetPointsRequiredResponse.fromResponse(pointsRequiredData);
      final result2 =
          GetPointsRequiredResponse.fromResponse(pointsRequiredData);
      final result3 =
          GetPointsRequiredResponse.fromResponse(pointsRequiredDataChanged);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('pointsRequired cacheNormalization - inner value change', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsRequiredResponse.fromResponseImpl(
        pointsRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsRequiredResponse.fromResponse(
        pointsRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsRequired[0].x, 1.5);
    });

    test('pointsRequired cacheNormalization - list length changed', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsRequiredResponse.fromResponseImpl(
        pointsRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsRequiredResponse.fromResponse(
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
      {"x": 10.0, "y": 20.0},
      {"x": 30.0, "y": 40.0}
    ]
  };

  final pointsOptionalDataChanged = {
    "pointsOptional": [
      {"x": 15.0, "y": 20.0},
      {"x": 30.0, "y": 40.0}
    ]
  };

  final pointsOptionalNullData = {"pointsOptional": null};
  final pointsOptionalEmptyData = {"pointsOptional": []};

  group('List of Custom Scalars Optional - [Point!]', () {
    test('pointsOptional deserialize', () {
      final result = GetPointsOptionalResponse.fromResponse(pointsOptionalData);
      expect(result.pointsOptional?.length, 2);
      expect(result.pointsOptional?[0].x, 10.0);
      expect(result.pointsOptional?[0].y, 20.0);
      expect(result.pointsOptional?[1].x, 30.0);
      expect(result.pointsOptional?[1].y, 40.0);
    });

    test('pointsOptional deserialize null', () {
      final result =
          GetPointsOptionalResponse.fromResponse(pointsOptionalNullData);
      expect(result.pointsOptional, isNull);
    });

    test('pointsOptional deserialize empty list', () {
      final result =
          GetPointsOptionalResponse.fromResponse(pointsOptionalEmptyData);
      expect(result.pointsOptional, []);
    });

    test('pointsOptional toJson', () {
      final initial =
          GetPointsOptionalResponse.fromResponse(pointsOptionalData);
      final json = initial.toJson();
      expect(json, pointsOptionalData);
    });

    test('pointsOptional toJson null', () {
      final initial =
          GetPointsOptionalResponse.fromResponse(pointsOptionalNullData);
      final json = initial.toJson();
      expect(json, pointsOptionalNullData);
    });

    test('pointsOptional toJson empty list', () {
      final initial =
          GetPointsOptionalResponse.fromResponse(pointsOptionalEmptyData);
      final json = initial.toJson();
      expect(json, pointsOptionalEmptyData);
    });

    test('pointsOptional equals', () {
      final result1 =
          GetPointsOptionalResponse.fromResponse(pointsOptionalData);
      final result2 =
          GetPointsOptionalResponse.fromResponse(pointsOptionalData);
      final result3 =
          GetPointsOptionalResponse.fromResponse(pointsOptionalNullData);
      final result4 =
          GetPointsOptionalResponse.fromResponse(pointsOptionalNullData);

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });

    test('pointsOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsOptionalResponse.fromResponseImpl(
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

      final nextResult = GetPointsOptionalResponse.fromResponse(
        pointsOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsOptional?.length, 2);
    });

    test('pointsOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsOptionalResponse.fromResponseImpl(
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

      final nextResult = GetPointsOptionalResponse.fromResponse(
        pointsOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsOptional, isNull);
    });

    test('pointsOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsOptionalResponse.fromResponseImpl(
        pointsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsOptionalResponse.fromResponse(
        pointsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsOptional?[0].x, 15.0);
    });
  });

  // Test data for optional items in list
  final optionalPointsData = {
    "optionalPoints": [
      {"x": 100.0, "y": 200.0},
      null,
      {"x": 300.0, "y": 400.0}
    ]
  };

  final optionalPointsDataChanged = {
    "optionalPoints": [
      {"x": 150.0, "y": 200.0},
      null,
      {"x": 300.0, "y": 400.0}
    ]
  };

  group('Optional Custom Scalars in List - [Point]!', () {
    test('optionalPoints deserialize with nulls', () {
      final result = GetOptionalPointsResponse.fromResponse(optionalPointsData);
      expect(result.optionalPoints.length, 3);
      expect(result.optionalPoints[0]?.x, 100.0);
      expect(result.optionalPoints[0]?.y, 200.0);
      expect(result.optionalPoints[1], isNull);
      expect(result.optionalPoints[2]?.x, 300.0);
      expect(result.optionalPoints[2]?.y, 400.0);
    });

    test('optionalPoints toJson', () {
      final initial =
          GetOptionalPointsResponse.fromResponse(optionalPointsData);
      final json = initial.toJson();
      expect(json, optionalPointsData);
    });

    test('optionalPoints equals', () {
      final result1 =
          GetOptionalPointsResponse.fromResponse(optionalPointsData);
      final result2 =
          GetOptionalPointsResponse.fromResponse(optionalPointsData);
      final result3 =
          GetOptionalPointsResponse.fromResponse(optionalPointsDataChanged);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalPoints cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetOptionalPointsResponse.fromResponseImpl(
        optionalPointsData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetOptionalPointsResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetOptionalPointsResponse.fromResponse(
        optionalPointsDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.optionalPoints[0]?.x, 150.0);
    });
  });

  // Test data for fully optional
  final pointsFullyOptionalData = {
    "pointsFullyOptional": [
      {"x": 7.0, "y": 8.0},
      null
    ]
  };

  final pointsFullyOptionalDataChanged = {
    "pointsFullyOptional": [
      {"x": 7.5, "y": 8.0},
      null
    ]
  };

  final pointsFullyOptionalNullData = {"pointsFullyOptional": null};
  final pointsFullyOptionalEmptyData = {"pointsFullyOptional": []};

  group('Fully Optional - [Point]', () {
    test('pointsFullyOptional deserialize with nulls', () {
      final result =
          GetPointsFullyOptionalResponse.fromResponse(pointsFullyOptionalData);
      expect(result.pointsFullyOptional?.length, 2);
      expect(result.pointsFullyOptional?[0]?.x, 7.0);
      expect(result.pointsFullyOptional?[0]?.y, 8.0);
      expect(result.pointsFullyOptional?[1], isNull);
    });

    test('pointsFullyOptional deserialize null', () {
      final result = GetPointsFullyOptionalResponse.fromResponse(
          pointsFullyOptionalNullData);
      expect(result.pointsFullyOptional, isNull);
    });

    test('pointsFullyOptional deserialize empty list', () {
      final result = GetPointsFullyOptionalResponse.fromResponse(
          pointsFullyOptionalEmptyData);
      expect(result.pointsFullyOptional, []);
    });

    test('pointsFullyOptional toJson', () {
      final initial =
          GetPointsFullyOptionalResponse.fromResponse(pointsFullyOptionalData);
      final json = initial.toJson();
      expect(json, pointsFullyOptionalData);
    });

    test('pointsFullyOptional toJson null', () {
      final initial = GetPointsFullyOptionalResponse.fromResponse(
          pointsFullyOptionalNullData);
      final json = initial.toJson();
      expect(json, pointsFullyOptionalNullData);
    });

    test('pointsFullyOptional equals', () {
      final result1 =
          GetPointsFullyOptionalResponse.fromResponse(pointsFullyOptionalData);
      final result2 =
          GetPointsFullyOptionalResponse.fromResponse(pointsFullyOptionalData);
      final result3 = GetPointsFullyOptionalResponse.fromResponse(
          pointsFullyOptionalNullData);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('pointsFullyOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsFullyOptionalResponse.fromResponseImpl(
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

      final nextResult = GetPointsFullyOptionalResponse.fromResponse(
        pointsFullyOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsFullyOptional?.length, 2);
    });

    test('pointsFullyOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsFullyOptionalResponse.fromResponseImpl(
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

      final nextResult = GetPointsFullyOptionalResponse.fromResponse(
        pointsFullyOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsFullyOptional, isNull);
    });

    test('pointsFullyOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetPointsFullyOptionalResponse.fromResponseImpl(
        pointsFullyOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPointsFullyOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPointsFullyOptionalResponse.fromResponse(
        pointsFullyOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.pointsFullyOptional?[0]?.x, 7.5);
    });
  });
}
