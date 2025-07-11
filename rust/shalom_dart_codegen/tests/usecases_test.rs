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
fn test_enum_selection_dart() {
    run_dart_tests_for_usecase("enum_selection");
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
fn test_list_of_scalars_dart() {
    run_dart_tests_for_usecase("list_of_scalars");
}

#[test]
fn test_node_interface() {
    run_dart_tests_for_usecase("node_interface");
}
