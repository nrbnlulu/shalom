use crate::shalom_config::{CustomScalarDefinition, ShalomConfig};

use crate::{
    operation::context::SharedOpCtx,
    operation::fragments::{FragmentContext, SharedFragmentContext},
    schema::context::SharedSchemaContext,
};
use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

#[derive(Debug)]
pub struct ShalomGlobalContext {
    operations: Mutex<HashMap<String, SharedOpCtx>>,
    fragments: Mutex<HashMap<String, SharedFragmentContext>>,
    pub schema_ctx: SharedSchemaContext,
    pub config: ShalomConfig,
}

unsafe impl Send for ShalomGlobalContext {}
unsafe impl Sync for ShalomGlobalContext {}

impl ShalomGlobalContext {
    pub fn new(schema_ctx: SharedSchemaContext, config: ShalomConfig) -> Arc<Self> {
        Arc::new(Self {
            operations: Mutex::new(HashMap::new()),
            fragments: Mutex::new(HashMap::new()),
            schema_ctx,
            config,
        })
    }

    pub fn register_operations(&self, operations_update: HashMap<String, SharedOpCtx>) {
        let mut operations = self.operations.lock().unwrap();
        let fragments = self.fragments.lock().unwrap();
        for (name, _) in operations_update.iter() {
            if operations.contains_key(name) {
                panic!("Operation with name {} already exists", name);
            }
            if fragments.contains_key(name) {
                panic!(
                    "Operation name {} conflicts with existing fragment name",
                    name
                );
            }
            // Check if operation name conflicts with schema types
            if self.schema_ctx.get_type(name).is_some() {
                panic!("Operation name {} conflicts with schema type", name);
            }
        }
        operations.extend(operations_update);
    }

    pub fn get_operation(&self, name: &str) -> Option<SharedOpCtx> {
        self.operations.lock().unwrap().get(name).cloned()
    }

    pub fn operations(&self) -> Vec<(String, SharedOpCtx)> {
        let operations = self.operations.lock().unwrap();
        operations
            .iter()
            .map(|(name, op)| (name.clone(), op.clone()))
            .collect()
    }

    pub fn find_custom_scalar(&self, graphql_name: &str) -> Option<&CustomScalarDefinition> {
        self.config.custom_scalars.get(graphql_name)
    }

    pub fn get_custom_scalars(&self) -> &HashMap<String, CustomScalarDefinition> {
        &self.config.custom_scalars
    }

    pub fn operation_exists(&self, name: &str) -> bool {
        let operations = self.operations.lock().unwrap();
        operations.contains_key(name)
    }

    pub fn register_fragments(
        &self,
        fragments_update: HashMap<String, FragmentContext>,
    ) -> anyhow::Result<()> {
        let mut fragments = self.fragments.lock().unwrap();
        let operations = self.operations.lock().unwrap();
        for (name, _) in fragments_update.iter() {
            if fragments.contains_key(name) {
                return Err(anyhow::anyhow!(
                    "Fragment with name {} already exists",
                    name
                ));
            }
            if operations.contains_key(name) {
                return Err(anyhow::anyhow!(
                    "Fragment name {} conflicts with existing operation name",
                    name
                ));
            }
            // Check if fragment name conflicts with schema types
            if self.schema_ctx.get_type(name).is_some() {
                return Err(anyhow::anyhow!(
                    "Fragment name {} conflicts with schema type",
                    name
                ));
            }
        }
        for (name, frag_ctx) in fragments_update {
            fragments.insert(name, Arc::new(frag_ctx));
        }
        Ok(())
    }

    pub fn get_fragment(&self, name: &str) -> Option<SharedFragmentContext> {
        self.fragments.lock().unwrap().get(name).cloned()
    }
    pub fn get_fragment_strict(&self, name: &str) -> SharedFragmentContext {
        self.get_fragment(name).expect(&format!("fragment not found {}", name))
    }

    pub fn fragments(&self) -> Vec<(String, SharedFragmentContext)> {
        let fragments = self.fragments.lock().unwrap();
        fragments
            .iter()
            .map(|(name, frag)| (name.clone(), frag.clone()))
            .collect()
    }

    pub fn fragment_exists(&self, name: &str) -> bool {
        let fragments = self.fragments.lock().unwrap();
        fragments.contains_key(name)
    }
}

pub type SharedShalomGlobalContext = Arc<ShalomGlobalContext>;

pub fn load_config_from_yaml_str(yaml: &str) -> anyhow::Result<ShalomConfig> {
    let config: ShalomConfig =
        serde_yaml::from_str(yaml).map_err(|e| anyhow::anyhow!("Invalid YAML: {}", e))?;
    Ok(config)
}
