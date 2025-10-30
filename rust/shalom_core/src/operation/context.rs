use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::sync::Arc;

use serde::Serialize;

use super::fragments::SharedFragmentContext;
use super::types::{
    FieldSelection, FullPathName, OperationType, SharedInterfaceSelection, SharedUnionSelection,
};
use crate::context::ShalomGlobalContext;
use crate::operation::fragments::{FragName, SharedInlineFrag};
use crate::operation::types::{
    ObjectLikeCommon, SelectionKind, SharedListSelection, SharedObjectSelection,
};
use crate::schema::{context::SharedSchemaContext, types::InputFieldDefinition};
pub type OperationVariable = InputFieldDefinition;

#[derive(Debug, Serialize)]
pub struct TypeDefs {
    /// all selections
    pub selections: HashMap<FullPathName, FieldSelection>,
    /// all object selections in this executable
    pub objects: HashMap<FullPathName, SharedObjectSelection>,
    /// all interface selections in this executable
    pub interfaces: HashMap<FullPathName, SharedInterfaceSelection>,
    /// all list selections in this executable
    pub lists: HashMap<FullPathName, SharedListSelection>,
    /// all union types that was selected in this executable
    pub unions: HashMap<FullPathName, SharedUnionSelection>,
    /// all inline fragments in this executable
    pub used_inline_frags: HashMap<FullPathName, SharedInlineFrag>,
    /// all fragments (not flattened) used in this executable
    #[serde(skip_serializing)]
    used_fragments_internal: HashMap<String, SharedFragmentContext>,
}

impl TypeDefs {
    pub fn new() -> Self {
        TypeDefs {
            selections: HashMap::new(),
            objects: HashMap::new(),
            unions: HashMap::new(),
            interfaces: HashMap::new(),
            lists: HashMap::new(),
            used_inline_frags: HashMap::new(),
            used_fragments_internal: HashMap::new(),
        }
    }

    pub fn add_object_selection(&mut self, name: String, selection: SharedObjectSelection) {
        self.objects.entry(name.clone()).or_insert(selection);
    }

    pub fn get_object_selection(&self, name: &FullPathName) -> Option<&SharedObjectSelection> {
        self.objects.get(name)
    }

    pub fn add_union_selection(&mut self, name: String, selection: SharedUnionSelection) {
        self.unions.entry(name.clone()).or_insert(selection);
    }

    pub fn get_union_selection(&self, name: &FullPathName) -> Option<&SharedUnionSelection> {
        self.unions.get(name)
    }

    pub fn add_interface_selection(&mut self, name: String, selection: SharedInterfaceSelection) {
        self.interfaces.entry(name.clone()).or_insert(selection);
    }
    pub fn get_interface_selection(
        &self,
        name: &FullPathName,
    ) -> Option<&SharedInterfaceSelection> {
        self.interfaces.get(name)
    }

    pub fn add_list_selection(&mut self, name: String, selection: SharedListSelection) {
        self.lists.entry(name.clone()).or_insert(selection);
    }
    pub fn get_list_selection(&self, name: &FullPathName) -> Option<&SharedListSelection> {
        self.lists.get(name)
    }

    pub fn add_used_inline_frag(&mut self, path_name: FullPathName, frag: SharedInlineFrag) {
        self.used_inline_frags.insert(path_name, frag);
    }
    pub fn get_used_inline_frags(&self) -> &HashMap<FullPathName, SharedInlineFrag> {
        &self.used_inline_frags
    }

    pub fn add_used_fragment(&mut self, frag: SharedFragmentContext) {
        self.used_fragments_internal.insert(frag.name.clone(), frag);
    }
    pub fn get_used_fragments(&self) -> &HashMap<FragName, SharedFragmentContext> {
        &self.used_fragments_internal
    }
    pub fn get_used_fragment(&self, name: &str) -> Option<&SharedFragmentContext> {
        self.used_fragments_internal.get(name)
    }

