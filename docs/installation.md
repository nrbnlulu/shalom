# Installation

Shalom ships a Rust-based CLI for code generation and Dart packages for runtime
support. This guide covers the minimal setup for a Flutter app.

## Prerequisites

- Rust toolchain (for the CLI)
- Dart or Flutter SDK

## Install the CLI

```bash
cargo install --git https://github.com/nrbnlulu/shalom.git --branch main shalom_dart_codegen
```

The command installs the `shalom` binary on your PATH.

## Add Dart dependencies

```bash
dart pub add shalom_core:'{"git":{"url": "https://github.com/nrbnlulu/shalom.git", "path": "dart/shalom_core"}}'
dart pub add shalom_flutter:'{"git":{"url": "https://github.com/nrbnlulu/shalom.git", "path": "dart/shalom_flutter"}}'
```

If you are not using Flutter, you can omit `shalom_flutter`.

## Project layout

Shalom expects your project to include a GraphQL schema and operation files. A common
layout is:

```
./graphql/schema.graphql
./graphql/operations.graphql
./shalom.yml
```

The `shalom.yml` file is optional unless you need custom scalar mappings or want to
change output paths.

## Optional configuration

The AniList example keeps generated files under `lib` with a minimal config:

```yml
schema_output_path: "./lib"
```

Add custom scalars in the same file when needed.

## CLI usage

Generate code once:

```bash
shalom generate --path .
```

Watch for changes and re-generate:

```bash
shalom watch --path .
```
