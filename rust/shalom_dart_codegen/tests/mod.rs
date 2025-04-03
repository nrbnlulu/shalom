use std::path::{Path, PathBuf};

use log::info;
mod usecases;

fn tests_path() -> PathBuf {
    let f = file!();
    PathBuf::from(f)
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .join("dart_tests")
        .join("test")
}

/// creates a test folder specific for the given usecase
fn generate_dart_test(usecase: &str) -> anyhow::Result<()> {
    let usecase_path = tests_path().join(usecase);
    std::fs::create_dir_all(&usecase_path)?;
    let dart_test_file = usecase_path.join("test.dart");
    std::fs::write(
        &dart_test_file,
        "import 'package:test/test.dart';\n\nvoid main() {}",
    )?;
    let gql_folder = usecase_path.join("__graphql__");
    std::fs::create_dir_all(&gql_folder)?;
    Ok(())
}

pub fn ensure_test_folder_exists(usecase: &str) -> anyhow::Result<PathBuf> {
    let usecase_path = tests_path().join(usecase);
    if !usecase_path.exists() {
        generate_dart_test(usecase)?;
    }
    Ok(usecase_path)
}

fn run_codegen(cwd: &Path) {
    shalom_dart_codegen::codegen_entry_point(&cwd).unwrap()
}

pub fn run_dart_tests_for_usecase(usecase: &str) {
    simple_logger::init().unwrap();
    let usecase_test_dir =
        ensure_test_folder_exists(usecase).expect("Failed to ensure test folder exists");
    run_codegen(&usecase_test_dir);

    let test_file = usecase_test_dir
        .clone()
        .join("test.dart")
        .canonicalize()
        .unwrap();
    let mut cmd = std::process::Command::new("dart");
    cmd.current_dir(&usecase_test_dir);
    cmd.arg("test").arg(test_file);
    let output = cmd.output().unwrap();
    let out_std = String::from_utf8_lossy(&output.stdout);
    let out_err = String::from_utf8_lossy(&output.stderr);
    if !out_std.contains("All tests passed!") {
        panic!("Dart tests failed: {}\n{}", out_err, out_std);
    }
    info!("✔️ Dart tests passed\n {}", out_std)
}
