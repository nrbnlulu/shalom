use shalom_dart_codegen::generate_dart_code;
use std::process::Command;

#[test]
fn test_command() {
    let output = Command::new("cargo")
    .args(&["run", "--", "tests/schema.graphql", "tests/query.graphql", "tests/simple_scalars/dart/__graphql__/simple_scalars.dart"])
    .output()
    .expect("Failed to execute command");

    assert!(output.status.success(), "Command failed: {:?}", output);
}