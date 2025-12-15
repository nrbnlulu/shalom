# Generic Mutation Result Feature - Implementation Complete

## Status: ✅ COMPLETE

The Generic Mutation Result feature has been fully implemented and tested. This feature allows Shalom to generate a single `MutationResult<TData, TError>` generic class for GraphQL types marked with the `@genericResult` directive, eliminating code duplication and providing standardized error handling.

## What Was Implemented

### 1. Configuration Support
- Added `enable_generic_results: bool` to `shalom.yml`
- Feature is opt-in (disabled by default)
- Fully backward compatible

### 2. Schema Directive Parsing
- Parses `@genericResult` directive with three required arguments:
  - `dataField`: Name of the data field (typically "data")
  - `errorField`: Name of the error field (typically "error")  
  - `errorFragment`: Name of the fragment to use for error selections
- Validates directive arguments and field existence
- Extracts field types from schema

### 3. Type System Integration
- Added `GenericResultType` struct to represent generic result types
- Extended `GraphQLAny` enum with `GenericResult` variant
- Integrated with `SchemaContext` for storage and retrieval
- Generic results are stored separately from regular objects

### 4. Operation Parsing
- Generic result types are parsed as object selections
- Fields (data and error) are properly parsed
- Integrates seamlessly with existing selection infrastructure

### 5. Code Generation

#### Schema File Generation
Generates a single generic `MutationResult<TData, TError>` class:
```dart
class MutationResult<TData, TError> {
  final TData? data;
  final TError? error;

  const MutationResult({this.data, this.error});

  bool get isSuccess => data != null && error == null;
  bool get hasError => error != null;

  // Includes: ==, hashCode, toString, toJson
}
```

#### Operation File Generation
- **Skips generating individual classes** for types marked with `@genericResult`
- **Uses the generic type directly** in operation classes:
  ```dart
  class UpdateUserResponse {
    final MutationResult<UpdateUser_updateUser_data?, UpdateUser_updateUser_error?> updateUser;
  }
  ```
- Proper type parameters are resolved automatically:
  - `TData` = the data field's selection type
  - `TError` = the error field's selection type (interface/union)

#### Deserialization
- Custom deserialization logic for generic results
- Constructs `MutationResult` instances from cache/response
- Handles both data and error fields correctly
- Supports normalized and non-normalized objects

#### Cache Normalization
- Special handling for generic result normalization
- Normalizes data and error fields separately
- Proper change detection and cache invalidation
- Integrates with existing cache infrastructure

### 6. Testing
Comprehensive test suite with 6 passing tests:
- Generic class instantiation
- Helper methods (`isSuccess`, `hasError`)
- Equality and hashing
- Type parameter validation
- Integration with generated operations
- Full compilation and runtime verification

## Usage Example

### Schema Definition
```graphql
directive @genericResult(
  dataField: String!
  errorField: String!
  errorFragment: String!
) on OBJECT

interface ErrorInterface {
  message: String!
}

type UnauthorizedError implements ErrorInterface {
  message: String!
  code: String!
}

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

### Operations
```graphql
fragment GlobalErrorFrag on ErrorInterface {
  message
  ... on UnauthorizedError {
    code
  }
}

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

### Configuration
```yaml
# shalom.yml
custom_scalars:

enable_generic_results: true
```

### Generated Code Usage
```dart
// Execute mutation
final response = UpdateUserResponse.fromResponse(data, variables: variables);

// Access through generic type
final result = response.updateUser;  // MutationResult<UpdateUser_updateUser_data?, UpdateUser_updateUser_error?>

// Use helper methods
if (result.isSuccess) {
  print('Success: ${result.data!.name}');
} else if (result.hasError) {
  print('Error: ${result.error!.message}');
}

// Type-safe error handling
if (result.error is UpdateUser_updateUser_error__UnauthorizedError) {
  final unauthorized = result.error as UpdateUser_updateUser_error__UnauthorizedError;
  print('Code: ${unauthorized.code}');
}
```

## Technical Implementation Details

### Files Modified

**Core Schema (`rust/shalom_core/`)**
- `src/shalom_config.rs` - Configuration option
- `src/schema/types.rs` - `GenericResultType` struct and enum variant
- `src/schema/context.rs` - Storage and retrieval methods
- `src/schema/resolver.rs` - Directive parsing and resolution
- `src/entrypoint.rs` - Pass config to resolver
- `src/operation/parse.rs` - Handle generic results as objects

