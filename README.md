# shalom

### (WIP 🚧) GraphQL client for dart and flutter.

### CLI Usage

The `shalom` CLI provides commands to generate Dart code from your GraphQL schema and operations.

#### Installation

Build the CLI from source:

```bash
cd rust/shalom_dart_codegen
cargo build --release
```

The binary will be available at `rust/target/release/shalom`.

#### Commands

**Generate**

Generate Dart code from GraphQL schema and operations:

```bash
shalom generate [OPTIONS]
```

Options:
- `-p, --path <PATH>`: Path to the project directory (defaults to current directory)
- `-s, --strict`: Fail on first error instead of continuing

Example:
```bash
shalom generate --path ./my-project --strict
```

**Watch**

Watch for changes in GraphQL files (`.graphql` and `.gql`) and automatically regenerate code:

```bash
shalom watch [OPTIONS]
```

Options:
- `-p, --path <PATH>`: Path to the project directory (defaults to current directory)
- `-s, --strict`: Fail on first error instead of continuing

Example:
```bash
shalom watch --path ./my-project
```

The watch command will:
1. Run an initial code generation
2. Monitor the specified directory for changes to `.graphql` and `.gql` files
3. Automatically regenerate code when changes are detected
4. Continue watching until you press Ctrl+C

### Roadmap

- [x] builtin scalars
- [x] custom scalars
- [x] enums
- [x] object selection
- [x] nested objects
- [x] union
- [x] interface
- [x] fragments
- [ ] list of
    - [x] scalars
    - [x] custom scalars
    - [x] objects
    - [x] enums
    - [x] unions
    - [ ] interface
    - [x] fragments
    - [ ] nested list
- [x] Node interface real time updates.
- [ ] defer / stream
- [ ] input
    - [x] scalar
    - [x] custom scalar
    - [x] object
    - [x] enum
    - [ ] oneOf
    - [ ] list of
        - [x] scalar
        - [x] custom scalar
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
