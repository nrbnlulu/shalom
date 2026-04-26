# Shalom Flutter Client – Design Document

## Overview

The Flutter client provides a widget-centric API over the Shalom Rust runtime. Each `@observe`d node in the GraphQL document corresponds to exactly one Flutter widget, aligning the widget rebuild boundary with the runtime's reactivity boundary.

The core ergonomic goal: **the widget class name *is* the GraphQL operation/fragment name.** Users define a widget once and codegen derives the operation name, the request type, the response shape, and the fragment registry entry from it. No repeated names, no separate fragment identifiers.

## Naming convention

The widget's class name is the canonical identifier across the system.

- A widget annotated with `@query` named `UsersWidget` produces a generated operation `query UsersWidget(...) @observe { ... }`.
- A widget annotated with `@fragment` named `BestFriendWidget` produces `fragment BestFriendWidget on BestFriend @observe { ... }`.
- Spreading a fragment in another widget's body is done by the widget's class name: `...BestFriendWidget`.
- The runtime identifies observables by this same name (`observable_id: "UsersWidget"`, `observable_id: "BestFriendWidget"`).

This eliminates the bookkeeping of "what's the operation name vs. what's the widget name vs. what's the fragment name" — there's exactly one name per `@observe`d unit.

## File layout

Generated files live in a `__graphql__` directory **adjacent to the widget that produced them**, not in a centralized location. This keeps generated code colocated with its source, matches the import locality the user already has, and makes it obvious which file owns which generated artifact.

```
lib/
  features/
    users/
      users_widget.dart
      __graphql__/
        users_widget.shalom.dart
    best_friend/
      best_friend_widget.dart
      __graphql__/
        best_friend_widget.shalom.dart
    pet/
      pet_widget.dart
      __graphql__/
        pet_widget.shalom.dart
  __graphql__/
    schema.shalom.dart           # shared enums, input types, scalars
    shalom_init.shalom.dart      # project-wide registry + init()
```

Per-widget rules:

- One user file → one sidecar in a sibling `__graphql__/` directory.
- The sidecar's filename mirrors the source: `users_widget.dart` → `__graphql__/users_widget.shalom.dart`.
- Imports from the user file are always relative: `import './__graphql__/users_widget.shalom.dart';`.

Project-wide files:

- `lib/__graphql__/schema.shalom.dart` holds shared enums, input types, and custom scalar serializers — anything that isn't tied to a single widget.
- `lib/__graphql__/shalom_init.shalom.dart` holds the registration function. It lives at the project root because it imports from every widget's sidecar.

The build tool discovers `@query`/`@fragment` annotations across the project, emits each sidecar next to its source, and rebuilds the two project-wide files when the set of widgets changes.

## Runtime registration

Because operation and fragment SDL is known at codegen time, the Rust runtime never receives raw SDL at request time. The codegen emits a single init function that ships every operation and fragment to Rust once, at app startup. This means:

- Per-request payloads only carry an identifier (the widget name) plus variables.
- The runtime performs no SDL parsing or validation on the hot path.
- Adding new operations/fragments at runtime is supported via the same registration API, but is the exception, not the norm.

The generated init looks like:

```dart
// lib/__graphql__/shalom_init.shalom.dart
import 'package:shalom/shalom.dart';

void registerShalomDefinitions(ShalomClient client) {
  client.registerOperation(
    name: 'UsersWidget',
    document: r'''
      query UsersWidget($input: UsersFilter!) @observe {
        users(filter: $input) {
          name
          age
          bestFriend { ...BestFriendWidget }
        }
      }
    ''',
  );
  client.registerFragment(
    name: 'BestFriendWidget',
    document: r'''
      fragment BestFriendWidget on BestFriend @observe {
        __typename
        ... on User { id name }
        ... on Pet  { ...PetWidget }
      }
    ''',
  );
  // ...one entry per @query / @fragment widget in the project
}
```

The user calls this once at app startup:

