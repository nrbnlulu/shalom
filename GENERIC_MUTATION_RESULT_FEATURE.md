# Generic Mutation Result Feature

## Overview

The Generic Mutation Result feature enables Shalom to generate a single `MutationResult<TData, TError>` class for GraphQL types that follow the common pattern of having `data` and `error` fields. This eliminates code duplication and provides a standardized way to handle mutation results across your application.

## Status

✅ **Phase 1 Complete** - Core infrastructure implemented and tested
- Schema directive parsing
- Generic class generation
- Type system integration
- Comprehensive test coverage

🚧 **Phase 2 In Progress** - Full operation integration (coming soon)
- Template modifications to use generic type in operations
- Type parameter resolution for data and error fields

## Configuration

Add to your `shalom.yml`:

```yaml
custom_scalars:

enable_generic_results: true
```

## Schema Setup

### 1. Define the Directive

Add this to your GraphQL schema:

```graphql
directive @genericResult(
  dataField: String!
  errorField: String!
  errorFragment: String!
) on OBJECT
```

### 2. Define Error Interface and Types

```graphql
interface ErrorInterface {
  message: String!
}

type UnauthorizedError implements ErrorInterface {
  message: String!
  code: String!
}

type ValidationError implements ErrorInterface {
  message: String!
  field: String!
}
```

### 3. Mark Result Types with the Directive

```graphql
type UpdateUserMutationResult @genericResult(
  dataField: "data"
  errorField: "error"
  errorFragment: "GlobalErrorFrag"
) {
  data: User
  error: ErrorInterface
}

type Mutation {
  updateUser(id: ID!, name: String!): UpdateUserMutationResult!
}
```

## Operations

### Create Error Fragment

Define the fragment referenced in the directive:

```graphql
fragment GlobalErrorFrag on ErrorInterface {
  message
  ... on UnauthorizedError {
    code
  }
  ... on ValidationError {
    field
  }
}
```

### Write Your Mutation

```graphql
mutation UpdateUser($id: ID!, $name: String!) {
  updateUser(id: $id, name: $name) {
    data {
      id
      name
      email
    }
    error {
      ...GlobalErrorFrag
    }
  }
}
```

## Generated Code

### MutationResult Class

Shalom generates a generic class in your schema file:

```dart
class MutationResult<TData, TError> {
  final TData? data;
  final TError? error;

  const MutationResult({
    this.data,
    this.error,
  });

  /// Returns true if the result has data and no error
  bool get isSuccess => data != null && error == null;

  /// Returns true if the result has an error
  bool get hasError => error != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MutationResult<TData, TError> &&
        other.data == data &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(data, error);

  @override
  String toString() => 'MutationResult(data: $data, error: $error)';
}
```

### Current Behavior (Phase 1)

Currently, operations still generate individual classes:

```dart
class UpdateUser_updateUser {
  final UpdateUser_updateUser_data? data;
  final UpdateUser_updateUser_error? error;
  
  // ... methods for cache normalization, serialization, etc.
}
```

### Future Behavior (Phase 2)

In the next phase, operations will use the generic type directly:

```dart
class UpdateUserResponse {
  final MutationResult<UpdateUser_updateUser_data?, GlobalErrorFrag?> updateUser;
}
```

## Usage Examples

### Basic Success Case

```dart
final variables = UpdateUserVariables(id: '1', name: 'John Doe');
final response = await client.mutate(
  UpdateUserRequest(variables: variables),
);

if (response.updateUser.data != null) {
  final user = response.updateUser.data!;
  print('User updated: ${user.name}');
}
```

### Error Handling

```dart
final response = await client.mutate(
  UpdateUserRequest(variables: variables),
);

if (response.updateUser.error != null) {
  final error = response.updateUser.error!;
  
  // Access common error fields through the interface
  print('Error: ${error.message}');
  
  // Handle specific error types
  if (error is UpdateUser_updateUser_error__UnauthorizedError) {
    print('Authorization failed: ${error.code}');
  } else if (error is UpdateUser_updateUser_error__ValidationError) {
    print('Validation failed on field: ${error.field}');
  }
}
```

### Using Helper Methods (Future)

Once Phase 2 is complete:

```dart
final result = response.updateUser;

if (result.isSuccess) {
  print('Success! ${result.data!.name}');
} else if (result.hasError) {
  handleError(result.error!);
}
```

## Testing

The feature includes comprehensive tests covering:

