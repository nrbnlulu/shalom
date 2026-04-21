# Shalom Rust Runtime v2 Architecture

the rust runtime entitled

- normalize data in the cache
- track cache changes and update those who subscribe to these refs
- gc whats not subscribed anymore

### how it works

- runtime initializes with available fragments SDL + schema SDL.
- the target client (in this case Dart) subscribes to rust link requests (network calls)
  these requests are handled via protocol specific sans/io implementations in rust the the client language can use.
- in order to execute operations and listen to normalized cache changes you need to have an operation like so:

```gql
query MyOperation($input: UserFilter!) @subscribeable {
    users(filter: $input) {
        ...UserFrag
    }
}

fragment UserFrag on User @subscribeable {
    id
    name
    icon
    pet {
        ...PetFragment
    }
}

fragment PetFrag on Pet @subscribeable {
    id
    name
    ownerName
    color
}
```

the subscribeable annotation means that the runtime would inject a `__used_refs` on each entry of that fragment. these used refs are corrolated to the amount of `@subscriabeable` refs used.
so in the example above the result from the runtime might look as follows (this can be a rust struct of used_refs + data)

```json
{
    "users": [
        {
            "name": "yossi",
            "icon": "fake url",
            "__used_refs": [
                "<cache_repr_of_the_entity>",
                "<cache_repr_of_the_entity>.name",
                "<cache_repr_of_the_entity>.icon"
                // here we don't have pet refs since the fragment of pet is the owner of these refs.
            ]
        }
    ],
    "__used_refs": ["users(filters: {\"first\": 5})"]
}
```

- `cache_repr_of_the_entity` would be the id or \_id of `user` with the typename like so `User:1`
- types that dont have a required `id` or `_id` field of type String! of Int! are not allowed to use the `@subscribeable` directive thus if i.e `Pet` had no id so user used refs would have included the refs of post fragment like so

```json
"<cache_repr_of_the_entity>.pet.name",
```

etc..

- now how the cache would look is like so

```json
{
    "users(filters: {\"first\": 5})": [
        "<id of user 1>"
        "<id of user 2>"
        "<id of user 3>"
        "<id of user 4>"
        "<id of user 5>"
    ],
    "User:143": {
        "name": "yossi",
        "age": 12,
        "pet": "Pet:14324"
    },
    // etc more users
    "Pet:14324": {
        "name": "dodi",
        "color": "green",
        "ownerName": "yossi",
    }
}
```

version where pet has no id

```json
{
    "User:143": {
        "name": "yossi",
        "age": 12,
        "pet": {
            "name": "dodi",
            "color": "green",
            "ownerName": "yossi"
        }
    }
}
```

now if `"users(filters: {\"first\": 5})"` key in cache got changed meaning that the order changed or resized, anyone who subscribed to this ref (would usually just be the root operation component) would get an update an rerender itself, which will re-read itself from the cache
and will drop the refcount for all the previouse refs that are not currently in the cache subscription if refcount reached to 0 we can evict this ref from the cache.

when a fragment is on a union type i.e

```gql
union BestFriendUnion = Pet | User
```

and our query is like so

```gql
query MyOperation($input: UserFilter!) @subscribeable {
    users(filter: $input) {
        ...UserFrag
    }
}

fragment UserFrag on User @subscribeable {
    id
    name
    icon
    bestFriend {
        ...BestFriendFrag
    }
}

# all types must have id (normalizeable)
fragment BestFriendFrag on BestFriendUnion @subscribeable {
    __typename
    ... on User {
        id
        name
    }

    ... on Pet {
        PetFrag
    }
}
```

if typename has changed then the whole subscribeable is invalid thus we delegate
the cache update to the upper subscribeble if present.

```json
{
    "users": [
        {
            "id": 123,
            "name": "yossi",
            "bestFriend": {...}
            "__used_refs": [
                "User:123.bestFriend"
            ]
        }
    ],
    "__used_refs": [
        "Query.users(first:5)"
    ]

}
```

cache might look like

