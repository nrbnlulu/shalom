import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/UpdatePointCoordsNonNull.shalom.dart';
import '__graphql__/UpdatePointCoordsOpt.shalom.dart';
import '__graphql__/UpdatePointCoordsMaybe.shalom.dart';
import '__graphql__/UpdatePointWithInputNonNull.shalom.dart';
import '__graphql__/UpdatePointWithInputCoordsOpt.shalom.dart';
import '__graphql__/UpdatePointWithInputCoordsMaybe.shalom.dart';
import '__graphql__/schema.shalom.dart';
import '../custom_scalar/point.dart';

void main() {
  final Point samplePoint = Point(x: 10, y: 20);
  final String samplePointRaw = "POINT (10, 20)";

  final Point updatedPoint = Point(x: 30, y: 40);
  final String updatedPointRaw = "POINT (30, 40)";

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

  test("maybe custom scalar argument", () {
    var variables = UpdatePointCoordsMaybeVariables(coords: Some(samplePoint));
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

  test("required custom scalar argument in InputObject", () {
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
  });

  test("maybe custom scalar argument in InputObject", () {
    final variables = UpdatePointWithInputCoordsMaybeVariables(
      pointData: PointUpdateCoordsMaybe(coords: Some(null), name: "Location H"),
    );
    final variablesUpdated = variables.updateWith(
      pointData: PointUpdateCoordsMaybe(
        coords: Some(updatedPoint),
        name: "Location I",
      ),
    );
    expect(variablesUpdated.pointData.coords, Some<Point?>(updatedPoint));
    final req =
        RequestUpdatePointWithInputCoordsMaybe(
          variables: variables,
        ).toRequest();
    expect(req.variables, {
      "pointData": {"coords": null, "name": "Location H"},
    });
  });
}
