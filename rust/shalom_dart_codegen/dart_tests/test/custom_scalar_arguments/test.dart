import 'package:dart_tests/point.dart' show Point;
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/UpdatePointCoordsNonNull.shalom.dart';
import '__graphql__/UpdatePointCoordsOpt.shalom.dart';
import '__graphql__/UpdatePointCoordsMaybe.shalom.dart';
import '__graphql__/UpdatePointWithInputNonNull.shalom.dart';
import '__graphql__/UpdatePointWithInputCoordsMaybe.shalom.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/UpdatePointWithOptCoords.shalom.dart';
import '__graphql__/UpdatePointWithRequiredDefaultValue.shalom.dart';

void main() {
  final Point samplePoint = Point(x: 10, y: 20);
  final String samplePointRaw = "POINT (10, 20)";

  final Point updatedPoint = Point(x: 30, y: 40);
  final String updatedPointRaw = "POINT (30, 40)";

  group('custom scalar direct arguments', () {
    test("required custom scalar argument", () {
      var variables = UpdatePointCoordsNonNullVariables(coords: samplePoint);
      expect(variables.toJson(), {"coords": samplePointRaw});
      var variablesUpdated = variables.updateWith(coords: updatedPoint);
      expect(variablesUpdated.coords, updatedPoint);
      final req = RequestUpdatePointCoordsNonNull(
        variables: UpdatePointCoordsNonNullVariables(coords: updatedPoint),
      ).toRequest();
      expect(req.variables, {"coords": updatedPointRaw});
    });

    test("custom scalar (argument) maybe", () {
      var variables = UpdatePointCoordsMaybeVariables(
        coords: Some(samplePoint),
      );
      var variablesUpdated = variables.updateWith(
        coords: Some(Some(updatedPoint)),
      );
      expect(variablesUpdated.coords.some(), updatedPoint);
      expect(
        RequestUpdatePointCoordsMaybe(
          variables: UpdatePointCoordsMaybeVariables(coords: Some(null)),
        ).toRequest().variables,
        {"coords": null},
      );

      expect(
        RequestUpdatePointCoordsMaybe(
          variables: UpdatePointCoordsMaybeVariables(coords: Some(samplePoint)),
        ).toRequest().variables,
        {"coords": samplePointRaw},
      );
      expect(
        RequestUpdatePointCoordsMaybe(
          variables: UpdatePointCoordsMaybeVariables(coords: None()),
        ).toRequest().variables,
        {},
      );
    });

    test("custom scalar argument with (optional default value)", () {
      final req = RequestUpdatePointCoordsOpt(
        variables: UpdatePointCoordsOptVariables(id: "test-id-1"),
      ).toRequest();
      expect(req.variables, {"id": "test-id-1", "coords": "POINT (0, 0)"});

      final reqWithExplicit = RequestUpdatePointCoordsOpt(
        variables: UpdatePointCoordsOptVariables(
          id: "test-id-2",
          coords: Some(Point(x: 15, y: 25)),
        ),
      ).toRequest();
      expect(reqWithExplicit.variables, {
        "id": "test-id-2",
        "coords": "POINT (15, 25)",
      });
    });
  });

  group('custom scalar in InputObject', () {
    test("custom scalar argument in InputObject (required)", () {
      final variables = UpdatePointWithInputNonNullVariables(
        pointData: PointDataInput(coords: samplePoint, name: "Location A"),
      );
      final variablesUpdated = variables.updateWith(
        pointData: PointDataInput(coords: updatedPoint, name: "Location B"),
      );
      expect(variablesUpdated.pointData.coords, updatedPoint);

      final req = RequestUpdatePointWithInputNonNull(
        variables: UpdatePointWithInputNonNullVariables(
          pointData: PointDataInput(
            coords: Point(x: 50, y: 60),
            name: "Location C",
          ),
        ),
      ).toRequest();
      expect(req.variables, {
        "pointData": {"coords": "POINT (50, 60)", "name": "Location C"},
      });
    });

    test("custom scalar in InputObject (maybe)", () {
      final variables = UpdatePointWithInputCoordsMaybeVariables(
        pointData: PointUpdateCoordsMaybe(
          coords: Some(null),
          name: "Location D",
        ),
      );
      final variablesUpdated = variables.updateWith(
        pointData: PointUpdateCoordsMaybe(
          coords: Some(updatedPoint),
          name: "Location E",
        ),
      );
      expect(variablesUpdated.pointData.coords, Some<Point?>(updatedPoint));
      final req = RequestUpdatePointWithInputCoordsMaybe(
        variables: variables,
      ).toRequest();
      expect(req.variables, {
        "pointData": {"coords": null, "name": "Location D"},
      });
    });

    test("custom scalar InputObject (optional default value)", () {
      final variables = UpdatePointWithOptCoordsVariables(
        pointData: PointDataOptCoordsInput(name: "Location M"),
      );

      final req = RequestUpdatePointWithOptCoords(
        variables: variables,
      ).toRequest();
      expect(req.variables, {
        "pointData": {"coords": "POINT (0, 0)", "name": "Location M"},
      });

      final variablesWithCoords = UpdatePointWithOptCoordsVariables(
        pointData: PointDataOptCoordsInput(
          coords: Some(Point(x: 25, y: 35)),
          name: "Location N",
        ),
      );

      final reqWithCoords = RequestUpdatePointWithOptCoords(
        variables: variablesWithCoords,
      ).toRequest();
      expect(reqWithCoords.variables, {
        "pointData": {"coords": "POINT (25, 35)", "name": "Location N"},
      });
    });

    test("custom scalar InputObject (required with default value)", () {
      // Test with default value (not specifying coords)
      final variables = UpdatePointWithRequiredDefaultValueVariables(
        pointData: PointDataInputRequiredWithDefaultValue(),
      );

      final req = RequestUpdatePointWithRequiredDefaultValue(
        variables: variables,
      ).toRequest();
      expect(req.variables, {
        "pointData": {"coords": "POINT (0, 0)"},
      });

      // Test with explicit value
      final variablesWithCoords = UpdatePointWithRequiredDefaultValueVariables(
        pointData: PointDataInputRequiredWithDefaultValue(
          coords: Point(x: 42, y: 84),
        ),
      );

      final reqWithCoords = RequestUpdatePointWithRequiredDefaultValue(
        variables: variablesWithCoords,
      ).toRequest();
      expect(reqWithCoords.variables, {
        "pointData": {"coords": "POINT (42, 84)"},
      });

      // Test updateWith
      final updatedVariables = variablesWithCoords.updateWith(
        pointData: PointDataInputRequiredWithDefaultValue(
          coords: Point(x: 100, y: 200),
        ),
      );
      expect(updatedVariables.pointData.coords, Point(x: 100, y: 200));

      // Test equals
      final input1 = PointDataInputRequiredWithDefaultValue(
        coords: Point(x: 10, y: 20),
      );
      final input2 = PointDataInputRequiredWithDefaultValue(
        coords: Point(x: 10, y: 20),
      );
      final input3 = PointDataInputRequiredWithDefaultValue(
        coords: Point(x: 30, y: 40),
      );
      expect(input1.toJson(), equals(input2.toJson()));
      expect(input1.toJson(), isNot(equals(input3.toJson())));

      // Test toJson
      final inputForJson = PointDataInputRequiredWithDefaultValue(
        coords: Point(x: 55, y: 66),
      );
      expect(inputForJson.toJson(), {"coords": "POINT (55, 66)"});

      // Test with default (no coords provided)
      final inputDefault = PointDataInputRequiredWithDefaultValue();
      expect(inputDefault.toJson(), {"coords": "POINT (0, 0)"});
    });
  });
}
