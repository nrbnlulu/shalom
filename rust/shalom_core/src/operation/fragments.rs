use std::path::PathBuf;
use std::rc::Rc;
use std::{collections::HashMap, sync::Arc};

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Name, Node, Schema,
};
use serde::{Deserialize, Serialize};

use super::types::{
    get_selections_with_fragments_distinct, FullPathName, Selection, SharedInterfaceSelection,
    SharedUnionSelection,
};

use crate::context::{ShalomGlobalContext, SharedShalomGlobalContext};
use crate::operation::context::{ExecutableContext, TypeDefs};
use crate::operation::parse::{inject_typename_in_selection_set, parse_interface_selection, parse_object_selection};
use crate::operation::types::{ObjectLikeCommon, SelectionCommon, SelectionKind};



/// inline fragments should generally be generated in the same file 
/// that they are declared and can't be used across the project (well they have no name)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InlineFragment{
    pub path_name: String,
    pub type_condition: String,
    pub common: ObjectLikeCommon
}
pub type SharedInlineFrag = Rc<InlineFragment>;

impl InlineFragment {
    pub fn new(path_name: String, type_condition: String, common: ObjectLikeCommon) -> Self {
        InlineFragment {
            path_name,
            type_condition,
            common,
        }
    }
    
    pub fn merge(&mut self, other: InlineFragment) {
        self.common.merge(other.common);
    }
}


pub type FragName = String;

#[derive(Debug, Serialize)]
pub struct FragmentContext {
    pub name: FragName,
    pub fragment_raw: String,
    #[serde(skip_serializing)]
    pub file_path: PathBuf,
    pub type_defs: TypeDefs,
    pub root: ObjectLikeCommon,
    pub type_condition: String,
}
pub type SharedFragmentContext = Arc<FragmentContext>;

impl FragmentContext {
    pub fn new(
        name: String,
        fragment_raw: String,
        file_path: PathBuf,
        root: ObjectLikeCommon,
        type_condition: String,
    ) -> Self {
        FragmentContext {
            name,
            file_path,
            fragment_raw,
            type_defs: TypeDefs::new(),
            root,
            type_condition,
        }
    }

    pub fn get_fragment_name(&self) -> &str {
        &self.name
    }

    pub fn get_type_condition(&self) -> &str {
        &self.type_condition
    }

    pub fn set_on_type(&mut self, root_type: Selection) {
        self.on_type = Some(root_type);
    }

    pub fn add_used_fragment(&mut self, fragment: SharedFragmentContext) {
        self.used_fragments.push(fragment);
    }

    pub fn get_used_fragments(&self) -> &Vec<SharedFragmentContext> {
        &self.used_fragments
    }

    pub fn get_on_type(&self) -> Option<&Selection> {
        self.on_type.as_ref()
    }


    pub fn add_union_type(&mut self, name: String, union_selection: SharedUnionSelection) {
        self.union_types.entry(name).or_insert(union_selection);
    }

    pub fn get_union_types(&self) -> &HashMap<FullPathName, SharedUnionSelection> {
        &self.union_types
    }

    pub fn add_interface_type(
        &mut self,
        name: String,
        interface_selection: SharedInterfaceSelection,
    ) {
        self.interface_types
            .entry(name)
            .or_insert(interface_selection);
    }

    pub fn get_interface_types(&self) -> &HashMap<FullPathName, SharedInterfaceSelection> {
        &self.interface_types
    }
}

unsafe impl Send for FragmentContext {}
unsafe impl Sync for FragmentContext {}



impl ExecutableContext for FragmentContext {
    fn name(&self) -> &str {
        self.get_fragment_name()
    }
    fn typedefs(&self) -> &TypeDefs {
        &self.type_defs
    }
    fn typedefs_mut(&mut self) -> &mut TypeDefs {
        &mut self.type_defs
    }

    fn has_variables(&self) -> bool {
        false
    }
    fn get_variable(&self, _name: &str) -> Option<&crate::operation::context::OperationVariable> {
        None // Fragments don't have variables
    }
}



pub(crate) fn parse_fragment(
    global_ctx: &SharedShalomGlobalContext,
    mut fragment: Node<apollo_compiler::executable::Fragment>,
    fragment_ctx: &mut FragmentContext,
) -> anyhow::Result<()> {
    // Inject __typename into union and interface selections
    let schema = &global_ctx.schema_ctx.schema;
    let fragment_mut = fragment.make_mut();
    inject_typename_in_selection_set(schema, &mut fragment_mut.selection_set, global_ctx);

    let selection_set = &fragment.selection_set;
    let type_name = fragment.type_condition();
    let type_info = global_ctx
        .schema_ctx
        .get_type(&type_name.to_string())
        .unwrap();

    let selection_common = SelectionCommon {
        name: fragment_ctx.get_fragment_name().to_string(),
        description: None,
    };

    let root_selection = match type_info {
        crate::schema::types::GraphQLAny::Object(_) => {
            let root_obj = parse_object_selection(
                fragment_ctx,
                global_ctx,
                &fragment_ctx.get_fragment_name().to_string(),
                false,
                selection_set,
                None, // Fragment root object, not a multi-type member
            );
            // fragments has no arguments
            Selection::new(selection_common, SelectionKind::Object(root_obj), vec![])
        }
        crate::schema::types::GraphQLAny::Interface(interface_type) => {
            // Check if the selection set has inline fragments
            let has_inline_fragments = selection_set
                .selections
                .iter()
                .any(|sel| matches!(sel, apollo_executable::Selection::InlineFragment(_)));

            if has_inline_fragments {
                // Parse as interface selection with type discrimination
                let root_interface = parse_interface_selection(
                    fragment_ctx,
                    global_ctx,
                    &fragment_ctx.get_fragment_name().to_string(),
                    false,
                    selection_set,
                    interface_type,
                );
                Selection::new(
                    selection_common,
                    SelectionKind::Interface(root_interface),
                    vec![],
                )
            } else {
                // No inline fragments - treat as simple object selection
                let root_obj = parse_object_selection(
                    fragment_ctx,
                    global_ctx,
                    &fragment_ctx.get_fragment_name().to_string(),
                    false,
                    selection_set,
                    None,
                );
                Selection::new(selection_common, SelectionKind::Object(root_obj), vec![])
            }
        }
        _ => {
            return Err(anyhow::anyhow!(
                "Fragment {} type condition {} is not an object or interface type",
                fragment_ctx.get_fragment_name(),
                type_name
            ));
        }
    };


    fragment_ctx.set_on_type(root_selection.clone());
    let frag_name = fragment_ctx.get_fragment_name().to_string();
    (fragment_ctx as &mut dyn ExecutableContext).add_selection(frag_name, root_selection);
    Ok(())
}


pub (crate) fn parse_inline_fragment<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    inline_frag: apollo_executable::InlineFragment,
){
    let type_cond = inline_frag.type_condition.expect("inline fragments with no type condition are not supported.").to_string();
    let this_path = format!("{}__{}", path, type_cond);
    let mut selections = Vec::new();
    for selection in inline_frag.selection_set.selections{
        match selection{
            apollo_executable::Selection::Field(field) => {
                
            },
            apo
        }
    }
}
