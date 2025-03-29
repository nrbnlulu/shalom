use shalom_dart_codegen::generate_dart_code;
use crate::utils::{run_command, remove_file};

#[test]
fn test_simple_scalars() {
    let directory = "tests/simple_scalars/dart/__graphql__"; 
    let output_path = format!("{}/lib/simple_scalars.dart", directory); 
    remove_file(&output_path);
    let codegen_output = run_command("cargo", &vec!["run", "--", "tests/schema.graphql", "tests/query.graphql", &output_path], None);
    assert!(codegen_output.status.success(), "Command failed: {:?}", codegen_output);
    let dart_test_output = run_command("dart", &vec!["test"], Some(directory));  
    assert!(dart_test_output.status.success(), "Command failed: {:?}", dart_test_output);
    assert!(dart_test_output.stderr.is_empty());
    // println!("{:?}", codegen_output.stderr);
    // println!("{:?}", dart_test_output);
}