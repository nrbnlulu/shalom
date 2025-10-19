# shalom

### (WIP 🚧) GraphQL client for dart and flutter.

### Installation

1. Build the CLI from source:

```bash
cargo install --git https://github.com/nrbnlulu/shalom.git --branch main shalom_dart_codegen
```

2. add flutter deps
```bash
dart pub add shalom_core:'{"git":{"url": "https://github.com/nrbnlulu/shalom.git", "path": "dart/shalom_core"}}'
dart pub add shalom_flutter:'{"git":{"url": "https://github.com/nrbnlulu/shalom.git", "path": "dart/shalom_flutter"}}'
```


### CLI Usage

The `shalom` CLI provides commands to generate Dart code from your GraphQL schema and operations.

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
    - [x] interface
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

