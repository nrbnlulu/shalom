# Installation

Shalom ships a Rust-based CLI for code generation and Dart packages for
runtime support. This guide covers the minimal setup for a Flutter app using
Shalom's declarative annotation API.

## Prerequisites

- Rust toolchain (for the CLI)
- Flutter SDK (Shalom's declarative widgets are Flutter-only)

## Install the CLI

```bash
cargo install --git https://github.com/nrbnlulu/shalom.git --branch main shalom_dart_codegen
```

The command installs the `shalom` binary on your PATH.

## Add Dart dependencies

```yaml
dependencies:
  shalom: ^0.1.5
  shalom_flutter: ^0.1.5
  shalom_annotations: ^0.1.5
```

Or add them via the Flutter CLI:

```bash
flutter pub add shalom shalom_flutter shalom_annotations
```

- `package:shalom` exposes `ShalomRuntimeClient`, links (`HttpLink`,
  `WebSocketLink`), response types, and cache helpers.
- `package:shalom_flutter` exposes `ShalomProvider`/`ShalomScope`, generated
  widget base classes, fragment scopes, and the debug panel.
- `package:shalom_annotations` provides `@Query`, `@Mutation`,
  `@Subscription`, and `@Fragment`, which the codegen scans for.

## Project layout

The codegen scans your Dart/Flutter source tree for classes annotated with
`@Query` / `@Mutation` / `@Subscription` / `@Fragment`. You still need a
GraphQL schema file `schema.graphql` for validation and type generation. A common layout is:

```text
my_flutter_app/
├── lib/
│   ├── graphql/
│   │   └── schema.graphql      # GraphQL schema
│   ├── albums_page.dart        # @Query widget
│   ├── album_widget.dart       # @Fragment widget
│   └── __graphql__/            # Generated code (auto-created)
├── shalom.yml                  # Optional config (custom scalars, etc.)
└── pubspec.yaml
```

Generated files are written next to their source files under a `__graphql__`
directory (for example `lib/__graphql__/albums_page.widget.shalom.dart`).
Do not edit files under `__graphql__` directly.

!!! note "optional `shalom.yml`"
    The `shalom.yml` configuration is optional unless you need [custom scalars](custom-scalars.md) mappings or custom output options.

## CLI usage

Generate code once:

```bash
shalom generate --path .
```

Watch for changes and re-generate on save:

```bash
shalom watch --path .
```

Both commands scan `.graphql` schema files and annotated `.dart` files under
the given path (skipping generated `__graphql__` directories).