```dart
import 'package:flutter/material.dart';
import 'package:shalom/shalom.dart';
import '__graphql__/shalom_init.shalom.dart';

void main() {
  final client = ShalomClient();
  registerShalomDefinitions(client);
  runApp(ShalomProvider(client: client, child: const MyApp()));
}
```

For dynamically loaded modules, the same `registerOperation`/`registerFragment` calls can be made later; the runtime accepts late registrations.

## Authoring a query widget

The user writes only the body of the operation — the `query Name(...) @observe` envelope is synthesized by codegen from the class name.

```dart
// lib/features/users/users_widget.dart
import 'package:flutter/widgets.dart';
import './__graphql__/users_widget.shalom.dart';
import '../best_friend/best_friend_widget.dart';

@query(r'''
  ($input: UsersFilter!) {
    users(filter: $input) {
      name
      age
      bestFriend { ...BestFriendWidget }
    }
  }
''')
class UsersWidget extends $UsersWidget {
  const UsersWidget({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('Error: $error');

  @override
  Widget buildData(BuildContext context, UsersWidgetData data) {
    return ListView.builder(
      itemCount: data.users.length,
      itemBuilder: (ctx, i) {
        final user = data.users[i];
        return Column(children: [
          Text(user.name),
          Text('${user.age}'),
          if (user.bestFriend != null)
            BestFriendWidget(ref: user.bestFriend!),
        ]);
      },
    );
  }
}
```

The codegen wraps the body in `query UsersWidget(...) @observe { ... }` automatically. The variable signature `($input: UsersFilter!)` is the only thing the user needs to write at the top — everything else is derived.

## Authoring a fragment widget

```dart
// lib/features/best_friend/best_friend_widget.dart
import 'package:flutter/widgets.dart';
import './__graphql__/best_friend_widget.shalom.dart';
import '../pet/pet_widget.dart';

@fragment(r'''
  on BestFriend {
    __typename
    ... on User { id name }
    ... on Pet  { ...PetWidget }
  }
''')
class BestFriendWidget extends $BestFriendWidget {
  const BestFriendWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, BestFriendWidgetData data) {
    return switch (data) {
      BestFriendWidgetData$User(:final name) => Text('User: $name'),
      BestFriendWidgetData$Pet(:final pet)   => PetWidget(ref: pet),
      BestFriendWidgetData$Unknown()         => const SizedBox.shrink(),
    };
  }
}
```

The user writes only the type condition and selection set; codegen wraps it as `fragment BestFriendWidget on BestFriend @observe { ... }`.

## Generated types

For each widget, the codegen emits:

### Query widget sidecar

```dart
// lib/features/users/__graphql__/users_widget.shalom.dart
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';
import '../../../__graphql__/schema.shalom.dart';
import '../../best_friend/__graphql__/best_friend_widget.shalom.dart';

// Variables — deep-equality data class
final class UsersWidgetVariables {
  final UsersFilter input;
  const UsersWidgetVariables({required this.input});
  // == / hashCode generated
}

// Response data — fields from @observe'd children are exposed as opaque refs
final class UsersWidgetData {
  final List<UsersWidgetData$user> users;
  const UsersWidgetData({required this.users});
}

final class UsersWidgetData$user {
  final String name;
  final int age;
  final BestFriendWidgetRef? bestFriend; // opaque, not inlined
  const UsersWidgetData$user({...});
}

abstract class $UsersWidget extends StatefulWidget {
  final UsersWidgetVariables variables;
  const $UsersWidget({super.key, required this.variables});

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, UsersWidgetData data);

  @override
  State<$UsersWidget> createState() => _$UsersWidgetState();
}
```

Sidecars import the project-wide `schema.shalom.dart` for shared types and import sibling sidecars for any fragment refs they expose. Cross-feature imports go through `__graphql__/` directories — never through user code — so the generated graph stays self-contained.

### Fragment widget sidecar

