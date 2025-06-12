import 'package:shalom_core/shalom_core.dart';

final Map<String, CustomScalarImpl<dynamic>> customScalars = {};

class Point {
  final int x;
  final int y;

  const Point({required this.x, required this.y});

  @override
  String toString() => 'Point(x: $x, y: $y)';
}

class _PointScalarImpl implements CustomScalarImpl<Point> {
  @override
  Point deserialize(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      // Handles object-like: { "x": 12, "y": 34 }
      return Point(x: raw['x'], y: raw['y']);
    }

    if (raw is! String) {
      throw FormatException(
        "Expected String or Map for Point, got ${raw.runtimeType}",
      );
    }

    // Handles string-like: "POINT (12, 34)"
    final regex = RegExp(r'POINT\s*\((\d+),\s*(\d+)\)');
    final match = regex.firstMatch(raw);
    if (match == null) throw FormatException("Invalid POINT format: $raw");

    return Point(x: int.parse(match[1]!), y: int.parse(match[2]!));
  }

  @override
  dynamic serialize(Point value) {
    return "POINT (${value.x}, ${value.y})";
  }
}

// This is referenced in shalom.yml
final pointScalarImpl = _PointScalarImpl();
