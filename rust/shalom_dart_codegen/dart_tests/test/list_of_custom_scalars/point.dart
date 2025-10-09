import 'package:shalom_core/shalom_core.dart';

class Point {
  final double x;
  final double y;

  const Point({required this.x, required this.y});

  @override
  String toString() => 'Point(x: $x, y: $y)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Point && other.x == x && other.y == y);
  }

  @override
  int get hashCode => Object.hash(x, y);
}

class _PointScalarImpl implements CustomScalarImpl<Point> {
  @override
  Point deserialize(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final x = raw['x'];
      final y = raw['y'];

      if (x == null || y == null) {
        throw FormatException(
          "Point fields 'x' and 'y' must be present.",
        );
      }

      return Point(
        x: (x as num).toDouble(),
        y: (y as num).toDouble(),
      );
    }

    throw FormatException(
      "Expected Map for Point, got ${raw.runtimeType}",
    );
  }

  @override
  dynamic serialize(Point value) {
    return {
      'x': value.x,
      'y': value.y,
    };
  }
}

// This is referenced in shalom.yml
final pointScalarImpl = _PointScalarImpl();
