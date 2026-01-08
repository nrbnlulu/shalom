# Custom Scalars

Shalom lets you map GraphQL custom scalars to Dart types with a small config file
and a `CustomScalarImpl` implementation. The generated code will use your Dart type
for fields and call the serializer/deserializer automatically.

## 1. Define a Dart type and scalar implementation

```dart
import 'package:shalom_core/shalom_core.dart';

class Point {
  final int x;
  final int y;

  const Point({required this.x, required this.y});

  @override
  String toString() => 'Point(x: $x, y: $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Point && other.x == x && other.y == y);

  @override
  int get hashCode => Object.hash(x, y);
}

class _PointScalarImpl implements CustomScalarImpl<Point> {
  @override
  Point deserialize(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      if (!raw.containsKey('x')) {
        throw FormatException("Point expects field 'x' but it was missing.");
      }
      if (!raw.containsKey('y')) {
        throw FormatException("Point expects field 'y' but it was missing.");
      }
      if (raw['x'] is! int || raw['y'] is! int) {
        throw FormatException("Point expects integer fields 'x' and 'y'.");
      }
      return Point(x: raw['x'], y: raw['y']);
    }

    if (raw is! String) {
      throw FormatException("Expected String or Map for Point, got ${raw.runtimeType}.");
    }

    final regex = RegExp(r'POINT\s*\((-?\d+),\s*(-?\d+)\)');
    final match = regex.firstMatch(raw);
    if (match == null) throw FormatException("Invalid POINT format: $raw");

    return Point(x: int.parse(match[1]!), y: int.parse(match[2]!));
  }

  @override
  dynamic serialize(Point value) => "POINT (${value.x}, ${value.y})";
}

final pointScalarImpl = _PointScalarImpl();
```

## 2. Register the scalar in `shalom.yml`

Create a `shalom.yml` in your project root:

```yml
custom_scalars:
  Point:
    graphql_name: "Point"
    output_type:
      import_path: "package:my_app/point.dart"
      symbol_name: "Point"
    impl_symbol:
      import_path: "package:my_app/point.dart"
      symbol_name: "pointScalarImpl"
```

Field types will be generated as `Point`, and requests will use
`pointScalarImpl` for serialization and deserialization.

## 3. Use the scalar in your schema

```graphql
scalar Point

type Location {
  id: ID!
  coordinates: Point!
}
```

Run `shalom generate --path .` again to update your Dart types.
