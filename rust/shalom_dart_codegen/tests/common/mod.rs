use shalom_dart_codegen::{CodegenOptions, get_dart_command, get_flutter_command};
use std::path::{Path, PathBuf};

use log::info;

use glob::glob;

fn tests_path(tests_dir_name: &str) -> PathBuf {
    let mut current_dir = PathBuf::from(file!());

    // Traverse up the directory tree
    while let Some(parent) = current_dir.clone().parent() {
        // Construct the glob pattern: "[parent_path]/dart_tests"
        // This pattern checks for "dart_tests" directly inside the parent directory.
        let glob_pattern = parent.join(tests_dir_name);

        // Convert the PathBuf to a string
        let pattern_str = glob_pattern
            .to_str()
            .expect("Path to glob pattern is not valid UTF-8");

        // Execute the glob search
        if let Ok(mut entries) = glob(pattern_str) {
            // Check if any matching entry (the dart_tests folder) was found
            if let Some(Ok(dart_tests_path)) = entries.next() {
                // Return the found path joined with the "test" subdirectory
                return dart_tests_path.join("test");
            }
        }

        // Move to the next parent directory for the next iteration
        // The loop continues the "recursive" search by moving one level up.
        current_dir = parent.to_path_buf();

        // Stop if we reach the root directory
        if current_dir == parent.parent().unwrap_or(parent) {
            break;
        }
    }

    panic!(
        "Could not find the 'dart_tests/test' directory by searching up from {}",
        file!()
    );
}

/// creates a test folder specific for the given usecase
fn generate_dart_test(usecase: &str) -> anyhow::Result<()> {
    let usecase_path = tests_path("dart_tests").join(usecase);
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

pub fn ensure_test_folder_exists(tests_dir_name: &str, usecase: &str) -> anyhow::Result<PathBuf> {
    let usecase_path = tests_path(tests_dir_name).join(usecase);
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
        gen_dir: None,
    })
    .unwrap()
}

/// `flutter test` (unlike `dart test`) does not run the `native_toolchain_rust`
/// build hook automatically, so the FFI lib never lands in `.dart_tool/lib/`.
/// Build it ourselves and drop it where `test_env.dart`'s `_nativeLibPath()`
/// expects it.
fn ensure_native_lib_built(root_dir: &Path) {
    let workspace_root = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .and_then(Path::parent)
        .expect("could not find workspace root from CARGO_MANIFEST_DIR")
        .to_path_buf();

    let status = std::process::Command::new("cargo")
        .args(["build", "-p", "shalom_ffi"])
        .current_dir(&workspace_root)
        .status()
        .expect("failed to spawn `cargo build -p shalom_ffi`");
    assert!(status.success(), "`cargo build -p shalom_ffi` failed");

    let lib_name = if cfg!(target_os = "windows") {
        "shalom_ffi.dll"
    } else if cfg!(target_os = "macos") {
        "libshalom_ffi.dylib"
    } else {
        "libshalom_ffi.so"
    };
    let built_path = workspace_root.join("target/debug").join(lib_name);
    let dest_dir = root_dir.join(".dart_tool/lib");
    std::fs::create_dir_all(&dest_dir).expect("failed to create .dart_tool/lib");
    std::fs::copy(&built_path, dest_dir.join(lib_name)).unwrap_or_else(|e| {
        panic!("failed to copy {built_path:?} -> {dest_dir:?}: {e}");
    });
}

#[allow(dead_code)]
static FLUTTER_TESTS_CODEGEN: std::sync::Once = std::sync::Once::new();

pub fn run_dart_tests_for_usecase(usecase: &str) {
    match simple_logger::init() {
        Ok(_) => println!("Logger initialized"),
        Err(e) => eprintln!("Error initializing logger: {e}"),
    }
    let usecase_test_dir = ensure_test_folder_exists("dart_tests", usecase)
        .expect("Failed to ensure test folder exists");
    run_codegen(&usecase_test_dir, true);

    let dart = match get_dart_command() {
        Ok(cmd) => cmd,
        Err(e) => {
            panic!("⚠️  {e}. install dart");
        }
    };

    let dart_test_root = tests_path("dart_tests").join("..");
    let dart_parts: Vec<&str> = dart.split_whitespace().collect();
    let mut dart_fmt = if dart_parts.len() > 1 {
        let mut cmd = std::process::Command::new(dart_parts[0]);
        for part in &dart_parts[1..] {
            cmd.arg(part);
        }
        cmd
    } else {
        std::process::Command::new(&dart)
    };
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

    let mut dart_test = if dart_parts.len() > 1 {
        let mut cmd = std::process::Command::new(dart_parts[0]);
        for part in &dart_parts[1..] {
            cmd.arg(part);
        }
        cmd
    } else {
        std::process::Command::new(&dart)
    };
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

#[allow(dead_code)]
pub fn run_flutter_tests(usecase: &str) {
    match simple_logger::init() {
        Ok(_) => println!("Logger initialized"),
        Err(e) => eprintln!("Error initializing logger: {e}"),
    }
    let tests_dir = tests_path("flutter_tests");
    let dart = match get_dart_command() {
        Ok(cmd) => cmd,
        Err(e) => {
            panic!("⚠️  {e}. install dart");
        }
    };
    let root_dir = &tests_dir.parent().unwrap();

    let dart_parts: Vec<&str> = dart.split_whitespace().collect();
    FLUTTER_TESTS_CODEGEN.call_once(|| {
        ensure_native_lib_built(root_dir);
        run_codegen(root_dir, true);
        let mut dart_fmt = if dart_parts.len() > 1 {
            let mut cmd = std::process::Command::new(dart_parts[0]);
            for part in &dart_parts[1..] {
                cmd.arg(part);
            }
            cmd
        } else {
            std::process::Command::new(&dart)
        };
        let output = dart_fmt
            .current_dir(root_dir)
            .arg("format")
            .arg("./lib")
            .arg("./test")
            .output()
            .unwrap();
        info!(
            "Running command: {dart_fmt:?} => {}",
            String::from_utf8_lossy(&output.stderr)
        );
    });

    let flutter_cmd = get_flutter_command().unwrap();
    let flutter_parts: Vec<&str> = flutter_cmd.split_whitespace().collect();

    let mut flutter_test = if flutter_parts.len() > 1 {
        let mut cmd = std::process::Command::new(flutter_parts[0]);
        for part in &flutter_parts[1..] {
            cmd.arg(part);
        }
        cmd
    } else {
        std::process::Command::new(&flutter_cmd)
    };
    flutter_test
        .current_dir(root_dir)
        .arg("test")
        .arg(format!("test/{usecase}"));
    info!("Running command: {flutter_test:?} for usecase: {usecase}");
    let output = flutter_test.output().unwrap();
    let out_std = String::from_utf8_lossy(&output.stdout);

    assert!(
        output.status.success(),
        "❌ Flutter tests failed\n {out_std}"
    );
    info!("✔️ Flutter tests passed\n {out_std}");
}
