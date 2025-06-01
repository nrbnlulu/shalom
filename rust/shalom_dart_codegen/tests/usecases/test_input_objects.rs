use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "input_objects";

#[test]
fn test_input_objects_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
