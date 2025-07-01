use crate::run_dart_tests_for_usecase;

static USE_CASE_NAME: &str = "input_list_scalars";

#[test]
fn test_list_scalars_dart() {
    run_dart_tests_for_usecase(USE_CASE_NAME);
}
