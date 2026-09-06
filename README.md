# shalom
A GraphQL client runtime for Dart and Flutter.



### Installation

1. Add the code generator to your project:

```bash
dart pub add --dev shalom_dart_codegen
```

The matching native executable is downloaded from GitHub Releases for your
development machine when Dart runs the package build hook.

2. Add the Flutter dependencies:

```bash
dart pub add shalom_flutter shalom_annotations
```


### CLI Usage

The `shalom` CLI provides commands to generate Dart code from your GraphQL schema and operations.

#### Commands

**Generate**

Generate Dart code from GraphQL schema and operations:

```bash
dart run shalom_dart_codegen:shalom generate [OPTIONS]
```

Options:
- `-p, --path <PATH>`: Path to the project directory (defaults to current directory)
- `-s, --strict`: Fail on first error instead of continuing

Example:
```bash
dart run shalom_dart_codegen:shalom generate --path ./my-project --strict
```

**Watch**

Watch for changes in and automatically regenerate code:

```bash
dart run shalom_dart_codegen:shalom watch [OPTIONS]
```
### Examples 
check the gif_search example under `./examples/flutter/gif_search`

### How to: Custom scalars 
1. make sure to add shalom.yml in project root.
its content should look like this
```yml
custom_scalars:
  Point:
    graphql_name: "Point"
    output_type: 
      import_path: "package:dart_tests/point.dart"
      symbol_name: "Point"
      
    impl_symbol:
      import_path: "package:dart_tests/point.dart"
      symbol_name: "pointScalarImpl"
```
and these are the scalar implementation (modify to fit your needs)
```dart
import 'package:shalom_core/shalom_core.dart';

class Point {
  final int x;
  final int y;

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
      // Check if keys exist and are integers before using them.
      if (raw['x'] is! int || raw['y'] is! int) {
        throw FormatException(
          "Point fields 'x' and 'y' must be present and must be integers.",
        );
      }
      return Point(x: raw['x'], y: raw['y']);
    }

    if (raw is! String) {
      throw FormatException(
        "Expected String or Map for Point, got ${raw.runtimeType}",
      );
    }

    // Handles string-like: "POINT (12, 34)"
    final regex = RegExp(r'POINT\s*\((-?\d+),\s*(-?\d+)\)');
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
```