```json
{
    "QUERY": {
        "users(first:5)": ["User:123", "User:23"]
    },
    "User:123": {
        "bestFriend": "Pet:13"
    }
}
```

and if `User:123.bestFriend` changed to i.e `User:12` or another pet, we will rerender this subscription.

---

### Known Considerations

#### Field Arguments in Cache Keys

GraphQL fields can have arguments (e.g., `avatar(size: SMALL)`). Cache refs for fields with arguments must include a stable, hashed representation of those arguments to avoid key collisions.

Without this, `User:1.avatar(size:SMALL)` and `User:1.avatar(size:LARGE)` would map to the same cache key and overwrite each other.

The cache ref format for fields with arguments should be:

```
User:1.avatar({"size":"SMALL"})
```

Arguments should be serialized in a deterministic (key-sorted) JSON form so that `{size: SMALL, format: PNG}` and `{format: PNG, size: SMALL}` produce the same key.

#### Double-Dispose Race Condition

In Flutter/Dart, during navigation transitions a widget may be disposed and a new one immediately built for the same data. This can cause the refcount for a cache entry to briefly hit zero and trigger eviction — right before the new widget increments the refcount again.

Fix: implement a short **linger timer** (1–5 seconds) after a refcount reaches zero before actually purging the entry from the cache. If the refcount is incremented again within the linger window, cancel the eviction. This makes GC eventually-consistent rather than immediate.

---

### Flutter client addoption

flutter client would have its own abstractions in order to use shalom runtime with ease.
like so:

./**graphql**/users_widget.dart

```dart
// ignore_for_file: camel_case_types
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom;
import './__generated__/users.shalom.dart'; // Contains RequestMyOperation

abstract class $UsersWidget extends StatefulWidget {
  // Developer provides variables, base class handles the Requestable
  final MyOperationVariables variables;

  const $UsersWidget({
    super.key,
    required this.variables,
  });

  // Contract for the developer/mixin
  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget build(BuildContext context, MyOperationResponse data);

  @override
  State<$UsersWidget> createState() => _$UsersWidgetState();
}

class _$UsersWidgetState extends State<$UsersWidget> {
  StreamSubscription<MyOperationResponse>? _subscription;
  MyOperationResponse? _data;
  Object? _error;
  bool _isLoading = true;

  @override
  void didUpdateWidget($UsersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If variables change, we need a fresh subscription
    if (widget.variables != oldWidget.variables) {
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  void _subscribe() {
    final client = context.shalomClient;

    // Create the Requestable internally using generated code
    final requestable = RequestMyOperation(variables: widget.variables);

    // Cancel old sub to trigger the "linger timer" for old refs in Rust
    _subscription?.cancel();

    _subscription = client
        .request<MyOperationResponse>(requestable: requestable)
        .listen(
      (data) {
        setState(() {
          _data = data;
          _isLoading = false;
          _error = null;
        });
      },
      onError: (error) {
        setState(() {
          _error = error;
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _data == null) return widget.buildLoading(context);
    if (_error != null) return widget.buildError(context, _error!);

    // We have data, either from initial network fetch or cache update
    return widget.build(context, _data!);
  }
}

```

./widgets.dart

```dart
// injected using the codegen
import './__graphql__/users_widget.g.dart'


@query(
    '''
    ($input: UsersFilter!) {
        name
        age
    }
    '''
)
class UsersWidget extends $UsersWidget {

    @override
    build(BuildContext context, AsyncValue<GraphQLResult<UsersResponse>> response) {
        // ...
    }

}
```

#### usage with fragments

```dart
@query(
    '''
    ($input: UsersFilter!) {
        name
        age
        bestFriend {
            ...BestFriendWidget
        }
    }
    '''
)
class UsersWidget extends $UsersWidget {

    @override
    build(BuildContext context, AsyncValue<GraphQLResult<UsersResponse>> response) {
        // ...
    }

}
```

```dart
@fragment(
"""
on BestFriend {
    __typename
    ... on User {
        id
        name
    }
    
    ... on Pet {
        PetFrag
    }
}
""")
class BestFriendWidget extends $BestFriend {

}

```
