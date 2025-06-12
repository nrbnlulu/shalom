import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';
import '__graphql__/GetLocation.shalom.dart';
import 'point.dart';

void main() {
  setUpAll(() {
    customScalars['Point'] = pointScalarImpl;
  });

  test(' required field works (id)', () {
    final responseJson = {
      "data": {
        "getLocation": {"id": "required-1", "coords": null},
      },
    };

    final result = GraphQLResult<GetLocationResponse>.fromJson(
      responseJson,
      (json) => GetLocationResponse.fromJson(json),
    );

    final location = result.data!.getLocation!;
    expect(location.id, equals("required-1"));
    expect(location.coords, isNull); // optional
  });

  test(' optional field (coords) is null-safe', () {
    final json = {"id": "has-no-coords", "coords": null};

    final location = GetLocation_getLocation.fromJson(json);
    expect(location.coords, isNull);
  });

  test(' optional field with scalar value', () {
    final json = {"id": "has-coords", "coords": "POINT (45, 67)"};

    final location = GetLocation_getLocation.fromJson(json);
    expect(location.coords!.x, equals(45));
    expect(location.coords!.y, equals(67));
  });

  test(' updateWith replaces provided fields', () {
    final original = GetLocation_getLocation(
      id: "orig-id",
      coords: Point(x: 10, y: 20),
    );

    final updated = original.updateWithJson({
      "id": "updated-id",
      "coords": "POINT (99, 88)",
    });

    expect(updated.id, equals("updated-id"));
    expect(updated.coords!.x, equals(99));
    expect(updated.coords!.y, equals(88));
  });

  test(' updateWithJson keeps previous values if not present in input', () {
    final original = GetLocation_getLocation(
      id: "sticky-id",
      coords: Point(x: 11, y: 22),
    );

    final updated = original.updateWithJson({}); // nothing passed

    expect(updated.id, equals("sticky-id"));
    expect(updated.coords!.x, equals(11));
    expect(updated.coords!.y, equals(22));
  });

  // test(' optional with default (if you support defaults)', () {
  //   // Assuming schema says something like coords: Point = "POINT (0, 0)"
  //   final json = {
  //     "id": "has-default",
  //     // coords missing
  //   };
  //
  //   final location = GetLocation_getLocation.fromJson(json);
  //
  //   // If your generator applies defaults, test it here.
  //   // If not, this should be null and you can remove this test.
  //   expect(location.coords, isNull); // or Point(0, 0)
  // });
}
