use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "nested_input_objects";

#[test]
fn test_nested_input_objects_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
