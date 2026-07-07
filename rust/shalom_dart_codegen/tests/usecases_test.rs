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
fn test_union_common_interface_dart() {
    run_dart_tests_for_usecase("union_common_interface");
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

#[test]
fn test_nested_fragments_3_level_dart() {
    run_dart_tests_for_usecase("nested_fragments_3_level");
}

#[test]
fn test_fragment_id_on_non_root_field_dart() {
    run_dart_tests_for_usecase("fragment_id_on_non_root_field");
}

#[test]
fn test_interface_with_nested_type_fragments_dart() {
    run_dart_tests_for_usecase("interface_with_nested_type_fragments");
}

#[test]
fn test_fragment_inherited_interface_fields_dart() {
    run_dart_tests_for_usecase("fragment_inherited_interface_fields");
}

#[test]
fn test_fragment_concrete_spread_interface_frag_dart() {
    run_dart_tests_for_usecase("fragment_concrete_spread_interface_frag");
}

#[test]
fn test_one_of_input_dart() {
    run_dart_tests_for_usecase("one_of_input");
}

#[test]
fn test_runtime_metadata_dart() {
    run_dart_tests_for_usecase("runtime_metadata");
}

// -------------------------------------------------------------------------
// Flutter tests
// -------------------------------------------------------------------------

#[test]
fn test_flutter_animal_widget() {
    common::run_flutter_tests("animal_widget_test.dart");
}

#[test]
fn test_flutter_user_widget() {
    common::run_flutter_tests("user_widget_test.dart");
}

#[test]
fn test_flutter_pet_widget() {
    common::run_flutter_tests("pet_widget_test.dart");
}

#[test]
fn test_flutter_zoo_widget_nested_fragment() {
    common::run_flutter_tests("zoo_widget_test.dart");
}

#[test]
fn test_flutter_zoo_animals_widget_list_of_interface() {
    common::run_flutter_tests("zoo_animals_widget_test.dart");
}

#[test]
fn test_flutter_shared_fragment_subscription() {
    common::run_flutter_tests("shared_fragment_subscription_test.dart");
}

#[test]
fn test_flutter_shared_fragment_contract() {
    common::run_flutter_tests("shared_fragment_contract_test.dart");
}

#[test]
fn test_flutter_declarative_raw_fragments() {
    common::run_flutter_tests("declarative_raw_fragments_test.dart");
}

#[test]
fn test_flutter_animal_with_owner_widget() {
    common::run_flutter_tests("animal_with_owner_widget_test.dart");
}

#[test]
fn test_mutation_simple_dart() {
    run_dart_tests_for_usecase("mutation_simple");
}

#[test]
fn test_mutation_no_variables_dart() {
    run_dart_tests_for_usecase("mutation_no_variables");
}