- Generic class instantiation and type safety
- Helper methods (`isSuccess`, `hasError`)
- Equality and hashing
- Success responses with data
- Error responses (UnauthorizedError, ValidationError)
- Mixed data and error cases
- Fragment implementation
- Serialization

Run the tests:

```bash
cd rust/shalom_dart_codegen
cargo test test_generic_mutation_result_dart
```

## Architecture

### Components Modified

**Core (`rust/shalom_core/`)**
- `src/shalom_config.rs` - Configuration option
- `src/schema/types.rs` - `GenericResultType` struct and `GraphQLAny::GenericResult` variant
- `src/schema/context.rs` - Storage and retrieval for generic results
- `src/schema/resolver.rs` - Directive parsing and type resolution
- `src/entrypoint.rs` - Pass config to resolver
- `src/operation/parse.rs` - Handle generic results as object selections

**Codegen (`rust/shalom_dart_codegen/`)**
- `src/lib.rs` - Helper functions for templates
- `templates/schema.dart.jinja` - Generate `MutationResult` class

### Design Decisions

1. **Opt-in Feature**: Disabled by default for backward compatibility
2. **Directive-Based**: Clear schema-level marking of generic types
3. **Parse as Objects**: Reuses existing infrastructure, special handling in codegen
4. **Separate Storage**: Generic results stored independently for easy identification
5. **Fragment Reference**: Error handling delegated to user-defined fragments

## Benefits

✅ **Reduced Code Duplication**: One class instead of many similar ones
✅ **Type Safety**: Full generic type safety maintained
✅ **Centralized Error Handling**: Handle all mutation errors consistently
✅ **Helper Methods**: Built-in `isSuccess` and `hasError` utilities
✅ **Flexible Error Handling**: Use fragments to define error selection patterns
✅ **Backward Compatible**: Existing code continues to work unchanged

## Limitations & Future Work

### Current Limitations

1. **Operations Generate Individual Classes**: Type substitution not yet implemented
2. **Mutation-Only Pattern**: Not extended to queries/subscriptions yet
3. **Single Error Fragment**: Cannot specify multiple error patterns per type
4. **No Custom Class Names**: Always named `MutationResult`

### Planned Enhancements

1. **Full Operation Integration** (Phase 2)
   - Use `MutationResult<TData, TError>` directly in operations
   - Skip generating individual result classes
   - Automatic type parameter resolution

2. **Query Support**
   - Extend pattern to query results
   - Support for `QueryResult<TData, TError>`

3. **Customization Options**
   - Custom generic class names
   - Multiple error patterns
   - Configurable field names beyond data/error

4. **Optimized Cache Normalization**
   - Specialized handling for generic results
   - Improved performance for common patterns

## Migration Guide

### For New Projects

Simply enable the feature and use the directive on your result types.

### For Existing Projects

1. Enable in config: `enable_generic_results: true`
2. Add directive definition to schema
3. Create error fragments
4. Apply `@genericResult` to result types
5. Update operations to use error fragments
6. Regenerate code

**Note**: Types without the directive continue to work as before.

## Example Project Structure

```
my_project/
├── shalom.yml                    # enable_generic_results: true
├── graphql/
│   ├── schema.graphql           # Directive + types with @genericResult
│   └── operations/
│       ├── fragments.graphql    # GlobalErrorFrag definition
│       └── mutations.graphql    # Mutations using result types
└── lib/
    └── __graphql__/
        ├── schema.shalom.dart   # Generated MutationResult<T, E>
        └── ...                  # Generated operations
```

## FAQ

**Q: Do I need to use this for all my types?**
A: No, it's opt-in per type. Only types marked with `@genericResult` are affected.

**Q: Can I use different field names than "data" and "error"?**
A: Yes! Specify them in the directive: `@genericResult(dataField: "result", errorField: "problems", ...)`

**Q: Does this work with queries?**
A: Currently focused on mutations, but the architecture supports extending to queries.

**Q: What if my API doesn't follow this pattern?**
A: Don't use the directive. Shalom will generate regular classes as usual.

**Q: Can I customize the MutationResult class name?**
A: Not yet, but it's planned for a future enhancement.

## Resources

- Test case: `rust/shalom_dart_codegen/tests/usecases_test.rs`
- Example: `rust/shalom_dart_codegen/dart_tests/test/generic_mutation_result/`
- Architecture: `IMPLEMENTATION_SUMMARY.md`
- Project docs: `AGENTS.md`

## Support

For issues, questions, or feature requests related to this feature, please refer to the test cases and implementation summary for detailed technical information.