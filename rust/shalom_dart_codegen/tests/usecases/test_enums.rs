use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "enums";
#[test]
fn test_object_selection_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}