```dart
// lib/features/best_friend/__graphql__/best_friend_widget.shalom.dart
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';
import '../../pet/__graphql__/pet_widget.shalom.dart';

// Opaque ref — zero-cost wrapper over ObservedRef
extension type BestFriendWidgetRef._(ObservedRef _inner) {}

// Sealed response for unions/interfaces
sealed class BestFriendWidgetData {
  const BestFriendWidgetData();
}
final class BestFriendWidgetData$User extends BestFriendWidgetData {
  final String id;
  final String name;
  const BestFriendWidgetData$User({required this.id, required this.name});
}
final class BestFriendWidgetData$Pet extends BestFriendWidgetData {
  final PetWidgetRef pet;
  const BestFriendWidgetData$Pet({required this.pet});
}
final class BestFriendWidgetData$Unknown extends BestFriendWidgetData {
  const BestFriendWidgetData$Unknown();
}

abstract class $BestFriendWidget extends StatefulWidget {
  final BestFriendWidgetRef ref;
  const $BestFriendWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, BestFriendWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$BestFriendWidget> createState() => _$BestFriendWidgetState();
}
```

Two things worth highlighting:

**Operation widgets take `variables`; fragment widgets take `ref`.** Different lifecycles, different constructors. An operation widget owns a network request; a fragment widget is purely a cache subscription rooted at the parent's ref anchor.

**Parents cannot read into `@observe`d children.** `bestFriend` is exposed as `BestFriendWidgetRef?`, not as inlined fields. This enforces the runtime's invariant ("root component can't use fields defined within `@observe`d fragments") at compile time. The `extension type` keeps it zero-cost.

## Generated state classes

### Query state

```dart
class _$UsersWidgetState extends State<$UsersWidget> {
  StreamSubscription<UsersWidgetData>? _sub;
  UsersWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $UsersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.variables != oldWidget.variables) _subscribe();
  }

  void _subscribe() {
    final client = ShalomScope.of(context);
    _sub?.cancel(); // old refs enter Rust linger queue
    _sub = client
        .observeOperation<UsersWidgetData>(
          name: 'UsersWidget',
          variables: widget.variables.toJson(),
          decoder: UsersWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() { _data = data; _error = null; }),
          onError: (e) => setState(() { _error = e; }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.buildError(context, _error!);
    if (_data == null)  return widget.buildLoading(context);
    return widget.buildData(context, _data!);
  }
}
```

### Fragment state

```dart
class _$BestFriendWidgetState extends State<$BestFriendWidget> {
  StreamSubscription<BestFriendWidgetData>? _sub;
  BestFriendWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $BestFriendWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    final client = ShalomScope.of(context);
    _sub?.cancel();
    _sub = client
        .observeFragment<BestFriendWidgetData>(
          name: 'BestFriendWidget',
          ref: widget.ref,
          decoder: BestFriendWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() { _data = data; _error = null; }),
          onError: (e) => setState(() { _error = e; }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.buildError(context, _error!);
    if (_data == null)  return widget.buildLoading(context);
    return widget.buildData(context, _data!);
  }
}
```

Equality on `variables` and `ref` is structural, not identity-based, so users passing freshly constructed instances on each rebuild don't trigger spurious resubscribes.

## Imperative API

Not every consumer is a widget. The same client exposes a non-widget surface for use from Bloc, Riverpod, controllers, tests, etc.:

```dart
final client = ShalomScope.of(context);

// Stream — same subscription semantics as the widget
final stream = client.observeOperation<UsersWidgetData>(
  name: 'UsersWidget',
  variables: vars.toJson(),
  decoder: UsersWidgetData.fromCache,
);

// One-shot — no subscription, no cache observation
final once = await client.fetchOperation<UsersWidgetData>(
  name: 'UsersWidget',
  variables: vars.toJson(),
  decoder: UsersWidgetData.fromCache,
);
```

The widget base classes are thin wrappers over these primitives.

## ShalomProvider / ShalomScope

Standard inherited-widget pattern:

```dart
ShalomProvider(
  client: client,
  child: const MaterialApp(...),
);

// inside any widget
final client = ShalomScope.of(context);
```

A `context.shalom` extension is also generated for ergonomics.

## Codegen pipeline

