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
        - [ ] scalar
        - [ ] object
        - [ ] enum
        - [ ] oneOf  
 
### Development
add a testcase for your usecase under `rust/shalom_dart_codegen/tests/usecases/` and run this test, after the first run it will generate a minimal dart project under `rust/shalom_dart_codegen/dart_tests/` there in `tests.dart` \ `operations.graphql` and `schema.graphql` you add tests specific for your usecase. to run the test run the rust test again (it won't overwrite the dart project).

every testcase should include the following:

- `xRequired` 
- `xOptional`
where `x` is the kind of usecase you are testing, for example `objectRequired`, `objectOptional`, `scalarRequired`, `scalarOptional`, etc.
on each test you should test that `fromJson` works, `updateWithJson` works, `toJson` works, and `==` works.

for input related testcases you should also add a `Maybe` test which means
that for fields that are optional but **has no default value** they should be wrapped in a `Maybe`
type (Some | None).

when you done make sure all test pass using `task test` and also make sure all lints pass using `task lint`.

