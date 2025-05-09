use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "operation_scalar_arguments";
#[test]
fn test_operation_scalar_arguments_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