1. Build tool scans the project for `@query` and `@fragment` annotations.
2. For each annotated class, validate the embedded GraphQL against the schema **at build time**, using the widget's class name as the operation/fragment name.
3. Validate fragment spreads — every `...XxxWidget` must resolve to a known `@fragment`-annotated class in the project.
4. Emit a sidecar `*.shalom.dart` next to each user file (in a sibling `__graphql__/` directory).
5. Emit `lib/__graphql__/schema.shalom.dart` with shared types.
6. Emit `lib/__graphql__/shalom_init.shalom.dart` with one `registerOperation`/`registerFragment` call per widget.

Validation errors point at the user's `.dart` file with the offending GraphQL highlighted — never at generated output.

Initial implementation uses `build_runner` + `source_gen`; migration to Dart static macros is a backwards-compatible change since the annotation API doesn't change.

## Open items (TBD)

- **Mutations.** Not covered here. Likely shape: `client.mutate(name: 'CreateUser', variables: ..., optimisticResponse: ...)`, with an `@mutation` widget annotation for components that own a mutation.
- **Subscriptions (GraphQL `subscription` op type).** Same widget pattern as queries, but the underlying transport is long-lived.
- **Pagination / `@connection`.** Belongs in a follow-up; the ref + observable model already supports it but the ergonomics need their own pass.
- **Anchor-vs-ref subscription swaps.** When a fragment widget's `ref` changes but its anchor is a reuse (same `User:1`), the runtime can swap the subscription cheaply rather than tearing down. Worth specifying once the Rust side is firmer.
## Anchor-vs-ref subscription swaps — what's actually going on

Recall the structure of an `ObservedRef` from the runtime spec:

```rust
struct ObservedRef {
    observable_id: Ustr,   // e.g. "BestFriendWidget"
    anchor: RefAnchor,     // e.g. "User:1" or "QUERY.users(...)$2"
}
```

A fragment widget like `BestFriendWidget` is parameterized by an `ObservedRef`. On the Dart side, that's the `ref` it receives from its parent. Two `ObservedRef`s can differ in three meaningfully different ways, and the optimal Rust-side response is different for each.

### Case 1: identical ref

`oldWidget.ref == widget.ref` — same `observable_id`, same `anchor`. The widget rebuilt because its parent rebuilt, but the data it's looking at didn't move. **Do nothing.** Keep the existing subscription. This is the common case during normal reactive updates, and the `==` check in `didUpdateWidget` already handles it.

### Case 2: different anchor, same observable_id

The parent re-rendered and now points the child at a *different* cache entity, but it's still the same fragment widget type:

```
old: { observable_id: "BestFriendWidget", anchor: "User:1" }
new: { observable_id: "BestFriendWidget", anchor: "User:7" }
```

This happens constantly in lists — a `ListView.builder` recycles a slot, and what was rendering `User:1` is now rendering `User:7` in the same widget element. Or a detail screen swaps which user it's showing without unmounting the fragment widget.

This is the case worth optimizing. The naive implementation does:

1. Cancel old subscription.
2. Rust drops refcount on every used ref under `User:1` (`User:1.id`, `User:1.name`, `User:1.icon`, ...).
3. Each hits zero, gets pushed into the linger queue with a timestamp.
4. New subscription registers, Rust re-walks the fragment selection set, allocates a new used-refs vector, increments refcount on every ref under `User:7`.
5. 2 seconds later the GC sweep fires and probably finds those `User:1` refs are still at zero, evicts them — assuming nothing else picked them up in the meantime.

The optimized version recognizes that `observable_id` is the same, so the **shape of the used-refs set is identical** — only the anchor prefix changed. Conceptually:

```
old used refs:        new used refs:
  User:1.id             User:7.id
  User:1.name     →     User:7.name
  User:1.icon           User:7.icon
```

The Rust runtime can do a single atomic operation: "rebind subscription S from anchor `User:1` to anchor `User:7`." Internally this means decrementing the old ref set and incrementing the new one in one pass, but critically it can skip:

- Re-parsing/re-walking the fragment definition (already cached against `observable_id`).
- Allocating a fresh used-refs vector (reuse the existing one, just rewrite the anchor portion of each entry).
- Tearing down and re-creating the subscription handle on the Dart side (the stream stays alive; only its underlying anchor changes).

