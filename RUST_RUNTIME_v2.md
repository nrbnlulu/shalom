# Shalom Rust Runtime v2 Architecture

the rust runtime entitled

- normalize data in the cache
- track cache changes and update those who subscribe to these refs
- gc whats not observed anymore

### how it works

- runtime initializes with available fragments SDL + schema SDL.
- the target client (in this case Dart) subscribes to rust link requests (network calls)
  these requests are handled via protocol specific sans/io implementations in rust the the client language can use.
- in order to execute operations and listen to normalized cache changes you need to have an operation like so:

```gql
query MyOperation($input: UserFilter!) @observe {
    users(filter: $input) {
        email
        ...UserFrag
    }
}

fragment UserFrag on User @observe {
    id
    name
    icon
    pet {
        ...PetFragment
    }
}

fragment PetFrag on Pet @observe {
    id
    name
    ownerName
    color
}
```

the `observe` annotation means that the runtime would wrap data in a `ObservedValue` which will allow to listen to runtime changes.
so every component must define exactly the fields that it needs to use.
meaning that root component can't use fields that defined within fragments that are annotated with `@observe`

```rs

type FragmentName = Ustr;
// used in order to be able to fetch the data of this ref directly from the normalized cache.
// can look like this `QUERY.user(name: "yossi")`
// if belongs to a fragment, this might look like so
// `QUERY.user(name: "yossi").bestFriend(first: 2)$1` note that
// you'd need to know where the operation variables was used and inject the actual value on fields where needed.
// alternatively if `type BestFriend` had an id field we can just use its id like so `User:13` or `Pet:2` because it is normalized on the cache and we can directly fetch it without traversing the cache tree.
type RefAnchor = String;

struct ObservedRef{
    // fragment or opeartion name (must be unique)
    observeable_id: Ustr,
    anchor: RefAnchor
}

enum GqlCacheExecutionValue{
    Int(i64),
    String(String),
    ID(String),
    Float(f64),
    Boolean(bool),
    SubSubscription((FragmentName, RefAnchor))
    List(Vec<GqlCacheExecutionValue>)
    Object(UstrMap<Box<GqlCacheExecutionValue>>)
}
```

then when passed to the client language it will be serialized as json

```json
{
    "users": [
        {
            "email": "yossi",
            "$UserFrag": {
                "observeable_id": "UserFrag",
                "anchor": "User:23"
            }
        }
    ],
}
```

### Used Refs

every `@observe`d component would own a bunch of used refs that will be used by the normalization engine to push updates to that observeable
these refs live in rust only, no reason for them to go outside rust.

they might look like so (based on the above query):

```
[
    "QUERY.users(filters: {\"first\": 5})",
    "User:1.email",
    "User:2.email",
    "User:4.email",
    "User:3.email",
]
```
possible things that can cause an update to this observable
- `QUERY.users(filters: {\"first\": 5})` was added / removed / rearanged.
- any of the users email was changed (even tho we could have passed it to the fragment, we for some reason needed available in the root operation so we would also get updates for it)

Note that we don't have refs of `UserFrag` since this fragment is `@observe` thus these refs are delegated to that fragment.
the refs of `UserFrag` might look like

```
[
   "User:1.email",
   "User:1.id",
   "User:1.icon",
]
```

### Union / interfaces catch

the catch here is that since `PetFrag` is also `@observe` we actually would need to update it if the typename of this field changes. 
but since the ref of then can be either `Pet:1` or `User:1` we also need to listen to changes for `<anchor>.__typeName` which the cache 
anchor can be `User:1.pets(first: 2)$1`

### Note on id / _id fields
if a field has an id field we implicitly query this field even if the uesr's query didn't included it, since it provides much better performance / cache updates.

### List - how to know if it got rearanged
in order to check if a list entity was rearanged we have 2 strategies

1. typename:id comparison
2. for types that has no id, we traverse the db normalized result until we find a missmatch (if we find it) and if found we can return early and determaine that this field of type list needs an update (for who ever subscribes it)

### Garbadge collection
Sweep Epoch strategy:

When a refcount hits zero, push its RefAnchor into a "pending eviction" queue with a timestamp.

Run a single background interval (e.g., every 2 seconds) that drains the queue.

If the item's refcount is still zero and the time elapsed is greater than your linger window, evict it.

### how the cache would look is like so

```json
{
   "QUERY": {
       "users(filters: {\"first\": 5})": [
            "<id of user 1>"
            "<id of user 2>"
            "<id of user 3>"
            "<id of user 4>"
            "<id of user 5>"
        ]
   },
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

now if `"users(filters: {\"first\": 5})"` key in cache got changed meaning that the order changed or resized, anyone who observed to this ref (would usually just be the root operation component) would get an update an rerender itself, which will re-read itself from the cache
and will drop the refcount for all the previouse refs that are not currently in the cache subscription if refcount reached to 0 we can evict this ref from the cache.

### Known Considerations

#### Field Arguments in Cache Keys

GraphQL fields can have arguments (e.g., `avatar(size: SMALL)`). Cache refs for fields with arguments must include a stable, hashed representation of those arguments to avoid key collisions.

Without this, `User:1.avatar(size:SMALL)` and `User:1.avatar(size:LARGE)` would map to the same cache key and overwrite each other.

The cache ref format for fields with arguments should be:

```
User:1.avatar({"size":"SMALL"})
```

Arguments should be serialized in a deterministic (key-sorted) JSON form so that `{size: SMALL, format: PNG}` and `{format: PNG, size: SMALL}` produce the same key.


