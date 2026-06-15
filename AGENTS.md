### Preface
This repo contains the code for "Shalom" a graphql client runtime with dart and flutter frontends. 

### Architecture
- /rust/shalom_core - parsing, validating and core graphql types.
- /rust/shalom_runtime - a full fledged graphql client runtime (normalized cache, links, execution, mutation, cache subscriptions etc.)
- /rust/shalom_dart_codegen - a codegen for dart and flutter that uses minijinja templates to generate code
- /dart/shalom - rust bridge (using frb), core helpers, network helpers basically a wrapper level around the rust runtime.
- /dart/shalom_flutter - integration with flutter widgets and state management
- /dart/shalom_annotations - a set of annotations used by the dart codegen for declerative graphql operations on widgets (@Query, @Mutation, @Subscription @Fragment)

### Dart codegen Architecture
- as a rule of thumb variables that you create in templates should have $ symbol in order to differentiate from user-defined symbols (i.e graphql fields).
- Object - generated as a dart class with normalized cache read / write functions + few helpers
- Operation - TBD (dart/flutter)
- Enum - just like a dart enum with a few helpers
- Scalars - there is a base scalars mapping for dart types
- Custom scalars - we support adding custom scalars via a user defined dart glue and some configs in shalom.yml
- Fragments - fragments are basically a dart abstract class that can `implement` each other. When a fragment is used in an operation, it will be extended and all of its selections will be considered as if they were flattened inside the object that used that fragment (or its inner fragments). If a fragment has nested selections (of objects), it will generate their definitions in its own file. 
- when a fragment spreads other fragment within it, it would basically `implement` the parent fragment

- `@observe` - a graphql directive that the codegen (and the runtime) use to mark that an operation / fragment subscribes to normalized cache updates. 
- `@Fragment` Widgets - a widget that uses the `@Fragment` annotations would require a "ref" in order to resolve the fragment data from the cache. the "ref" would get provided by the upper @Query/@Subscription/@Mutation widget that used this fragment all backed up by the codegen.
- Unions/interfaces (also referred as multi-types) selections - are handled as a sealed class, each of the possible concrete types extend this class and have their selections and cache normalization functions. The root sealed class can resolve into each of the implementation based on the `__typename` selection.
#### Input codegen guidlines
- optional no default (`Maybe` type, it is useful for graphql patch updates because it is not included in the op vars if is `None`).
- optional with null default
- optional with default
- required 
- required with default
- for each case we should test:
    - ==
    - `toJson`
    - cache normilization (meaning that the inputs are CORRECTLY used to deduce the normalized key for the queried fields)


### Testing
#### Runtime tests
cache normalization, gc, execution, cache subscription etc.
exist in rust/shalom_runtime we don't test runtime behaviour on complex use cases on the dart side, dart tests are focused on the codegen output and widget integration.

#### Codegen tests (Dart/Flutter)
codegen tests are split into two:
- pure codegen tests - verify that the generated types are correct for variouse usecases (required, optional, ==, to/fromJson, interfaces, unions, enums custom scalars lists, and combinations of these), these tests are pure dart and exist in `rust/shalom_dart_codegen/dart_tests/`
- flutter widget tests - which verify edge cases regarding to the declerative API, these tests are flutter widget tests and exist in `rust/shalom_dart_codegen/flutter_tests/`

- anyways run these tests is via cargo in `rust/shalom_dart_codegen/tests/usecases_test.rs` this would make sure to run the codegen before running the test.

- never run cargo tests without limiting the amount of threads to 2 otherwise the pc will crash.

### Code style
- in Dart we prefer named constructors i.e `Foo({required this.something, this.baz})`
