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
- Unions/interfaces (also referred as multi-types) selections - are handled as a sealed class, each of the possible concrete types extend this class and have their selections and cache normalization functions. The root sealed class can resolve into each of the implementation based on the `__typename` selection.

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

- For input-related test cases, we are testing
    - optional no default (`Maybe` type, it is useful for graphql patch updates because it is not included in the op vars if is `None`).
    - optional with null default
    - optional with default
    - required 
    - required with default
    - for each case we should test:
        - ==
        - `toJson`
        - cache normilization (meaning that the inputs are CORRECTLY used to deduce the normalized key for the queried fields)

when you are done, make sure all tests pass using `task test` and all lints pass using `task lint` (check Taskfile.yml to see what they do if needed).
We use `fvm exec dart` for Dart commands in this repo, including flutter_rust_bridge codegen.

### Testing Interfaces and Unions

When testing interface and union selections, follow this pattern to ensure that abstract getters work correctly:

#### Interface Testing Pattern

For interfaces, test that common fields can be accessed through the interface type (abstract class) before casting to concrete types:

```dart
test('interface example', () {
  final result = GetAnimalResponse.fromResponse(lionData, variables: variables);
  
  // 1. Access shared fields via the interface reference
  final animal = result.animal;
  expect(animal.id, "lion1");
  expect(animal.legs, 4);
  expect(animal.sound, "Roar");
  
  // 2. Check the concrete type
  expect(result.animal, isA<GetAnimal_animal_Lion>());
  
  // 3. Cast to access type-specific fields
  final animalAsLion = result.animal as GetAnimal_animal_Lion;
  expect(animalAsLion.furColor, "Golden");
  expect(animalAsLion.typename, "Lion");
});
```

**Why this pattern?**
- Tests that abstract getters are properly generated in the interface abstract class
- Verifies type discrimination works correctly
- Ensures both shared and type-specific fields are accessible

#### Union Testing Pattern

For unions, since Dart uses `sealed` classes (not abstract classes with getters), test shared fields after casting:

```dart
test('union example', () {
  final result = GetSearchResultResponse.fromResponse(userData, variables: variables);
  
  // 1. Check the concrete type
  expect(result.search, isA<GetSearchResult_search_User>());
  
  // 2. Cast and access all fields (unions don't have abstract getters)
  final user = result.search as GetSearchResult_search_User;
  expect(user.id, "user1");
  expect(user.name, "John Doe");
  expect(user.email, "john@example.com");
  expect(user.typename, "User");
});
```

**Key Differences:**
- **Interfaces**: Generate abstract class with abstract getters for shared fields
- **Unions**: Generate sealed class without shared field getters (Dart type system limitation)

For lists of interfaces/unions, apply the same pattern to each element in the list.

### Code style
- in Dart we prefer named constructors i.e `Foo({required this.something, this.baz})`
