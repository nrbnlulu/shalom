mod common;
use crate::common::run_dart_tests_for_usecase;

#[test]
fn test_simple_scalars_dart() {
    run_dart_tests_for_usecase("simple_scalars");
}

#[test]
fn test_custom_scalar_dart() {
    run_dart_tests_for_usecase("custom_scalar");
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
fn test_enum_selection_dart() {
    run_dart_tests_for_usecase("enum_selection");
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
fn test_nested_input_objects_dart() {
    run_dart_tests_for_usecase("nested_input_objects");
}

#[test]
fn test_object_selection_dart() {
    run_dart_tests_for_usecase("object_selection");
}

#[test]
fn test_nested_object_selection_dart() {
    run_dart_tests_for_usecase("nested_object_selection");
}

#[test]
fn test_operation_scalar_arguments_dart() {
    run_dart_tests_for_usecase("operation_scalar_arguments");
}

