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
  shalom:
    git:
      url: https://github.com/nrbnlulu/shalom.git
      path: dart/shalom
  shalom_flutter:
    git:
      url: https://github.com/nrbnlulu/shalom.git
      path: dart/shalom_flutter
  shalom_annotations:
    git:
      url: https://github.com/nrbnlulu/shalom.git
      path: dart/shalom_annotations
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
GraphQL schema file for validation and type generation. A common layout is:

```
./lib/graphql/schema.graphql
./lib/**/*.dart          # annotated widget/mutation/fragment classes
./shalom.yml             # optional
```

Generated files are written next to their source file under a `__graphql__`
subdirectory (for example `lib/album_widget/__graphql__/AlbumWidget.shalom.dart`).
Do not edit files under `__graphql__` directly.

The `shalom.yml` file is optional unless you need custom scalar mappings or
want to change output paths.

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
