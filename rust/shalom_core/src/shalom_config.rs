use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
    env::current_dir,
    fs,
    path::{Path, PathBuf},
};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct CustomScalarDefinition {
    pub graphql_name: String,
    pub output_type: RuntimeSymbolDefinition,
    pub impl_symbol: RuntimeSymbolDefinition,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct RuntimeSymbolDefinition {
    pub import_path: Option<PathBuf>,
    pub symbol_name: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ShalomConfig {
    pub custom_scalars: HashMap<String, CustomScalarDefinition>,
    #[serde(default)]
    pub schema_output_path: Option<PathBuf>,
    /// Enable generic MutationResult type for types marked with @genericResult directive
    #[serde(default)]
    pub enable_generic_results: bool,
    #[serde(skip)]
    pub project_root: PathBuf,
}

impl Default for ShalomConfig {
    fn default() -> Self {
        Self {
            custom_scalars: HashMap::new(),
            schema_output_path: None,
            enable_generic_results: false,
            project_root: current_dir().unwrap(),
        }
    }
}
fn load_config_from_yaml_str(yaml: &str, config_dir: &Path) -> anyhow::Result<ShalomConfig> {
    let mut config: ShalomConfig =
        serde_yaml::from_str(yaml).map_err(|e| anyhow::anyhow!("Invalid YAML: {}", e))?;
    config.project_root = config_dir.to_path_buf();
    Ok(config)
}

fn find_config_in_nearest_parent() -> Option<PathBuf> {
    let pwd = current_dir().unwrap();
    // Check current directory first
    let config_path = pwd.join("shalom.yml");
    if config_path.exists() {
        return Some(config_path);
    }
    // Then check parent directories
    let mut parent = pwd.parent();
    while let Some(dir) = parent {
        let config_path = dir.join("shalom.yml");
        if config_path.exists() {
            return Some(config_path);
        }
        parent = dir.parent();
    }
    None
}
impl ShalomConfig {
    pub fn from_file(config_path: &PathBuf) -> anyhow::Result<Self> {
        let config_dir = config_path
            .parent()
            .ok_or_else(|| anyhow::anyhow!("Invalid config path: no parent directory"))?
            .to_path_buf();

        fs::read_to_string(config_path)
            .map_err(|e| {
                anyhow::anyhow!("Failed to read config at {}: {}", config_path.display(), e)
            })
            .and_then(|yaml| load_config_from_yaml_str(&yaml, &config_dir))
    }

    pub fn resolve_or_default() -> anyhow::Result<Self> {
        if let Some(config_file) = find_config_in_nearest_parent() {
            Self::from_file(&config_file)
        } else {
            Ok(Self::default())
        }
    }
}
