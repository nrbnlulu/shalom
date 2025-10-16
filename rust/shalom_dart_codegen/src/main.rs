use anyhow::Result;
use clap::{Parser, Subcommand};
use notify::{RecursiveMode, Watcher};
use notify_debouncer_full::new_debouncer;
use shalom_dart_codegen::CodegenOptions;
use std::path::PathBuf;
use std::sync::{
    atomic::{AtomicBool, Ordering},
    Arc,
};
use std::time::Duration;

#[derive(Parser)]
#[command(name = "shalom")]
#[command(about = "GraphQL code generator for Dart and Flutter", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate Dart code from GraphQL schema and operations
    Generate {
        /// Path to the project directory (defaults to current directory)
        #[arg(short, long)]
        path: Option<PathBuf>,

        /// Fail on first error instead of continuing
        #[arg(short, long, default_value_t = false)]
        strict: bool,

        /// Auto format generated Dart files after generation
        #[arg(short, long, default_value_t = false)]
        fmt: bool,
    },
    /// Watch for changes in GraphQL files and regenerate code
    Watch {
        /// Path to the project directory (defaults to current directory)
        #[arg(short, long)]
        path: Option<PathBuf>,

        /// Fail on first error instead of continuing
        #[arg(short, long, default_value_t = false)]
        strict: bool,

        /// Auto format generated Dart files after generation
        #[arg(short, long, default_value_t = false)]
        fmt: bool,
    },
}

fn main() -> Result<()> {
    simple_logger::SimpleLogger::new()
        .with_level(log::LevelFilter::Info)
        .init()
        .unwrap();

    let cli = Cli::parse();
    match cli.command {
        Commands::Generate { path, strict, fmt } => {
            log::info!("Running code generation...");
            shalom_dart_codegen::codegen_entry_point(CodegenOptions {
                pwd: path,
                strict,
                fmt,
            })?;
            log::info!("Code generation completed successfully!");
        }
        Commands::Watch { path, strict, fmt } => {
            log::info!("Starting watch mode...");

            // Add atomic flag to prevent concurrent codegen runs
            let is_codegen_running = Arc::new(AtomicBool::new(false));

            // Run initial generation
            {
                let running = is_codegen_running.clone();
                if running
                    .compare_exchange(false, true, Ordering::SeqCst, Ordering::SeqCst)
                    .is_ok()
                {
                    match shalom_dart_codegen::codegen_entry_point(CodegenOptions {
                        pwd: path.clone(),
                        strict,
                        fmt,
                    }) {
                        Ok(_) => log::info!("Initial code generation completed successfully!"),
                        Err(e) => log::error!("Initial code generation failed: {}", e),
                    }
                    running.store(false, Ordering::SeqCst);
                } else {
                    log::warn!("Code generation is already running, skipping initial run.");
                }
            }

            let watch_path = path.clone().unwrap_or_else(|| PathBuf::from("."));

            log::info!(
                "Watching {} for changes in .graphql and .gql files...",
                watch_path.display()
            );
            log::info!("Press Ctrl+C to stop watching");

            let (tx, rx) = std::sync::mpsc::channel();

            // Create a debouncer with 500ms delay
            let mut debouncer = new_debouncer(Duration::from_millis(500), None, tx)?;

            // Watch the path recursively
            debouncer
                .watcher()
                .watch(&watch_path, RecursiveMode::Recursive)?;

            // Process events
            for result in rx {
                match result {
                    Ok(events) => {
                        // Check if any event involves a .graphql or .gql file
                        let has_graphql_changes = events.iter().any(|event| {
                            event.paths.iter().any(|path| {
                                path.extension()
                                    .and_then(|ext| ext.to_str())
                                    .map(|ext| ext == "graphql" || ext == "gql")
                                    .unwrap_or(false)
                            })
                        });

                        if has_graphql_changes {
                            log::info!("GraphQL file changes detected, regenerating...");
                            let running = is_codegen_running.clone();
                            if running
                                .compare_exchange(false, true, Ordering::SeqCst, Ordering::SeqCst)
                                .is_ok()
                            {
                                match shalom_dart_codegen::codegen_entry_point(CodegenOptions {
                                    pwd: path.clone(),
                                    strict,
                                    fmt,
                                }) {
                                    Ok(_) => log::info!("Code generation completed successfully!"),
                                    Err(e) => log::error!("Code generation failed: {}", e),
                                }
                                running.store(false, Ordering::SeqCst);
                            } else {
                                log::warn!(
                                    "Code generation is already running, skipping this event."
                                );
                            }
                        }
                    }
                    Err(errors) => {
                        for error in errors {
                            log::error!("Watch error: {:?}", error);
                        }
                    }
                }
            }
        }
    }

    Ok(())
}
