use std::path::{Path, PathBuf};

use log::info;

fn tests_path() -> PathBuf {
    let f = file!();
    PathBuf::from(f)
        .parent()
        .unwrap()
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
        "import 'package:test/test.dart';\nimport 'package:shalom_core/shalom_core.dart';\n\n\nvoid main() {}",
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

fn run_codegen(cwd: &Path, strict: bool) {
    shalom_dart_codegen::codegen_entry_point(cwd, strict).unwrap()
}

pub fn run_dart_tests_for_usecase(usecase: &str) {
    match simple_logger::init() {
        Ok(_) => println!("Logger initialized"),
        Err(e) => eprintln!("Error initializing logger: {e}"),
    }
    let usecase_test_dir =
        ensure_test_folder_exists(usecase).expect("Failed to ensure test folder exists");
    run_codegen(&usecase_test_dir, true);

    let mut cmd;
    #[cfg(target_os = "windows")]
    {
        cmd = std::process::Command::new("dart.bat");
    }
    #[cfg(not(target_os = "windows"))]
    {
        cmd = std::process::Command::new("dart");
    }
    let dart_test_root = tests_path().join("..");
    cmd.current_dir(&dart_test_root);
    cmd.arg("test").arg(format!("test/{usecase}/test.dart"));
    info!("Running command: {cmd:?} inside {dart_test_root:?}");
    let output = cmd.output().unwrap();
    let out_std = String::from_utf8_lossy(&output.stdout);

    assert!(output.status.success(), "❌ Dart tests failed\n {out_std}");
    info!("✔️ Dart tests passed\n {out_std}");
}
