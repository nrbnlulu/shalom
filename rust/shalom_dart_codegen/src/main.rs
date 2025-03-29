use std::fs;
use std::path::PathBuf;
use shalom_dart_codegen::{DartCodeGenerator};

fn main() -> anyhow::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 5 {
        eprintln!("Usage: {} <schema_file> <query_file> <schema_output_file> <query_output_file>", args[0]);
        std::process::exit(1);
    }

    let schema = fs::read_to_string(&args[1])?;
    let query = fs::read_to_string(&args[2])?;
    let schema_output_path = PathBuf::from(&args[3]);
    let query_output_path = PathBuf::from(&args[4]);
    for output_path in vec![&schema_output_path, &query_output_path] {
        if !output_path.exists() {
            fs::File::create(output_path)?;
        }
    }
    let schema_file = schema_output_path.file_name().unwrap().to_str().unwrap();
    let dart_code_generator = DartCodeGenerator::new(&schema, &query, &schema_file)?;
    let (schema_code, operations_code) = dart_code_generator.generate()?; 
    fs::write(schema_output_path, schema_code)?;
    fs::write(query_output_path, operations_code)?;
    Ok(())
}
