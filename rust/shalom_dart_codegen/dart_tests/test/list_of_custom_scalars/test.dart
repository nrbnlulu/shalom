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
      final result = GetPointsRequiredData.fromJson(pointsRequiredData);
      expect(result.pointsRequired.length, 3);
      expect(result.pointsRequired[0].x, 1);
      expect(result.pointsRequired[0].y, 2);
      expect(result.pointsRequired[1].x, 3);
      expect(result.pointsRequired[1].y, 4);
      expect(result.pointsRequired[2].x, 5);
      expect(result.pointsRequired[2].y, 6);
    });

    test('pointsRequired deserialize empty list', () {
      final result = GetPointsRequiredData.fromJson(
        pointsRequiredEmptyData,
      );
      expect(result.pointsRequired, []);
    });

    test('pointsRequired toJson', () {
      final initial = GetPointsRequiredData.fromJson(
        pointsRequiredData,
      );
      final json = initial.toJson();
      expect(json, pointsRequiredDataSerialized);
    });

    test('pointsRequired toJson empty list', () {
      final initial = GetPointsRequiredData.fromJson(
        pointsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, pointsRequiredEmptyData);
    });

    test('pointsRequired equals', () {
      final result1 = GetPointsRequiredData.fromJson(
        pointsRequiredData,
      );
      final result2 = GetPointsRequiredData.fromJson(
        pointsRequiredData,
      );
      final result3 = GetPointsRequiredData.fromJson(
        pointsRequiredDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
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
      final result = GetPointsOptionalData.fromJson(pointsOptionalData);
      expect(result.pointsOptional?.length, 2);
      expect(result.pointsOptional?[0].x, 10);
      expect(result.pointsOptional?[0].y, 20);
      expect(result.pointsOptional?[1].x, 30);
      expect(result.pointsOptional?[1].y, 40);
    });

    test('pointsOptional deserialize null', () {
      final result = GetPointsOptionalData.fromJson(
        pointsOptionalNullData,
      );
      expect(result.pointsOptional, isNull);
    });

    test('pointsOptional deserialize empty list', () {
      final result = GetPointsOptionalData.fromJson(
        pointsOptionalEmptyData,
      );
      expect(result.pointsOptional, []);
    });

    test('pointsOptional toJson', () {
      final initial = GetPointsOptionalData.fromJson(
        pointsOptionalData,
      );
      final json = initial.toJson();
      expect(json, pointsOptionalDataSerialized);
    });

    test('pointsOptional toJson null', () {
      final initial = GetPointsOptionalData.fromJson(
        pointsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, pointsOptionalNullData);
    });

    test('pointsOptional toJson empty list', () {
      final initial = GetPointsOptionalData.fromJson(
        pointsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, pointsOptionalEmptyData);
    });

    test('pointsOptional equals', () {
      final result1 = GetPointsOptionalData.fromJson(
        pointsOptionalData,
      );
      final result2 = GetPointsOptionalData.fromJson(
        pointsOptionalData,
      );
      final result3 = GetPointsOptionalData.fromJson(
        pointsOptionalNullData,
      );
      final result4 = GetPointsOptionalData.fromJson(
        pointsOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
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
      final result = GetOptionalPointsData.fromJson(optionalPointsData);
      expect(result.optionalPoints.length, 3);
      expect(result.optionalPoints[0]?.x, 100);
      expect(result.optionalPoints[0]?.y, 200);
      expect(result.optionalPoints[1], isNull);
      expect(result.optionalPoints[2]?.x, 300);
      expect(result.optionalPoints[2]?.y, 400);
    });

    test('optionalPoints toJson', () {
      final initial = GetOptionalPointsData.fromJson(
        optionalPointsData,
      );
      final json = initial.toJson();
      expect(json, optionalPointsDataSerialized);
    });

    test('optionalPoints equals', () {
      final result1 = GetOptionalPointsData.fromJson(
        optionalPointsData,
      );
      final result2 = GetOptionalPointsData.fromJson(
        optionalPointsData,
      );
      final result3 = GetOptionalPointsData.fromJson(
        optionalPointsDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
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
      final result = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalData,
      );
      expect(result.pointsFullyOptional?.length, 2);
      expect(result.pointsFullyOptional?[0]?.x, 7);
      expect(result.pointsFullyOptional?[0]?.y, 8);
      expect(result.pointsFullyOptional?[1], isNull);
    });

    test('pointsFullyOptional deserialize null', () {
      final result = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalNullData,
      );
      expect(result.pointsFullyOptional, isNull);
    });

    test('pointsFullyOptional deserialize empty list', () {
      final result = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalEmptyData,
      );
      expect(result.pointsFullyOptional, []);
    });

    test('pointsFullyOptional toJson', () {
      final initial = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalData,
      );
      final json = initial.toJson();
      expect(json, pointsFullyOptionalDataSerialized);
    });

    test('pointsFullyOptional toJson null', () {
      final initial = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, pointsFullyOptionalNullData);
    });

    test('pointsFullyOptional equals', () {
      final result1 = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalData,
      );
      final result2 = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalData,
      );
      final result3 = GetPointsFullyOptionalData.fromJson(
        pointsFullyOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });
  });
}
