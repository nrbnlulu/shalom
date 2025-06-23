import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/UpdatePointCoordsNonNull.shalom.dart';
import '__graphql__/UpdatePointCoordsOpt.shalom.dart';
import '__graphql__/UpdatePointCoordsMaybe.shalom.dart';
import '__graphql__/UpdatePointWithInputNonNull.shalom.dart';
import '__graphql__/UpdatePointWithInputCoordsMaybe.shalom.dart';
import '__graphql__/schema.shalom.dart';
import '../custom_scalar/point.dart';
import '__graphql__/updatePointWithOptCoords.shalom.dart';

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
      final req =
          RequestUpdatePointCoordsNonNull(
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
      final req =
          RequestUpdatePointCoordsOpt(
            variables: UpdatePointCoordsOptVariables(id: "test-id-1"),
          ).toRequest();
      expect(req.variables, {"id": "test-id-1", "coords": null});

      final reqWithExplicit =
          RequestUpdatePointCoordsOpt(
            variables: UpdatePointCoordsOptVariables(
              id: "test-id-2",
              coords: Point(x: 15, y: 25),
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

      final req =
          RequestUpdatePointWithInputNonNull(
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
      final req =
          RequestUpdatePointWithInputCoordsMaybe(
            variables: variables,
          ).toRequest();
      expect(req.variables, {
        "pointData": {"coords": null, "name": "Location D"},
      });
    });

    test("custom scalar InputObject (optional default value)", () {
      final variables = updatePointWithOptCoordsVariables(
        pointData: PointDataOptCoordsInput(name: "Location M"),
      );

      final req =
          RequestupdatePointWithOptCoords(variables: variables).toRequest();
      expect(req.variables, {
        "pointData": {"coords": null, "name": "Location M"},
      });

      final variablesWithCoords = updatePointWithOptCoordsVariables(
        pointData: PointDataOptCoordsInput(
          coords: Point(x: 25, y: 35),
          name: "Location N",
        ),
      );

      final reqWithCoords =
          RequestupdatePointWithOptCoords(
            variables: variablesWithCoords,
          ).toRequest();
      expect(reqWithCoords.variables, {
        "pointData": {"coords": "POINT (25, 35)", "name": "Location N"},
      });
    });
  });
}
