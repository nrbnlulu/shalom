use shalom_dart_codegen::codegen_entry_point;
use std::path::PathBuf;

fn main() {
    // 👇 only run codegen for your Point scalar test folder
    let test_path = PathBuf::from("shalom_dart_codegen/dart_tests/test/custom_scalar_point/");

    match codegen_entry_point(&test_path) {
        Ok(_) => println!("Codegen succeeded for custom_scalar_point!"),
        Err(e) => eprintln!("❌ Codegen failed: {:?}", e),
    }
}