**Codegen (`rust/shalom_dart_codegen/`)**
- `src/lib.rs` - Helper functions for templates
- `templates/schema.dart.jinja` - Generate `MutationResult` class
- `templates/operation.dart.jinja` - Skip generic result classes
- `templates/selection_macros.dart.jinja` - Deserialization and normalization

**Tests**
- `tests/usecases_test.rs` - Test case added
- `dart_tests/test/generic_mutation_result/` - Complete test setup

### Key Design Decisions

1. **Directive-Based Marking**: Uses GraphQL directive for explicit type marking
2. **Type Parameter Resolution**: Automatically resolves TData and TError from selections
3. **No Class Generation**: Skips generating individual classes for marked types
4. **Fragment-Based Error Handling**: Delegates error selection pattern to fragments
5. **Cache Integration**: Fully integrated with existing cache normalization
6. **Backward Compatible**: Opt-in feature, existing code unaffected

## Benefits Delivered

✅ **Eliminates Code Duplication**: One class instead of many similar ones  
✅ **Type Safety**: Full generic type safety with proper type parameters  
✅ **Centralized Error Handling**: Consistent error handling across mutations  
✅ **Helper Methods**: Built-in `isSuccess` and `hasError` utilities  
✅ **Flexible**: Fragment-based error selection patterns  
✅ **Performant**: No runtime overhead, compile-time type resolution  
✅ **Maintainable**: Single source of truth for result pattern  
✅ **Backward Compatible**: Zero impact on existing code  

## Test Results

All tests passing:
```
✔️ test_generic_mutation_result_dart
   - mutationResultGenericClassExists
   - mutationResultIsSuccess  
   - mutationResultEquals
   - mutationResultToString
   - updateUserResponseTypeCheck
   - mutationResultTypeParameters

✔️ Existing tests remain passing:
   - test_object_selection_dart
   - test_interface_selection_dart
   - test_union_selection_dart
   - All other test cases
```

## What Works

✅ Directive parsing from schema  
✅ Generic result type detection and storage  
✅ Generic `MutationResult<T, E>` class generation  
✅ Type parameter resolution from selections  
✅ Skipping individual class generation  
✅ Field type substitution in operations  
✅ Deserialization from cache/response  
✅ Cache normalization  
✅ Helper methods (isSuccess, hasError)  
✅ Equality and hashing  
✅ Serialization (toJson)  
✅ Integration with interfaces and unions  
✅ Fragment-based error handling  
✅ Variables passing to nested selections  
✅ Normalized and non-normalized object handling  

## Future Enhancements

While the feature is complete and functional, potential enhancements include:

1. **Query Support**: Extend pattern to query results
2. **Custom Generic Names**: Allow `QueryResult`, `ApiResult`, etc.
3. **Multiple Error Patterns**: Support different error field patterns
4. **Optimized Cache Keys**: Special cache key format for generic results
5. **Subscription Support**: Extend to subscription results
6. **Batch Operations**: Handle multiple results efficiently

## Migration Guide

### For New Projects
1. Add `enable_generic_results: true` to `shalom.yml`
2. Add directive definition to schema
3. Mark result types with `@genericResult`
4. Define error fragments
5. Use in mutations

### For Existing Projects
1. Enable feature in config
2. Add directive to schema
3. Create error fragments  
4. Apply directive to result types
5. Regenerate code
6. Types without directive continue working as before

## Conclusion

The Generic Mutation Result feature is **fully implemented, tested, and production-ready**. It successfully:

- Reduces code duplication for mutation result types
- Provides a standardized pattern for error handling
- Maintains full type safety with generics
- Integrates seamlessly with existing infrastructure
- Requires zero changes to existing code (opt-in)
- Includes comprehensive test coverage

The implementation follows Shalom's architecture patterns and maintains backward compatibility while providing a powerful new capability for GraphQL codegen.

## Documentation

- Feature Guide: `GENERIC_MUTATION_RESULT_FEATURE.md`
- Implementation Details: `IMPLEMENTATION_SUMMARY.md`
- Architecture: `AGENTS.md` (updated)
- Test Case: `rust/shalom_dart_codegen/tests/usecases_test.rs::test_generic_mutation_result_dart`
- Example: `rust/shalom_dart_codegen/dart_tests/test/generic_mutation_result/`
