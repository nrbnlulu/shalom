import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/UpdatePointCoordsNonNull.shalom.dart';
import '__graphql__/UpdatePointCoordsOpt.shalom.dart';
import '__graphql__/UpdatePointWithInputCoordsOpt.shalom.dart';
import '__graphql__/UpdatePointWithInputNonNull.shalom.dart';
import '__graphql__/schema.shalom.dart';
import '../custom_scalar/point.dart';

void main() {
  final Point samplePoint = Point(x: 10, y: 20);
  final String samplePointRaw = "POINT (10, 20)";

  final Point updatedPoint = Point(x: 30, y: 40);
  final String updatedPointRaw = "POINT (30, 40)";

  test("required custom scalar argument", () {
    var variables = UpdatePointCoordsNonNullVariables(coords: samplePoint);
    var variablesUpdated = variables.updateWith(coords: updatedPoint);
    expect(variablesUpdated.coords, updatedPoint);
    expect(variables.toJson(), {"coords": samplePointRaw});
    final req =
        RequestUpdatePointCoordsNonNull(
          variables: UpdatePointCoordsNonNullVariables(coords: updatedPoint),
        ).toRequest();
    expect(req.variables, {"coords": updatedPointRaw});
  });

  test("optional custom scalar argument", () {
    var variables = UpdatePointCoordsOptVariables(coords: Some(samplePoint));
    var variablesUpdated = variables.updateWith(
      coords: Some(Some(updatedPoint)),
    );
    expect(variablesUpdated.coords.some(), updatedPoint);

    expect(
      RequestUpdatePointCoordsOpt(
        variables: UpdatePointCoordsOptVariables(coords: Some(null)),
      ).toRequest().variables,
      {"coords": null},
    );

    expect(
      RequestUpdatePointCoordsOpt(
        variables: UpdatePointCoordsOptVariables(coords: Some(samplePoint)),
      ).toRequest().variables,
      {"coords": samplePointRaw},
    );

    expect(
      RequestUpdatePointCoordsOpt(
        variables: UpdatePointCoordsOptVariables(coords: None()),
      ).toRequest().variables,
      {},
    );
  });

  test("required custom scalar argument in InputObject", () {
    final variables = UpdatePointWithInputNonNullVariables(
      pointData: PointDataInput(coords: samplePoint, name: "Location A"),
    );
    final updatedPointData = PointDataInput(
      coords: updatedPoint,
      name: "Location B",
    );
    final variablesUpdated = variables.updateWith(pointData: updatedPointData);
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

  test("optional custom scalar argument in InputObject", () {
    final variables = UpdatePointWithInputCoordsOptVariables(
      pointData: PointUpdateCoordsOpt(coords: Some(null), name: "Location D"),
    );
    final variablesUpdated = variables.updateWith(
      pointData: PointUpdateCoordsOpt(
        coords: Some(updatedPoint),
        name: "Location E",
      ),
    );
    expect(variablesUpdated.pointData.coords, Some<Point?>(updatedPoint));

    final req =
        RequestUpdatePointWithInputCoordsOpt(variables: variables).toRequest();
    expect(req.variables, {
      "pointData": {"coords": null, "name": "Location D"},
    });

    final variablesWithValue = UpdatePointWithInputCoordsOptVariables(
      pointData: PointUpdateCoordsOpt(
        coords: Some(samplePoint),
        name: "Location F",
      ),
    );
    final reqWithValue =
        RequestUpdatePointWithInputCoordsOpt(
          variables: variablesWithValue,
        ).toRequest();
    expect(reqWithValue.variables, {
      "pointData": {"coords": samplePointRaw, "name": "Location F"},
    });

    final variablesOmitted = UpdatePointWithInputCoordsOptVariables(
      pointData: PointUpdateCoordsOpt(coords: None(), name: "Location G"),
    );
    final reqOmitted =
        RequestUpdatePointWithInputCoordsOpt(
          variables: variablesOmitted,
        ).toRequest();
    expect(reqOmitted.variables, {
      "pointData": {"name": "Location G"},
    });
  });
}
