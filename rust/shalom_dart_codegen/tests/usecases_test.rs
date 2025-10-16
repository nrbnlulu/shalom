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
fn test_object_selection_with_typename_dart() {
    run_dart_tests_for_usecase("object_selection_with_typename");
}

#[test]
fn test_cache_by_arguments_object() {
    run_dart_tests_for_usecase("cache_by_arguments_object");
}

#[test]
fn test_nested_object_selection_dart() {
    run_dart_tests_for_usecase("nested_object_selection");
}

#[test]
fn test_fragments_dart() {
    run_dart_tests_for_usecase("fragments");
}

#[test]
fn test_cross_dir_fragments_dart() {
    run_dart_tests_for_usecase("cross_dir_fragments");
}

#[test]
fn test_fragment_with_nested_object_selection_dart() {
    run_dart_tests_for_usecase("fragment_with_nested_object_selection");
}

#[test]
fn test_union_selection_dart() {
    run_dart_tests_for_usecase("union_selection");
}

#[test]
fn test_union_partial_selection_dart() {
    run_dart_tests_for_usecase("union_partial_selection");
}

#[test]
fn test_interface_selection_dart() {
    run_dart_tests_for_usecase("interface_selection");
}

#[test]
fn test_list_of_scalars_dart() {
    run_dart_tests_for_usecase("list_of_scalars");
}

#[test]
fn test_list_of_objects_dart() {
    run_dart_tests_for_usecase("list_of_objects");
}

#[test]
fn test_list_of_custom_scalars_dart() {
    run_dart_tests_for_usecase("list_of_custom_scalars");
}

#[test]
fn test_list_of_enums_dart() {
    run_dart_tests_for_usecase("list_of_enums");
}

#[test]
fn test_list_of_fragments_dart() {
    run_dart_tests_for_usecase("list_of_fragments");
}

#[test]
fn test_list_of_unions_dart() {
    run_dart_tests_for_usecase("list_of_unions");
}

#[test]
fn test_list_of_interfaces_dart() {
    run_dart_tests_for_usecase("list_of_interfaces");
}

#[test]
fn test_fragments_on_interface_dart() {
    run_dart_tests_for_usecase("fragments_on_interface");
}

#[test]
fn test_object_fragment_list_interfaces_dart() {
    run_dart_tests_for_usecase("object_fragment_list_interfaces");
}

#[test]
fn test_interface_shared_fragments_dart() {
    run_dart_tests_for_usecase("interface_shared_fragments");
}
