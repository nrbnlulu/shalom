use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "object_selection";
#[test]
fn test_object_selection_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}

#[test]
fn test_nested_object_selection_dart() {
    run_dart_tests_for_usecase("nested_object_selection");
}
