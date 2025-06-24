use crate::run_dart_tests_for_usecase;


#[test]
fn test_list_of_enum_input() {
    static USE_CASE_NAME: &str = "list_of_enum_input";
    run_dart_tests_for_usecase(USE_CASE_NAME);
}

