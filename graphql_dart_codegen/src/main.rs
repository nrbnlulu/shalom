use std::fs;
use std::path::PathBuf;
use graphql_dart_codegen::generate_dart_code;

fn main() -> anyhow::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 4 {
        eprintln!("Usage: {} <schema_file> <query_file> <output_file>", args[0]);
        std::process::exit(1);
    }

    let schema = fs::read_to_string(&args[1])?;
    let query = fs::read_to_string(&args[2])?;
    let output_path = PathBuf::from(&args[3]);

    let generated_code = generate_dart_code(&schema, &query)?;
    fs::write(output_path, generated_code)?;

    Ok(())
}
