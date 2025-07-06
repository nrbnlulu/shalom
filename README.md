# shalom
### (WIP 🚧) GraphQL client for dart and flutter.


### Roadmap
- [x] builtin scalars
- [x] custom scalars
- [x] enums
- [x] object selection
- [x] nested objects
- [ ] unions
- [ ] fragments
- [ ] list of
    - [ ] scalars
    - [ ] custom scalars
    - [ ] objects
    - [ ] enums
    - [ ] unions
    - [ ] fragments
    - [ ] nested list
- [ ] Node interface real time updates.
- [ ] defer / stream
- [ ] input
    - [x] scalar
    - [x] custom scalar
    - [x] object
    - [x] enum
    - [ ] oneOf
    - [ ] list of
        - [x] scalar
        - [x] object
        - [x] enum
        - [ ] oneOf  
 
### Development
Add a test case for your use case under `rust/shalom_dart_codegen/tests/usecases_test.rs` and run this test. After the first run, it will generate a minimal Dart project under `rust/shalom_dart_codegen/dart_tests/`. In `tests.dart`, `operations.graphql`, and `schema.graphql`, you can add tests specific for your use case. To run the test, run the Rust test again (it won't overwrite the Dart project).

Every test case should include the following:

- `xRequired` 
- `xOptional`
where `x` is the kind of use case you are testing, for example `objectRequired`, `objectOptional`, `scalarRequired`, `scalarOptional`, etc.
For each test, you should verify that `fromJson` works, `updateWithJson` works, `toJson` works, and `==` works.

For input-related test cases, you should also add a `Maybe` test. This means that for fields that are optional but **have no default value**, they should be wrapped in a `Maybe` type (`Some` | `None`).

when you are done, make sure all tests pass using `task test` and all lints pass using `task lint`.