    #[kash::kash(size = "1", in_impl)]
    fn flatten_used_fragments(&self) {
        let mut visited = HashSet::new();
        let mut result = Vec::new();
        fn collect_fragments_recursive<'a, T: Iterator<Item = &'a SharedFragmentContext>>(
            fragments: T,
            visited: &mut HashSet<String>,
            result: &mut Vec<SharedFragmentContext>,
        ) {
            for frag in fragments {
                let frag_name = frag.name.clone();
                if visited.insert(frag_name) {
                    // First collect nested fragments
                    collect_fragments_recursive(
                        frag.type_defs.used_fragments_internal.values(),
                        visited,
                        result,
                    );
                    // Then add this fragment
                    result.push(frag.clone());
                }
            }
        }
        collect_fragments_recursive(
            self.used_fragments_internal.values(),
            &mut visited,
            &mut result,
        )
    }
}

impl Default for TypeDefs {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(Debug, Serialize)]
pub struct OperationContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    operation_name: String,
    pub file_path: PathBuf,
    query: String,
    variables: HashMap<String, OperationVariable>,
    pub type_defs: TypeDefs,
    root_type: Option<ObjectLikeCommon>,
    op_ty: OperationType,
}

unsafe impl Send for OperationContext {}
unsafe impl Sync for OperationContext {}

impl OperationContext {
    pub fn new(
        schema: SharedSchemaContext,
        operation_name: String,
        query: String,
        file_path: PathBuf,
        op_ty: OperationType,
    ) -> Self {
        OperationContext {
            schema,
            operation_name,
            file_path,
            query,
            variables: HashMap::new(),
            type_defs: TypeDefs::new(),
            root_type: None,
            op_ty,
        }
    }
    pub fn get_operation_name(&self) -> &str {
        &self.operation_name
    }
    pub fn has_variables(&self) -> bool {
        !self.variables.is_empty()
    }

    pub fn set_root_type(&mut self, root_type: ObjectLikeCommon) {
        self.root_type = Some(root_type);
    }

    pub fn add_variable(&mut self, name: String, variable: OperationVariable) {
        self.variables.entry(name).or_insert(variable);
    }
    pub fn get_variable(&self, name: &str) -> Option<&OperationVariable> {
        self.variables.get(name)
    }
}

pub type SharedOpCtx = Arc<OperationContext>;

// Trait to abstract over OperationContext and FragmentContext
pub trait ExecutableContext: Send + Sync + 'static {
    fn name(&self) -> &str;
    fn get_variable(&self, name: &str) -> Option<&crate::operation::context::OperationVariable>;
    fn has_variables(&self) -> bool;
    fn typedefs(&self) -> &TypeDefs;
    fn typedefs_mut(&mut self) -> &mut TypeDefs;

    fn get_selection(&self, name: &String, _: &ShalomGlobalContext) -> Option<&FieldSelection> {
        let td = self.typedefs();
        td.selections.get(name)
    }

    fn add_selection(&mut self, name: String, selection: FieldSelection) {
        let td = self.typedefs_mut();
        let name_clone = name.clone();
        match &selection.kind {
            SelectionKind::Interface(iface) => td.add_interface_selection(name, iface.clone()),
            SelectionKind::Object(obj) => td.add_object_selection(name, obj.clone()),
            SelectionKind::List(list) => td.add_list_selection(name, list.clone()),
            SelectionKind::Union(union) => td.add_union_selection(name, union.clone()),
            // other selection kinds shouldn't be available globally.
            _ => (),
        }
        td.selections.insert(name_clone, selection);
    }

    fn get_selection_strict(&self, name: &String, ctx: &ShalomGlobalContext) -> &FieldSelection {
        self.get_selection(name, ctx).unwrap_or_else(|| {
            panic!("selection for {name} not found neither in this context nor in its fragments")
        })
    }
}

impl ExecutableContext for OperationContext {
    fn name(&self) -> &str {
        self.get_operation_name()
    }
    fn has_variables(&self) -> bool {
        self.has_variables()
    }
    fn typedefs(&self) -> &TypeDefs {
        &self.type_defs
    }
    fn typedefs_mut(&mut self) -> &mut TypeDefs {
        &mut self.type_defs
    }
    fn get_variable(&self, name: &str) -> Option<&crate::operation::context::OperationVariable> {
        self.get_variable(name)
    }
}
