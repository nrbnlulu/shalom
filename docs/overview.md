# Overview

Shalom is a declarative GraphQL client for Dart and Flutter, backed by a Rust
runtime (normalized cache, links, execution, cache subscriptions).

## Paradigm

Shalom is declarative: as a rule of thumb you don't need services or state
management solutions for GraphQL data. You annotate widget classes with
`@Query`, `@Mutation`, `@Subscription`, or `@Fragment`, and the codegen wires
them to a normalized cache that keeps every widget observing it in sync.

- Every widget should request only what it needs.
- Prefer server-side work (sorting, filtering, pagination) over UI-side work,
  since list items are usually fragments and aren't declaratively readable by
  a list builder.
- Reads are declarative (generated widgets/scopes); mutations are imperative
  (generated mutation classes called from event handlers).

## Highlights

- Rust runtime with a normalized cache, so the same entity read by different
  operations stays in sync everywhere it's rendered.
- Annotation-driven codegen: `@Query` / `@Mutation` / `@Subscription` / `@Fragment`
  on plain Dart/Flutter classes, no separate `.graphql` operation files.
- Generated fragment `Ref`/`Scope` types for reactive, entity-scoped widgets.
- Cache-aware mutation helpers: `execute`, `executeWithCacheUpdate`,
  `executeOptimistic`.
- Custom scalar support via a small Dart glue layer.
- A Flutter debug panel for inspecting the live normalized cache.

To get started, check out the [Installation](installation.md) guide and the [Quickstart](quickstart.md) walkthrough. You can also explore [`examples/flutter/gif_search`](https://github.com/nrbnlulu/shalom/tree/main/examples/flutter/gif_search) in the repository for a complete working app.
