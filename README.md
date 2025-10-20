# shalom

### (WIP 🚧) GraphQL client for dart and flutter.

### Installation

1. Build the CLI from source:

```bash
cargo install --git https://github.com/nrbnlulu/shalom.git --branch main shalom_dart_codegen
```

2. add flutter deps
```bash
dart pub add shalom_core:'{"git":{"url": "https://github.com/nrbnlulu/shalom.git", "path": "dart/shalom_core"}}'
dart pub add shalom_flutter:'{"git":{"url": "https://github.com/nrbnlulu/shalom.git", "path": "dart/shalom_flutter"}}'
```


### CLI Usage

The `shalom` CLI provides commands to generate Dart code from your GraphQL schema and operations.

#### Commands

**Generate**

Generate Dart code from GraphQL schema and operations:

```bash
shalom generate [OPTIONS]
```

Options:
- `-p, --path <PATH>`: Path to the project directory (defaults to current directory)
- `-s, --strict`: Fail on first error instead of continuing

Example:
```bash
shalom generate --path ./my-project --strict
```

**Watch**

Watch for changes in GraphQL files (`.graphql` and `.gql`) and automatically regenerate code:

```bash
shalom watch [OPTIONS]
```

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


### Roadmap

- [x] builtin scalars
- [x] custom scalars
- [x] enums
- [x] object selection
- [x] nested objects
- [x] union
- [x] interface
- [x] fragments
- [ ] list of
    - [x] scalars
    - [x] custom scalars
    - [x] objects
    - [x] enums
    - [x] unions
    - [x] interface
    - [x] fragments
    - [ ] nested list
- [x] Node interface real time updates.
- [ ] defer / stream
- [ ] input
    - [x] scalar
    - [x] custom scalar
    - [x] object
    - [x] enum
    - [ ] oneOf
    - [ ] list of
        - [x] scalar
        - [x] custom scalar
        - [x] object
        - [x] enum
        - [ ] oneOf

