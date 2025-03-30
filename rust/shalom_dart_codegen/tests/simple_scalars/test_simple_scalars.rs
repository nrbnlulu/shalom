use crate::utils::{run_command, remove_file};

#[test]
fn test_simple_scalars() {
    let directory = "tests/simple_scalars/dart/__graphql__"; 
    let schema_output_path = format!("{}/lib/simple_scalars_schema.dart", directory); 
    let query_output_path = format!("{}/lib/simple_scalars_query.dart", directory); 
    remove_file(&schema_output_path);
    remove_file(&query_output_path);
    let codegen_output = run_command("cargo", &vec!["run", "--", "tests/schema.graphql", "tests/query.graphql", &schema_output_path, &query_output_path], None);
    assert!(codegen_output.status.success(), "Command failed: {:?}", codegen_output);
    let dart_test_output = run_command("dart", &vec!["test"], Some(directory));  
    assert!(dart_test_output.status.success(), "Command failed: {:?}", dart_test_output);
    assert!(dart_test_output.stderr.is_empty());
}