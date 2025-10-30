use std::path::PathBuf;
use std::rc::Rc;
use std::sync::Arc;

use apollo_compiler::{executable as apollo_executable, Node};
use serde::{Deserialize, Serialize};

use crate::context::SharedShalomGlobalContext;
use crate::operation::context::{ExecutableContext, TypeDefs};
use crate::operation::parse::{
    inject_typename_in_selection_set, parse_obj_like_from_selection_set, parse_selection,
};
use crate::operation::types::ObjectLikeCommon;

/// inline fragments should generally be generated in the same file
/// that they are declared and can't be used across the project (well they have no name)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InlineFragment {
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
    pub root: Option<ObjectLikeCommon>,
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
            root: None,
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
        self.root.replace(root_type);
    }

    pub fn get_on_type(&self) -> &ObjectLikeCommon {
        self.root.as_ref().unwrap()
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

    let obj_like = parse_obj_like_from_selection_set(
        fragment_ctx,
        global_ctx,
        &"".to_string(),
        type_name.to_string().clone(),
        selection_set,
    );

    fragment_ctx.set_on_type(obj_like);
    Ok(())
}

pub(crate) fn parse_inline_fragment<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    inline_frag: &apollo_executable::InlineFragment,
) -> InlineFragment {
    let type_cond = inline_frag
        .type_condition
        .as_ref()
        .expect("inline fragments with no type condition are not supported.")
        .to_string();
    let this_path = format!("{}__{}", path, type_cond);
    let mut obj_like = ObjectLikeCommon::new(this_path.clone(), type_cond);

    for selection in &inline_frag.selection_set.selections {
        parse_selection(ctx, global_ctx, &this_path, &mut obj_like, selection);
    }
    InlineFragment::new(obj_like)
}
