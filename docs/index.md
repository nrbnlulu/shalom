# Shalom

Shalom is a GraphQL codegen library for Dart and Flutter. It generates strongly typed
request classes, data models, and cache helpers so you can work with GraphQL results
as Dart objects.

## Highlights

- Generated Dart types for operations, objects, enums, fragments, and unions/interfaces
- Normalized cache with read/write helpers for updates across queries
- Stream-based requests for live updates in your UI
- Custom scalar support via a small Dart glue layer

## Example project

See the Flutter SWAPI example at `examples/flutter/swapi` for a full working app.

## Documentation tooling

This repo uses `uv` for Python environments when working on the docs. Use the
`task docs:serve` Taskfile target to run MkDocs locally.
