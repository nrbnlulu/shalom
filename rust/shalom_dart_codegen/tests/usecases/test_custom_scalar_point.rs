use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "custom_scalar_point";

#[test]
fn test_custom_scalar_point_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
