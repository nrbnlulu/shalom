# Test Suite Summary for fromJson Feature

## Overview
This document describes the comprehensive test suite created for the `fromJson` feature added to the Shalom GraphQL code generator. The feature adds experimental `fromJson` static methods to generated Dart classes, enabling direct deserialization from JSON without cache interaction.

## Changes Covered by Tests

### 1. Template Changes (Jinja)
- **New macro**: `_deserialize_selection_from_json_macro` in `selection_macros.dart.jinja`
- **New method**: `fromJson` static method added to object selections
- **New method**: `fromJson` static method added to multi-type (union/interface) selections
- **Import addition**: `package:meta/meta.dart` import for `@experimental` annotation

### 2. Dependency Changes
- Added `meta: ^1.16.0` to `dart/shalom_core/pubspec.yaml`
- Updated YAML formatting for consistency

## Test Suites

### 1. from_json_deserialization (48 tests across 18 groups)

**Location**: `rust/shalom_dart_codegen/dart_tests/test/from_json_deserialization/`

**Purpose**: Comprehensive testing of the `fromJson` deserialization functionality across all GraphQL types and scenarios.

#### Test Groups:

1. **fromJson - Object Selection** (4 tests)
   - Required objects with all fields
   - Objects with null optional fields
   - Optional objects when present
   - Optional objects when null

2. **fromJson - Nested Objects and Lists** (3 tests)
   - Nested objects in lists
   - Empty lists
   - Optional nested objects

3. **fromJson - Enum Selection** (2 tests)
   - Enum value deserialization
   - All enum variants

4. **fromJson - Union Selection** (5 tests)
   - User variant deserialization
   - Product variant deserialization
   - Optional union when present
   - Optional union when null
   - Unknown __typename error handling

5. **fromJson - Interface Selection** (5 tests)
   - Dog implementation deserialization
   - Cat implementation deserialization
   - Optional interface when present
   - Optional interface when null
   - Unknown __typename error handling

6. **fromJson - Custom Scalars** (2 tests)
   - Custom scalar deserialization (DateTime)
   - Custom scalar error handling

7. **fromJson - Edge Cases** (5 tests)
   - Deeply nested optional fields
   - Empty strings
   - Zero and negative numbers
   - Large numbers
   - Special characters in strings

8. **fromJson - Type Safety** (3 tests)
   - Type safety for scalar types
   - Type mismatch errors
   - Missing required field errors

9. **fromJson vs fromResponse comparison** (2 tests)
   - Result equivalence
   - Cache independence

10. **fromJson - Fragments** (2 tests)
    - Objects using fragments
    - Nested objects with fragments

11. **fromJson - Deeply Nested Structures** (1 test)
    - Multiple levels of nesting

12. **fromJson - List Edge Cases** (2 tests)
    - Lists with null elements
    - Lists with many elements (100+)

13. **fromJson - Boolean Values** (2 tests)
    - Boolean true
    - Boolean false

14. **fromJson - Float/Double Precision** (2 tests)
    - Decimal precision maintenance
    - Minuscule decimals

15. **fromJson - Unicode and Special Characters** (2 tests)
    - Unicode characters (emoji, CJK)
    - Newlines and tabs

16. **fromJson - Complex Multi-Type Scenarios** (2 tests)
    - Switching between union types
    - Interface with missing optional fields

17. **fromJson - Error Handling** (3 tests)
    - Invalid enum value
    - Null in non-nullable field
    - Wrong list element type

18. **fromJson - Performance Considerations** (1 test)
    - Large dataset handling (50+ items)

#### GraphQL Schema Coverage:
- Scalars: ID, String, Int, Float, Boolean
- Custom scalars: DateTime
- Enums: Category
- Objects: User, Product, Settings, SimpleObject
- Unions: SearchResult (User | Product)
- Interfaces: Animal (Dog, Cat implementations)
- Lists: Required and optional, nested
- Nullable fields at all levels

### 2. experimental_annotation (9 tests across 3 groups)

**Location**: `rust/shalom_dart_codegen/dart_tests/test/experimental_annotation/`

**Purpose**: Verify that the `@experimental` annotation is correctly applied and that the meta package integration works.

#### Test Groups:

1. **Experimental Annotation Tests** (5 tests)
   - `fromJson` method existence on response class
   - `fromJson` is a static method (verified via reflection)
   - `fromJson` has `@experimental` annotation (verified via reflection)
   - Proper nested object deserialization
   - Nested object `fromJson` availability

2. **Meta Package Integration** (1 test)
   - Meta package import works in generated code

