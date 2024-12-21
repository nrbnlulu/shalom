use std::{collections::HashMap, sync::Arc};

use apollo_compiler::{ executable::{Fragment, Operation}, validation::Valid, ExecutableDocument, Node};
use schema::context::SharedSchemaContext;

pub mod schema;
pub mod operation;


#[derive(Debug)]
pub struct GenerationContext {
    fragments: HashMap<String, Node<Fragment>>,
    operations: HashMap<String, Node<Operation>>,
    pub schema: SharedSchemaContext,
    pub docs: Vec<Valid<ExecutableDocument>>
}





impl GenerationContext{
    pub fn new(schema: SharedSchemaContext, docs: Vec<Valid<ExecutableDocument>>) -> anyhow::Result<Self>{
        let mut frags = HashMap::new();

        let mut ops = HashMap::new();

        
        for doc in docs.iter(){
            for (name, def) in doc.fragments.iter(){
                frags.insert(name.to_string(), def.clone());
                }
            for op in doc.operations.iter(){
                let op_name = op.name.clone().ok_or(anyhow::anyhow!("Operation must have a name:\n {}", op.to_string()))?.to_string();
                if ops.contains_key(&op_name){
                    return Err(anyhow::anyhow!("Operation with name {} already exists", op_name));
                }
                ops.insert(op_name, op.clone());
            }
            }
            

        Ok(GenerationContext{
            schema,
            docs,
            operations: ops,
            fragments: frags
        })
    }
}


