use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "enum_arguments";

#[test]
fn test_enum_arguments_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