The widget-side benefit is that the Dart `StreamSubscription` doesn't need to be cancelled and recreated either. We emit a "swap" message over the bridge, the Rust side flips the anchor, and the next normalized read happens against `User:7`. No linger-queue churn, no GC pressure, no transient "subscription absent" window.

### Case 3: different observable_id

```
old: { observable_id: "BestFriendWidget", anchor: ... }
new: { observable_id: "PetWidget",        anchor: ... }
```

Different fragment, different selection set, different used-refs shape. **Full teardown and rebuild.** No optimization available — this is genuinely a different subscription. In practice this is rare for a single widget instance because the widget's static type usually determines `observable_id`, but it can happen if the parent passes a ref synthesized through some union path.

## How this surfaces in the API

The Dart-side state class doesn't need to expose any of this — it just needs to call the right runtime entry point. The generated state class becomes:

```dart
void _onRefChanged(BestFriendWidgetRef oldRef, BestFriendWidgetRef newRef) {
  final client = ShalomScope.of(context);
  // Single call — runtime decides between swap and rebuild
  _sub = client.rebindFragmentSubscription(
    subscription: _sub!,
    newRef: newRef,
  ).listen(...);
}
```

The `rebindFragmentSubscription` call is a single FFI hop. On the Rust side it inspects the old vs. new `ObservedRef` and picks the right strategy — fast swap when `observable_id` matches, full teardown when it doesn't. The Dart caller doesn't need to know which path was taken.

A reasonable alternative API surface, if we'd rather keep the runtime entry points dumber:

```dart
if (oldRef.observableId == newRef.observableId) {
  client.swapAnchor(_subId, newRef.anchor);
} else {
  _sub?.cancel();
  _sub = client.observeFragment(...).listen(...);
}
```

I'd lean toward the first form (smart `rebind`) because it keeps the Dart codegen simpler and lets the Rust side evolve its strategy without API churn.

## What the Rust side needs to support this

The runtime spec already has most of the machinery. The additions needed:

1. **A subscription is keyed by something stable across anchor swaps.** Today an `ObservedRef` is the natural identity, but for swap-friendliness the *subscription handle* (e.g. a `SubscriptionId` integer) needs to be the identity, with `(observable_id, anchor)` as mutable contents.

2. **A "used refs template" cached per `observable_id`.** When a fragment is registered via `registerFragment` at startup, the runtime can pre-compute the *shape* of the used-refs set as a list of relative paths off the anchor (e.g. `[".id", ".name", ".icon"]`). Swap then becomes "for each path in template: decrement `<old_anchor><path>`, increment `<new_anchor><path>`."

3. **A swap primitive that does the decrement-then-increment in one critical section.** Important so that an intermediate state where both old and new are at zero doesn't trigger the GC linger queue prematurely. The natural implementation is: increment all new refs first, then decrement all old refs. Zero refs from the old anchor still flow into the linger queue normally — they just don't get a head start.

4. **Re-emission of the current value after swap.** The stream consumer needs to receive the data for the new anchor without having to re-subscribe. This is just "read the cache at the new anchor through the fragment template, push the result onto the existing channel."

## Why this matters in practice

Without the optimization, every list scroll, detail pivot, or selection change in a list of fragment-rendered items causes a flurry of:

- Refcount hits zero → linger queue insert
- 2s later → GC sweep evaluates → likely no-op because something re-grabbed it
- Meanwhile new subscription allocates fresh ref vectors
- Cache entries for `User:1` may briefly drop to zero observers while `User:7` ramps up

It works, but it's wasteful, and the linger window means cache eviction lags behind actual usage. With the swap optimization, scrolling a list of `BestFriendWidget`s through 1000 different anchors is O(refs-per-fragment) work per scroll position rather than O(refs-per-fragment × 2 + GC pressure).

This is mostly a Rust-side concern; the Dart codegen just needs to call a single `rebind` entry point and the rest follows. Worth keeping the bridge protocol open to it from the start so we don't have to renegotiate later.
