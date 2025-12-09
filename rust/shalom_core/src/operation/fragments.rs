use std::path::PathBuf;
use std::rc::Rc;
use std::sync::Arc;

use apollo_compiler::Node;
use serde::{Deserialize, Serialize};

use crate::context::SharedShalomGlobalContext;
use crate::operation::context::{ExecutableContext, TypeDefs};
use crate::operation::parse::{
    inject_id_in_selection_set, inject_typename_in_selection_set, parse_obj_like_from_selection_set,
};
use crate::operation::types::ObjectLikeCommon;

/// inline fragments should generally be generated in the same file
/// that they are declared and can't be used across the project (well they have no name)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InlineFragment {
    #[serde(flatten)]
    pub common: ObjectLikeCommon,
}
pub type SharedInlineFrag = Rc<InlineFragment>;

impl InlineFragment {
    pub fn new(common: ObjectLikeCommon) -> Self {
        InlineFragment { common }
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
    pub typedefs: TypeDefs,
    pub root_type: Option<ObjectLikeCommon>,
    pub type_condition: String,
}
pub type SharedFragmentContext = Arc<FragmentContext>;

impl FragmentContext {
    pub fn new(
        name: String,
        fragment_raw: String,
        file_path: PathBuf,
        type_condition: String,
    ) -> Self {
        FragmentContext {
            name,
            file_path,
            fragment_raw,
            typedefs: TypeDefs::new(),
            root_type: None,
            type_condition,
        }
    }

    pub fn get_fragment_name(&self) -> &str {
        &self.name
    }

    pub fn get_type_condition(&self) -> &str {
        &self.type_condition
    }

    pub fn set_on_type(&mut self, root_type: ObjectLikeCommon) {
        self.root_type.replace(root_type);
    }

    pub fn get_on_type(&self) -> &ObjectLikeCommon {
        self.root_type.as_ref().unwrap()
    }
}

unsafe impl Send for FragmentContext {}
unsafe impl Sync for FragmentContext {}

impl ExecutableContext for FragmentContext {
    fn name(&self) -> &str {
        self.get_fragment_name()
    }
    fn typedefs(&self) -> &TypeDefs {
        &self.typedefs
    }
    fn typedefs_mut(&mut self) -> &mut TypeDefs {
        &mut self.typedefs
    }

    fn has_variables(&self) -> bool {
        false
    }
    fn get_variable(&self, _name: &str) -> Option<&crate::operation::context::OperationVariable> {
        None // Fragments don't have variables
    }

    fn get_root(&self) -> &ObjectLikeCommon {
        self.get_on_type()
    }
}

pub(crate) fn parse_fragment(
    global_ctx: &SharedShalomGlobalContext,
    mut fragment: Node<apollo_compiler::executable::Fragment>,
    fragment_ctx: &mut FragmentContext,
) -> anyhow::Result<()> {
    // Inject __typename into union and interface selections
    // and inject id into object selections that have an id field
    let schema = &global_ctx.schema_ctx.schema;
    let fragment_mut = fragment.make_mut();
    inject_typename_in_selection_set(schema, &mut fragment_mut.selection_set, global_ctx);
    inject_id_in_selection_set(schema, &mut fragment_mut.selection_set, global_ctx);

    // Update fragment_raw with the injected fields
    fragment_ctx.fragment_raw = fragment.to_string();

    let selection_set = &fragment.selection_set;
    let type_name = fragment.type_condition();
    let frag_name = fragment_ctx.name.clone();
    let obj_like = parse_obj_like_from_selection_set(
        fragment_ctx,
        global_ctx,
        &frag_name,
        type_name.to_string().clone(),
        selection_set,
    );

    fragment_ctx.set_on_type(obj_like);
    Ok(())
}
