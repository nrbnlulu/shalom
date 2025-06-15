import 'package:test/test.dart';
import '__graphql__/GetLocation.shalom.dart';
import 'point.dart';

void main() {
  final point = Point(x: 10, y: 20);
  final pointRaw = "POINT (10, 20)";

  setUpAll(() {
    customScalars['Point'] = pointScalarImpl;
  });

  group('GetLocation_getLocation fromJson', () {
    test('deserializes with required and maybe fields', () {
      final result = GetLocation_getLocation.fromJson({
        'id': 'test-id-1',
        'coords': pointRaw,
      });

      expect(result.id, 'test-id-1');
      expect(result.coords, isA<Point>());
      expect(result.coords?.x, point.x);
      expect(result.coords?.y, point.y);
    });

    test('deserializes with maybe field as null', () {
      final result = GetLocation_getLocation.fromJson({
        'id': 'test-id-2',
        'coords': null,
      });

      expect(result.id, 'test-id-2');
      expect(result.coords, isNull);
    });
  });

  group('GetLocation_getLocation toJson', () {
    test('serializes with required and maybe fields', () {
      final data = GetLocation_getLocation(id: 'test-id-1', coords: point);
      final json = data.toJson();

      expect(json, {'id': 'test-id-1', 'coords': pointRaw});
    });

    test('serializes with maybe field as null', () {
      final data = GetLocation_getLocation(id: 'test-id-2', coords: null);
      final json = data.toJson();

      expect(json, {'id': 'test-id-2', 'coords': null});
    });
  });

  group('GetLocation_getLocation updateWithJson', () {
    final initial = GetLocation_getLocation(id: 'initial-id', coords: point);

    test('updates only maybe field', () {
      final updatedPoint = Point(x: 30, y: 40);
      final updatedPointRaw = "POINT (30,40)";
      final updated = initial.updateWithJson({'coords': updatedPointRaw});

      expect(updated.id, 'initial-id');
      expect(updated.coords?.x, updatedPoint.x);
      expect(initial, isNot(updated));
    });

    test('updates maybe field to null', () {
      final updated = initial.updateWithJson({'coords': null});
      expect(updated.coords, isNull);
      expect(initial, isNot(updated));
    });

    test('updates only required field', () {
      final updated = initial.updateWithJson({'id': 'updated-id'});

      expect(updated.id, 'updated-id');
      expect(updated.coords?.x, point.x);
      expect(initial, isNot(updated));
    });
  });

  group('GetLocationResponse fromJson', () {
    test('deserializes with data', () {
      final response = GetLocationResponse.fromJson({
        'getLocation': {'id': 'test-id-1', 'coords': pointRaw},
      });
      expect(response.getLocation, isNotNull);
      expect(response.getLocation?.id, 'test-id-1');
      expect(response.getLocation?.coords?.x, point.x);
    });

    test('deserializes with null data', () {
      final response = GetLocationResponse.fromJson({'getLocation': null});
      expect(response.getLocation, isNull);
    });
  });

  group('GetLocationResponse toJson', () {
    test('serializes with data', () {
      final data = GetLocationResponse(
        getLocation: GetLocation_getLocation(id: 'test-id-1', coords: point),
      );
      final json = data.toJson();

      expect(json, {
        'getLocation': {'id': 'test-id-1', 'coords': pointRaw},
      });
    });

    test('serializes with null data', () {
      final data = GetLocationResponse(getLocation: null);
      final json = data.toJson();

      expect(json, {'getLocation': null});
    });
  });

  group('GetLocationResponse updateWithJson', () {
    final initial = GetLocationResponse(
      getLocation: GetLocation_getLocation(id: 'initial-id', coords: point),
    );

    test('updates with new data', () {
      final updated = initial.updateWithJson({
        'getLocation': {'id': 'updated-id', 'coords': null},
      });

      expect(updated.getLocation?.id, 'updated-id');
      expect(updated.getLocation?.coords, isNull);
      expect(initial, isNot(updated));
    });

    test('updates with null data', () {
      final updated = initial.updateWithJson({'getLocation': null});

      expect(updated.getLocation, isNull);
      expect(initial, isNot(updated));
    });
  });
}
