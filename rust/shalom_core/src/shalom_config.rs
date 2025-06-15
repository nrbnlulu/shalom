use serde::Deserialize;
use std::{collections::HashMap, path::PathBuf};

#[derive(Debug, Deserialize)]
pub struct CustomScalarDefinition {
    pub graphql_name: String,
    pub scalar_dart_type: String,
    pub impl_symbol: RuntimeSymbolDefinition,
}

#[derive(Debug, Deserialize)]
pub struct RuntimeSymbolDefinition {
    pub import_path: PathBuf,
    pub symbol_name: String,
}

#[derive(Debug, Deserialize)]
pub struct ShalomConfig {
    pub custom_scalars: HashMap<String, CustomScalarDefinition>,
}
