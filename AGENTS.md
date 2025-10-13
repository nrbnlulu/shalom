### Preface
This repo contains the code for "Shalom" a graphql codegen library for dart and flutter.

### Architecture
graphql parsing and codegen are implemented in rust under
- /rust/shalom_core - for core graphql document parsing
- /rust/shalom_dart_codegen - a codegen for dart and flutter that uses minijinja templates to generate code 
- as a rule of thumb variables that you create in templates should have $ symbol in order to differentiate from user-defined symbols (i.e graphql fields).
- /dart/shalom_core - core types and logic that needed for dart (dart only)
- /dart/shalom_flutter - integration with flutter widgets and state management

### Dart codegen Architecture
- Object - generated as a dart class with normalized cache read / write functions + few helpers
- Operation - generated as a `<op_name>Request` dart class which has either data or errors and can be used as a Request object in order to actually fetch the operation from a graphql server
- Enum - just like a dart enum with a few helpers
- Scalars - there is a base scalars mapping for dart types
- Custom scalars - we support adding custom scalars via a user defined dart glue and some configs in shalom.yml
- Fragments - fragments are basically a dart abstract class that can `implement` each other. When a fragment is used in an operation, it will be extended and all of its selections will be considered as if they were flattened inside the object that used that fragment (or its inner fragments). If a fragment has nested selections (of objects), it will generate their definitions in its own file and operations will need to use these definitions when reading/writing from cache.
- Unions/interfaces (also referred as multi-types) - are handled as a sealed class, each of the possible types extend this class and have their selections and cache normalization functions. The root sealed class can resolve into each of the implementation based on the `__typename` selection if the multitype does not select all of its possible members, a fallback type will also be generated and will be used when the typename we receive from server doesn't have a corresponding implementation.

### Development
Add a test case for your use case under `rust/shalom_dart_codegen/tests/usecases_test.rs` and run this test. After the first run, it will generate a minimal Dart project under `rust/shalom_dart_codegen/dart_tests/`. In `tests.dart`, `operations.graphql`, and `schema.graphql`, you can add tests specific for your use case. To run the test, run the Rust test again (it won't overwrite the Dart project).

Every test case should include the following:

- `xRequired`
- `xOptional`
- 'xCacheNormalization' - ensures that the certain use case is working with the data normalizer, meaning that if the same node is fetched twice it would get updated in the cache.
- `equals(==)`
` `toJson`
where `x` is the kind of use case you are testing, for example `objectRequired`, `objectOptional`, `scalarRequired`, `scalarOptional`, etc.
 for a reference of a complete testcase see `rust/shalom_dart_codegen/dart_tests/test/object_selection/test.dart`

- For input-related test cases, you should also add a `Maybe` test. This means that for fields that are optional but **have no default value**, they should be wrapped in a `Maybe` type (`Some` | `None`).

when you are done, make sure all tests pass using `task test` and all lints pass using `task lint` (check Taskfile.yml to see what they do if needed).

### Code style
- in Dart we prefer named constructors i.e `Foo({required this.something, this.baz})`
