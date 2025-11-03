use shalom_dart_codegen::CodegenOptions;
use std::path::{Path, PathBuf};

use log::{info, warn};

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
    shalom_dart_codegen::codegen_entry_point(CodegenOptions {
        pwd: Some(cwd.to_path_buf()),
        strict,
        fmt: false,
    })
    .unwrap()
}

fn is_dart_available() -> bool {
    let dart;
    #[cfg(target_os = "windows")]
    {
        dart = "dart.bat";
    }
    #[cfg(not(target_os = "windows"))]
    {
        dart = "dart";
    }

    std::process::Command::new(dart)
        .arg("--version")
        .output()
        .map(|output| output.status.success())
        .unwrap_or(false)
}

pub fn run_dart_tests_for_usecase(usecase: &str) {
    match simple_logger::init() {
        Ok(_) => println!("Logger initialized"),
        Err(e) => eprintln!("Error initializing logger: {e}"),
    }
    let usecase_test_dir =
        ensure_test_folder_exists(usecase).expect("Failed to ensure test folder exists");
    run_codegen(&usecase_test_dir, true);

    if !is_dart_available() {
        warn!("⚠️  Dart SDK not found. Skipping Dart tests for '{usecase}'. Install Dart SDK to run these tests.");
        println!("⚠️  Dart SDK not found. Skipping Dart tests for '{usecase}'.");
        return;
    }

    let dart;
    #[cfg(target_os = "windows")]
    {
        dart = "dart.bat";
    }
    #[cfg(not(target_os = "windows"))]
    {
        dart = "dart";
    }

    let dart_test_root = tests_path().join("..");
    let mut dart_fmt = std::process::Command::new(dart);
    let output = dart_fmt
        .current_dir(&dart_test_root)
        .arg("format")
        .arg(format!("test/{usecase}"))
        .output()
        .unwrap();
    info!(
        "Running command: {dart_fmt:?} inside {dart_test_root:?} => {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let mut dart_test = std::process::Command::new(dart);
    dart_test
        .current_dir(&dart_test_root)
        .arg("test")
        .arg(format!("test/{usecase}/test.dart"));
    info!("Running command: {dart_test:?} inside {dart_test_root:?}");
    let output = dart_test.output().unwrap();
    let out_std = String::from_utf8_lossy(&output.stdout);

    assert!(output.status.success(), "❌ Dart tests failed\n {out_std}");
    info!("✔️ Dart tests passed\n {out_std}");
}
