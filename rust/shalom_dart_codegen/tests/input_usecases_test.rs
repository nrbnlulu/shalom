mod common;
use crate::common::run_dart_tests_for_usecase;
#[test]
fn test_operation_scalar_arguments_dart() {
    run_dart_tests_for_usecase("operation_scalar_arguments");
}
#[test]
fn test_custom_scalar_arguments_dart() {
    run_dart_tests_for_usecase("custom_scalar_arguments");
}

#[test]
fn test_enum_arguments_dart() {
    run_dart_tests_for_usecase("enum_arguments");
}

#[test]
fn test_input_objects_dart() {
    run_dart_tests_for_usecase("input_objects");
}

#[test]
fn test_input_list_scalars_dart() {
    run_dart_tests_for_usecase("input_list_scalars");
}

#[test]
fn test_input_list_enums_dart() {
    run_dart_tests_for_usecase("input_list_enums");
}
#[test]
fn test_input_list_objects_dart() {
    run_dart_tests_for_usecase("input_list_objects");
}

#[test]
fn test_input_list_custom_scalars_dart() {
    run_dart_tests_for_usecase("input_list_custom_scalars");
}

#[test]
fn test_nested_input_objects_dart() {
    run_dart_tests_for_usecase("nested_input_objects");
}

#[test]
fn test_input_objects_with_inline_variables_dart() {
    run_dart_tests_for_usecase("input_objects_with_inline_variables");
}

#[test]
fn test_required_inputs_with_defaults_dart() {
    run_dart_tests_for_usecase("required_inputs_with_defaults");
}

#[test]
fn test_input_list_with_defaults_dart() {
    run_dart_tests_for_usecase("input_list_with_defaults");
}