3. **fromJson vs fromResponse Compatibility** (3 tests)
   - Result equivalence between methods
   - Cache independence verification
   - Works without ShalomCtx parameter

#### Key Features Tested:
- Dart reflection (`dart:mirrors`) to verify annotations
- Static method verification
- Annotation metadata inspection
- Cache isolation

### 3. meta_dependency_validation (4 tests in 1 group)

**Location**: `rust/shalom_dart_codegen/dart_tests/test/meta_dependency_validation/`

**Purpose**: Validate that `pubspec.yaml` changes are correct and properly formatted.

#### Test Group:

1. **Meta Package Dependency Validation** (4 tests)
   - `meta` dependency presence
   - YAML formatting (4-space indentation)
   - All required dependencies present
   - Dev dependencies present

#### Validated Dependencies:
- `meta: ^1.16.0` (newly added)
- `collection: ^1.18.0`
- `async: >=2.11.0`
- `lints: ^4.0.0` (dev)
- `test: ^1.24.0` (dev)

## Test Execution

### Running Tests

The tests are integrated into the existing Rust test framework:

```bash
# Run all tests
cargo test

# Run specific test suite
cargo test test_from_json_deserialization_dart
cargo test test_experimental_annotation_dart
cargo test test_meta_dependency_validation
```

### Test Infrastructure

Tests use the existing `run_dart_tests_for_usecase` function which:
1. Ensures test folder exists
2. Runs code generation on the GraphQL schema/operations
3. Formats generated Dart code
4. Executes Dart tests using the `dart test` command

## Coverage Summary

### What's Tested:
✅ All GraphQL type kinds (Scalar, Object, Enum, Union, Interface, List)
✅ Optional and required fields at all nesting levels
✅ Custom scalar deserialization
✅ Fragment usage with `fromJson`
✅ Error handling (type mismatches, missing fields, invalid values)
✅ Performance with larger datasets
✅ Unicode and special character handling
✅ Boolean, Float/Double precision
✅ Annotation presence and correctness
✅ Meta package integration
✅ Dependency configuration
✅ Cache independence
✅ Compatibility with existing `fromResponse` method

### Edge Cases Covered:
- Null values in optional fields
- Empty strings and empty lists
- Zero, negative, and large numbers
- Deeply nested structures (3+ levels)
- Lists with 100+ elements
- Unicode characters, emojis, and special characters
- Type safety violations
- Unknown __typename in unions/interfaces
- Invalid enum values
- Custom scalar deserialization errors

## Test Quality Metrics

- **Total Tests**: 61 tests
- **Test Groups**: 22 groups
- **Code Coverage**: Comprehensive coverage of all new template macros and methods
- **Error Scenarios**: 8+ explicit error handling tests
- **Performance Tests**: 1 test with 50+ item dataset
- **Integration Tests**: Full end-to-end from GraphQL schema to working Dart code

## Maintenance Notes

### Adding New Tests
When extending the `fromJson` functionality:
1. Add corresponding test cases to `from_json_deserialization/test.dart`
2. Consider edge cases specific to the new feature
3. Verify annotation behavior if adding new methods
4. Update this documentation

### Common Issues
- If tests fail with "Dart SDK not found", install Dart SDK
- Generated code is in `__graphql__/` subdirectories
- Tests run in sandbox environment (no external network access)

## Related Files

### Changed Files (in diff):
- `dart/shalom_core/pubspec.yaml` - Added meta dependency
- `rust/shalom_dart_codegen/templates/fragment.dart.jinja` - Added meta import
- `rust/shalom_dart_codegen/templates/operation.dart.jinja` - Added meta import
- `rust/shalom_dart_codegen/templates/selection_macros.dart.jinja` - Added fromJson methods and macro

### Test Files Created:
- `rust/shalom_dart_codegen/dart_tests/test/from_json_deserialization/*`
- `rust/shalom_dart_codegen/dart_tests/test/experimental_annotation/*`
- `rust/shalom_dart_codegen/dart_tests/test/meta_dependency_validation/*`
- `rust/shalom_dart_codegen/tests/usecases_test.rs` - Added 3 new test functions

## Conclusion

This test suite provides comprehensive coverage of the new `fromJson` functionality, ensuring:
- Correct deserialization across all GraphQL types
- Proper annotation application
- Dependency configuration correctness
- Backward compatibility with existing code
- Robust error handling
- Performance characteristics

The tests follow Dart/Flutter best practices and integrate seamlessly with the existing test infrastructure.