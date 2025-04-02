use lazy_static::lazy_static;
use std::{fs, path::{Path, PathBuf}};
mod usecases;

fn tests_path() -> PathBuf {
    let f = file!();
    PathBuf::from(f).parent().unwrap().parent().unwrap().parent().unwrap().join("dart_tests").join("test")
}

/// creates a test folder specific for the given usecase
fn generate_dart_test(usecase: &str) -> anyhow::Result<()> {
    let usecase_path = tests_path().join(usecase);
    std::fs::create_dir_all(&usecase_path)?;
    let dart_test_file = usecase_path.join("test.dart");
    std::fs::write(&dart_test_file, "import 'package:test/test.dart';\n\nvoid main() {}")?;
    let gql_folder = usecase_path.join("__graphql__");
    std::fs::create_dir_all(&gql_folder)?;
    Ok(())
}


pub fn ensure_test_folder_exists(usecase: &str) -> anyhow::Result<()> {
    let usecase_path = tests_path().join(usecase);
    if !usecase_path.exists() {
        generate_dart_test(usecase)?;
    }
    Ok(())
}

fn run_codegen(cwd: &Path) { 
    todo!()
}

pub fn run_dart_tests_for_usecase(usecase: &str)  {
    ensure_test_folder_exists(usecase).expect("Failed to ensure test folder exists");
    let tests_dir = tests_path().join(usecase);
    let test_file = tests_dir.clone().join("test.dart").canonicalize().unwrap();
    let mut cmd = std::process::Command::new("dart");
    cmd.current_dir(&tests_dir);
    cmd.arg("test").arg(test_file);
    let output = cmd.output().unwrap();
    let out_std = String::from_utf8_lossy(&output.stdout);
    let out_err = String::from_utf8_lossy(&output.stderr);
    if !out_std.contains("All tests passed!"){
        panic!("Dart tests failed: {}\n{}", out_err, out_std);
    }
    
}
