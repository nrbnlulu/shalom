import 'package:test/test.dart';
import '__graphql__/GetLocation.shalom.dart';
import 'point.dart';

void main() {
  final point = Point(x: 10, y: 20);
  final pointRaw = "POINT (10, 20)";
  group('GetLocation_getLocation', () {
    group('deserialize', () {
      test('with optional value', () {
        final json = {'id': 'test-id-1', 'coords': pointRaw};
        final result = GetLocation_getLocation.fromJson(json);
        expect(result.id, 'test-id-1');
        expect(result.coords, isA<Point>());
        expect(result.coords?.x, point.x);
      });
      test('with null optional value', () {
        final json = {'id': 'test-id-2', 'coords': null};
        final result = GetLocation_getLocation.fromJson(json);
        expect(result.id, 'test-id-2');
        expect(result.coords, isNull);
      });
    });


    group('serialize', () {
      test('with optional value', () {
        final data = {'id': 'test-id-1', 'coords': pointRaw};
        final initial = GetLocation_getLocation.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
      test('with null optional value', () {
        final data = {'id': 'test-id-2', 'coords': null};
        final initial = GetLocation_getLocation.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });

    group('updateWithJson', () {
      final initial = GetLocation_getLocation(id: 'id-1', coords: point);
      test('optional from some to some', () {
        final updatedPointRaw = "POINT (30,40)";
        final updated = initial.updateWithJson({'coords': updatedPointRaw});
        expect(updated.coords?.x, 30);
        expect(initial, isNot(updated));
      });
      test('optional from some to null', () {
        final updated = initial.updateWithJson({'coords': null});
        expect(updated.coords, isNull);
        expect(initial, isNot(updated));
      });
      test('required field', () {
        final updated = initial.updateWithJson({'id': 'id-2'});
        expect(updated.id, 'id-2');
        expect(updated.coords?.x, point.x);
      });
    });

    test('equality', () {
      final foo = GetLocation_getLocation(id: 'id-1', coords: point);
      final bar = GetLocation_getLocation(id: 'id-1', coords: point);
      expect(foo, bar);
      expect(foo.hashCode, bar.hashCode);

      final baz = GetLocation_getLocation(id: 'id-2', coords: point);
      expect(foo, isNot(baz));
    });
  });

  group('pointScalarImpl.deserialize error handling', () {
    test('throws when "x" key is missing', () {
      final json = {'y': 20};
      // Use a function closure to test that an exception is thrown
      expect(() => pointScalarImpl.deserialize(json), throwsA(isA<Exception>()));
    });

    test('throws when "y" key is missing', () {
      final json = {'x': 10};
      expect(() => pointScalarImpl.deserialize(json), throwsA(isA<Exception>()));
    });

    test('throws when "x" is not numeric in string format', () {
      final json = "POINT (abc, 20)";
      expect(() => pointScalarImpl.deserialize(json), throwsA(isA<Exception>()));
    });

    test('throws when "y" is not numeric in string format', () {
      final json = "POINT (10, xyz)";
      expect(() => pointScalarImpl.deserialize(json), throwsA(isA<Exception>()));
    });
  });
  group('GetLocationResponse', () {
    group('deserialize', () {
      test('with value', () {
        final json = {
          'getLocation': {'id': 'test-id-1', 'coords': pointRaw},
        };
        final result = GetLocationResponse.fromJson(json);
        expect(result.getLocation, isNotNull);
        expect(result.getLocation?.id, 'test-id-1');
      });
      test('null value', () {
        final json = {'getLocation': null};
        final result = GetLocationResponse.fromJson(json);
        expect(result.getLocation, isNull);
      });
    });
    group('serialize', () {
      test('with value', () {
        final data = GetLocationResponse(
          getLocation: GetLocation_getLocation(id: 'test-id-1', coords: point),
        );
        final json = data.toJson();
        expect(json['getLocation'], isNotNull);
      });
      test('null value', () {
        final data = GetLocationResponse(getLocation: null);
        final json = data.toJson();
        expect(json['getLocation'], isNull);
      });
    });
  });
}
