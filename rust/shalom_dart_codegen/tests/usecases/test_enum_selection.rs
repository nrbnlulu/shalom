use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "enum_selection";

#[test]
fn test_enum_selection_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
