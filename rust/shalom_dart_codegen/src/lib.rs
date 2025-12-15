use anyhow::Result;
use lazy_static::lazy_static;
use log::{error, info};
use minijinja::{context, value::ViaDeserialize, Environment};
use shalom_core::{
    context::{ShalomGlobalContext, SharedShalomGlobalContext},
    operation::{
        context::{ExecutableContext, OperationContext, SharedOpCtx},
        fragments::{FragmentContext, SharedFragmentContext},
        types::{
            dart_type_for_scalar, FieldSelection, ObjectLikeCommon, SelectionKind,
            SharedListSelection,
        },
    },
    schema::{
        context::SchemaContext,
        types::{GraphQLAny, InputFieldDefinition, SchemaFieldCommon},
    },
    shalom_config::RuntimeSymbolDefinition,
};

use std::{
    collections::{HashMap, HashSet},
    fs,
    hash::{DefaultHasher, Hash, Hasher},
    path::{Path, PathBuf},
    process::Command,
    sync::Arc,
};

lazy_static! {
    static ref DEFAULT_SCALARS_MAP: HashMap<String, String> = HashMap::from([
        ("ID".to_string(), "String".to_string()),
        ("String".to_string(), "String".to_string()),
        ("Int".to_string(), "int".to_string()),
        ("Float".to_string(), "double".to_string()),
        ("Boolean".to_string(), "bool".to_string()),
    ]);
}

#[cfg(windows)]
const LINE_ENDING: &str = "\r\n";
#[cfg(not(windows))]
const LINE_ENDING: &str = "\n";

mod ext_jinja_fns {

    use shalom_core::context::ShalomGlobalContext;

    use super::*;
    fn resolve_scalar_typename(
        scalar_name: &str,
        ctx: &ShalomGlobalContext,
        is_optional: bool,
    ) -> String {
        if let Some(custom_scalar) = ctx.find_custom_scalar(scalar_name) {
            let mut output_typename = custom_scalar.output_type.symbol_fullname();
            if is_optional {
                output_typename.push('?');
            }
            output_typename
        } else {
            let mut resolved = dart_type_for_scalar(scalar_name);
            if is_optional {
                resolved.push('?');
            }
            resolved
        }
    }

    fn type_name_for_kind_impl(ctx: &SharedShalomGlobalContext, kind: &SelectionKind) -> String {
        match kind {
            SelectionKind::List(list) => {
                let inner_type_name = type_name_for_kind_impl(ctx, &list.of_kind);

                if list.is_optional {
                    format!("List<{}>?", inner_type_name)
                } else {
                    format!("List<{}>", inner_type_name)
                }
            }
            SelectionKind::Scalar(scalar) => {
                resolve_scalar_typename(&scalar.concrete_type.name, ctx, scalar.is_optional)
            }

            SelectionKind::Object(object) => {
                // Check if this object is a generic result type
                if is_schema_typename_generic_result(&object.common.schema_typename, ctx) {
                    let data_field =
                        get_generic_result_data_field(&object.common.schema_typename, ctx);
                    let error_field =
                        get_generic_result_error_field(&object.common.schema_typename, ctx);

                    // Find the data and error field selections
                    let data_type = object
                        .common
                        .selections
                        .iter()
                        .find(|s| s.selection_common.name == data_field)
                        .map(|data_sel| type_name_for_kind_impl(ctx, &data_sel.kind))
                        .unwrap_or_else(|| "dynamic".to_string());

                    let error_type = object
                        .common
                        .selections
                        .iter()
                        .find(|s| s.selection_common.name == error_field)
                        .map(|error_sel| type_name_for_kind_impl(ctx, &error_sel.kind))
                        .unwrap_or_else(|| "dynamic".to_string());

                    let generic_type = format!("MutationResult<{}, {}>", data_type, error_type);

                    if object.is_optional {
                        format!("{}?", generic_type)
                    } else {
                        generic_type
                    }
                } else {
                    // Regular object, not a generic result
                    if object.is_optional {
                        format!("{}?", object.common.path_name)
                    } else {
                        object.common.path_name.clone()
                    }
                }
            }
            SelectionKind::Enum(enum_) => {
                if enum_.is_optional {
                    format!("{}?", enum_.concrete_type.name)
                } else {
                    enum_.concrete_type.name.clone()
                }
            }
            SelectionKind::Union(union) => {
                if union.common.is_optional {
                    format!("{}?", union.common.common.path_name)
                } else {
                    union.common.common.path_name.clone()
                }
            }
            SelectionKind::Interface(interface) => {
                if interface.common.is_optional {
                    format!("{}?", interface.common.common.path_name)
                } else {
                    interface.common.common.path_name.clone()
                }
            }
        }
    }

    pub fn type_name_for_selection(
        ctx: &SharedShalomGlobalContext,
        selection: ViaDeserialize<FieldSelection>,
    ) -> String {
        type_name_for_kind_impl(ctx, &selection.0.kind)
    }

    fn resolve_schema_typename(
        ty: &GraphQLAny,
        is_optional: bool,
        ctx: &ShalomGlobalContext,
    ) -> String {
        let mut typename = match &ty {
            GraphQLAny::Scalar(scalar) => resolve_scalar_typename(&scalar.name, ctx, is_optional),
            GraphQLAny::InputObject(obj) => obj.name.clone(),
            GraphQLAny::Enum(enum_) => enum_.name.clone(),
            GraphQLAny::List { of_type } => {
                let inner = resolve_schema_typename(&of_type.ty, of_type.is_optional, ctx);
                format!("List<{inner}>")
            }
            GraphQLAny::GenericResult(gr) => {
                // Generic results should not appear in input types
                // This is mainly for completeness
                gr.name.clone()
            }
            _ => panic!("Unsupported type: {:?}", ty),
        };
        // scalars optionals are handled in `resolve_scalar_typename`
        if is_optional && ty.scalar().is_none() {
            typename.push('?')
        }
        typename
    }

    pub fn is_schema_typename_generic_result(
        schema_typename: &str,
        ctx: &SharedShalomGlobalContext,
    ) -> bool {
        ctx.schema_ctx
            .get_type(&schema_typename.to_string())
            .map(|t| matches!(t, GraphQLAny::GenericResult(_)))
            .unwrap_or(false)
    }

    pub fn is_generic_result_type(type_name: &str, ctx: &SharedShalomGlobalContext) -> bool {
        ctx.schema_ctx
            .get_type(&type_name.to_string())
            .map(|t| matches!(t, GraphQLAny::GenericResult(_)))
            .unwrap_or(false)
    }

    pub fn resolve_generic_result_error_fragment(
        generic_result: &str,
        ctx: &SharedShalomGlobalContext,
    ) -> String {
        if let Some(gr) = ctx.schema_ctx.get_generic_result(generic_result) {
            gr.error_fragment.clone()
        } else {
            "ErrorFragment".to_string()
        }
    }

    /// Get the data field name for a generic result type
    pub fn get_generic_result_data_field(
        schema_typename: &str,
        ctx: &SharedShalomGlobalContext,
    ) -> String {
        if let Some(gr) = ctx.schema_ctx.get_generic_result(schema_typename) {
            gr.data_field.clone()
        } else {
            "data".to_string()
        }
    }

    /// Get the error field name for a generic result type
    pub fn get_generic_result_error_field(
        schema_typename: &str,
        ctx: &SharedShalomGlobalContext,
    ) -> String {
        if let Some(gr) = ctx.schema_ctx.get_generic_result(schema_typename) {
            gr.error_field.clone()
        } else {
            "error".to_string()
        }
    }

    /// Get the error fragment name for a generic result type
    pub fn get_generic_result_error_fragment_name(
        schema_typename: &str,
        ctx: &SharedShalomGlobalContext,
    ) -> String {
        if let Some(gr) = ctx.schema_ctx.get_generic_result(schema_typename) {
            gr.error_fragment.clone()
        } else {
            "ErrorFragment".to_string()
        }
    }

    pub fn type_name_for_input_field(
        ctx: &SharedShalomGlobalContext,
        field: ViaDeserialize<InputFieldDefinition>,
    ) -> String {
        let field = field.0;
        let resolved_type = field.common.unresolved_type.resolve(&ctx.schema_ctx);
        let is_optional = resolved_type.is_optional;
        let res = resolve_schema_typename(&resolved_type.ty, is_optional, ctx);

        if field.is_maybe {
            format!("shalom_core.Maybe<{res}>")
        } else {
            res
        }
    }

    pub fn type_name_for_one_of_input_field(
        ctx: &SharedShalomGlobalContext,
        field: ViaDeserialize<InputFieldDefinition>,
    ) -> String {
        let field = field.0;
        let resolved_type = field.common.unresolved_type.resolve(&ctx.schema_ctx);
        // For oneOf fields, always treat as non-optional since exactly one must be present
        resolve_schema_typename(&resolved_type.ty, false, ctx)
    }

    pub fn parse_field_default_value_deserializer(
        ctx: &SharedShalomGlobalContext,
        field: ViaDeserialize<InputFieldDefinition>,
    ) -> String {
        let field = field.0;
        let default_value = field
            .default_value
            .as_ref()
            .expect("cannot parse default value that does not exist")
            .to_string();

        let ty = field.common.resolve_type(&ctx.schema_ctx);
        if default_value == "null" {
            return default_value;
        }
        match ty.ty {
            GraphQLAny::Enum(enum_) => {
                format!("{}.{}", enum_.name, default_value)
            }
            GraphQLAny::Scalar(scalar) => {
                if scalar.is_builtin_scalar() {
                    default_value
                } else {
                    // Custom scalar - need to deserialize
                    let scalar_impl =
                        ext_jinja_fns::custom_scalar_impl_fullname(ctx, scalar.name.clone());
                    format!("{}.deserialize({})", scalar_impl, default_value)
                }
            }
            GraphQLAny::List { of_type: _ } => format!("const {}", default_value),
            _ => default_value,
        }
    }

    pub fn is_kind_requires_initializer_list(ty: &GraphQLAny) -> bool {
        match ty {
            // Built-in scalars can use inline defaults
            GraphQLAny::Scalar(scalar) => !scalar.is_builtin_scalar(),
            // Enums can use inline defaults
            GraphQLAny::Enum(_) => false,
            // Lists: recursively check inner type
            GraphQLAny::List { of_type } => is_kind_requires_initializer_list(&of_type.ty),
            // Input objects need initializer lists
            GraphQLAny::InputObject(_) => true,
            // Everything else doesn't need it (or shouldn't appear here)
            _ => false,
        }
    }

    pub fn field_requires_initializer_list(
        ctx: &SharedShalomGlobalContext,
        field: ViaDeserialize<InputFieldDefinition>,
    ) -> bool {
        let field = field.0;
        if field.default_value.is_none() {
            return false;
        }
        let resolved_type = field.common.unresolved_type.resolve(&ctx.schema_ctx);
        is_kind_requires_initializer_list(&resolved_type.ty)
    }

    pub fn get_fields_requiring_initializer_list(
        ctx: &SharedShalomGlobalContext,
        fields: ViaDeserialize<HashMap<String, InputFieldDefinition>>,
    ) -> HashMap<String, InputFieldDefinition> {
        let mut result = HashMap::new();
        for (name, field) in fields.iter() {
            // Only fields with default values need checking
            if field.default_value.is_none() {
                continue;
            }
            let resolved_type = field.common.unresolved_type.resolve(&ctx.schema_ctx);

            // Check if field type requires initializer list
            if is_kind_requires_initializer_list(&resolved_type.ty) {
                result.insert(name.clone(), field.clone());
            }
        }
        result
    }

    pub fn resolve_field_type(
        schema_ctx: &SchemaContext,
        schema_field: ViaDeserialize<SchemaFieldCommon>,
    ) -> minijinja::value::Value {
        let serialized = serde_json::to_value(schema_field.0.unresolved_type.resolve(schema_ctx))
            .map_err(|e| format!("Failed to serialize field type: {}", e))
            .unwrap();
        minijinja::value::Value::from_serialize(serialized)
    }

    pub fn docstring(value: Option<String>) -> String {
        match value {
            Some(doc) => doc
                .lines()
                .filter(|line| !line.trim().is_empty())
                .map(|line| format!("/// {}", line.trim()))
                .collect::<Vec<_>>()
                .join(LINE_ENDING),
            None => String::new(),
        }
    }

    pub fn custom_scalar_impl_fullname(
        ctx: &SharedShalomGlobalContext,
        scalar_name: String,
    ) -> String {
        let scalar = ctx
            .find_custom_scalar(&scalar_name)
            .expect("Custom scalar not found");
        scalar.impl_symbol.symbol_fullname()
    }

    pub fn is_custom_scalar(ctx: &SharedShalomGlobalContext, scalar_name: &str) -> bool {
        ctx.find_custom_scalar(scalar_name).is_some()
    }

    pub fn dart_type_for_scalar_name(scalar_name: &str) -> String {
        dart_type_for_scalar(scalar_name)
    }

    pub fn is_type_implementing_interface(
        ctx: &SharedShalomGlobalContext,
        type_name: &str,
        interface_name: &str,
    ) -> bool {
        ctx.schema_ctx
            .is_type_implementing_interface(type_name, interface_name)
    }
}

/// takes a number and returns itself as if the abc was 123, i.e 143 would be "adc"
fn number_to_abc(n: u32) -> String {
    let abc = "abcdefghijklmnopqrstuvwxyz";
    let mut result = String::new();
    let mut num = n;
    while num > 0 {
        let index = (num - 1) % 26;
        result.push(abc.chars().nth(index as usize).unwrap());
        num = (num - 1) / 26;
    }
    result
}

trait SymbolName {
    fn symbol_fullname(&self) -> String;
    fn namespace(&self) -> Option<String>;
}

impl SymbolName for RuntimeSymbolDefinition {
    fn namespace(&self) -> Option<String> {
        self.import_path.as_ref().map(|p| {
            let mut hasher: DefaultHasher = DefaultHasher::new();
            p.hash(&mut hasher);
            number_to_abc(hasher.finish() as u32)
        })
    }

    fn symbol_fullname(&self) -> String {
        if let Some(namespace) = self.namespace() {
            format!("{}.{}", namespace, self.symbol_name)
        } else {
            self.symbol_name.clone()
        }
    }
}

#[derive(Debug, Clone)]
pub struct CodegenOptions {
    pub pwd: Option<PathBuf>,
    pub strict: bool,
    pub fmt: bool,
}

struct SchemaEnv<'a> {
    env: Environment<'a>,
}

struct OperationEnv<'a> {
    env: Environment<'a>,
}

struct FragmentEnv<'a> {
    env: Environment<'a>,
}

fn register_default_template_fns(
    env: &mut Environment<'_>,
    ctx: &SharedShalomGlobalContext,
) -> anyhow::Result<()> {
    use ext_jinja_fns::{
        get_generic_result_data_field, get_generic_result_error_field,
        get_generic_result_error_fragment_name, is_generic_result_type,
        is_schema_typename_generic_result, resolve_generic_result_error_fragment,
    };

    // Generic result helpers
    let ctx_clone_gr0 = ctx.clone();
    env.add_function(
        "is_schema_typename_generic_result",
        move |schema_typename: String| -> bool {
            is_schema_typename_generic_result(&schema_typename, &ctx_clone_gr0)
        },
    );

    let ctx_clone_gr1 = ctx.clone();
    env.add_function("is_generic_result_type", move |type_name: String| -> bool {
        is_generic_result_type(&type_name, &ctx_clone_gr1)
    });

    let ctx_clone_gr2 = ctx.clone();
    env.add_function(
        "resolve_generic_result_error_fragment",
        move |generic_result: String| -> String {
            resolve_generic_result_error_fragment(&generic_result, &ctx_clone_gr2)
        },
    );

    let ctx_clone_gr3 = ctx.clone();
    env.add_function(
        "get_generic_result_data_field",
        move |schema_typename: String| -> String {
            get_generic_result_data_field(&schema_typename, &ctx_clone_gr3)
        },
    );

    let ctx_clone_gr4 = ctx.clone();
    env.add_function(
        "get_generic_result_error_field",
        move |schema_typename: String| -> String {
            get_generic_result_error_field(&schema_typename, &ctx_clone_gr4)
        },
    );

    let ctx_clone_gr5 = ctx.clone();
    env.add_function(
        "get_generic_result_error_fragment_name",
        move |schema_typename: String| -> String {
            get_generic_result_error_fragment_name(&schema_typename, &ctx_clone_gr5)
        },
    );

    env.set_undefined_behavior(minijinja::UndefinedBehavior::Strict);
    env.set_debug(true);
    env.add_template(
        "operation",
        include_str!("../templates/operation.dart.jinja"),
    )
    .unwrap();

    env.add_template("schema", include_str!("../templates/schema.dart.jinja"))?;
    env.add_template("fragment", include_str!("../templates/fragment.dart.jinja"))?;
    env.add_template("macros", include_str!("../templates/macros.dart.jinja"))?;
    env.add_template(
        "selection_macros",
        include_str!("../templates/selection_macros.dart.jinja"),
    )?;
    env.add_function("panic", move |a: &str| -> minijinja::Value {
        panic!("{a}");
    });

    let ctx_clone = ctx.clone();
    env.add_function("type_name_for_selection", move |a: _| {
        ext_jinja_fns::type_name_for_selection(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("type_name_for_input_field", move |a: _| {
        ext_jinja_fns::type_name_for_input_field(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("type_name_for_one_of_input_field", move |a: _| {
        ext_jinja_fns::type_name_for_one_of_input_field(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("parse_field_default_value_deserializer", move |a: _| {
        ext_jinja_fns::parse_field_default_value_deserializer(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("get_fields_requiring_initializer_list", move |a: _| {
        minijinja::Value::from_serialize(ext_jinja_fns::get_fields_requiring_initializer_list(
            &ctx_clone, a,
        ))
    });

    let ctx_clone = ctx.clone();
    env.add_function("field_requires_initializer_list", move |a: _| {
        ext_jinja_fns::field_requires_initializer_list(&ctx_clone, a)
    });

    let schema_ctx_clone = ctx.schema_ctx.clone();
    env.add_function("resolve_field_type", move |a: _| {
        ext_jinja_fns::resolve_field_type(&schema_ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("custom_scalar_impl_fullname", move |a: _| {
        ext_jinja_fns::custom_scalar_impl_fullname(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("is_custom_scalar", move |name: &str| {
        ext_jinja_fns::is_custom_scalar(&ctx_clone, name)
    });

    env.add_function(
        "dart_type_for_scalar_name",
        ext_jinja_fns::dart_type_for_scalar_name,
    );

    env.add_function("docstring", ext_jinja_fns::docstring);
    let ctx_clone = ctx.clone();
    env.add_function(
        "is_type_implementing_interface",
        move |type_name: &str, interface_name: &str| {
            ext_jinja_fns::is_type_implementing_interface(&ctx_clone, type_name, interface_name)
        },
    );

    env.add_function(
        "get_field_name_with_args",
        |name: &str, args: ViaDeserialize<Vec<shalom_core::operation::types::FieldArgument>>| {
            get_field_name_with_args(name, &args.0)
        },
    );

    Ok(())
}

/// if the operation contains variables and the selection is from this operation
/// i.e not from a fragment returns true.
fn object_like_needs_variables<T: ExecutableContext>(ctx: &T, obj_like: &ObjectLikeCommon) -> bool {
    if !ctx.has_variables() {
        return false;
    }
    ctx.get_selection(&obj_like.path_name).is_some()
        || ctx.get_root().path_name == obj_like.path_name
}

fn get_field_name_with_args(
    field_name: &str,
    args: &[shalom_core::operation::types::FieldArgument],
) -> String {
    if args.is_empty() {
        field_name.to_string()
    } else {
        format!("{}_with_args", field_name)
    }
}

/// Helper function to generate custom scalar imports from the global context.
/// Returns a HashMap where the key is the import path and the value is a generated alias.
fn generate_custom_scalar_imports(ctx: &SharedShalomGlobalContext) -> HashMap<String, String> {
    let mut imports: HashMap<String, String> = HashMap::new();

    for custom_scalar in ctx.get_custom_scalars().values() {
        for symbol in [&custom_scalar.impl_symbol, &custom_scalar.output_type] {
            if let Some(import_path) = &symbol.import_path {
                let import_path_str = import_path.to_string_lossy().to_string();

                imports.entry(import_path_str).or_insert_with(|| {
                    let mut hasher: DefaultHasher = DefaultHasher::new();
                    import_path.hash(&mut hasher);
                    number_to_abc(hasher.finish() as u32)
                });
            }
        }
    }

    imports
}

impl SchemaEnv<'_> {
    fn new(ctx: &SharedShalomGlobalContext) -> anyhow::Result<Self> {
        let mut env = Environment::new();
        register_default_template_fns(&mut env, ctx)?;
        Ok(Self { env })
    }

    fn render_schema(&self, ctx: &SharedShalomGlobalContext) -> String {
        let template = self.env.get_template("schema").unwrap();

        let custom_scalar_imports = generate_custom_scalar_imports(ctx);

        let mut context = HashMap::new();
        context.insert("schema", context! { context => &ctx.schema_ctx });
        context.insert(
            "custom_scalar_imports",
            minijinja::Value::from(custom_scalar_imports),
        );

        template.render(&context).unwrap()
    }
}

/// Collects all multi-type (interface/union) list selections from all selection objects.
/// Returns a HashMap where the key is the full field name (e.g., "vehiclesRequired")
/// and the value is the list selection containing the multi-type.
fn collect_multi_type_list_selections<T>(executable_ctx: &T) -> Vec<SharedListSelection>
where
    T: ExecutableContext,
{
    let typedefs = executable_ctx.typedefs();
    let mut multitype_list_selections = Vec::new();

    for fullname in typedefs.unions.keys() {
        if let Some(selection) = typedefs.get_list_selection(fullname) {
            multitype_list_selections.push(selection.clone());
        }
    }
    for fullname in typedefs.interfaces.keys() {
        if let Some(selection) = typedefs.get_list_selection(fullname) {
            multitype_list_selections.push(selection.clone());
        }
    }

    multitype_list_selections
}

fn register_executable_fns<'a, T>(
    env: &mut Environment<'a>,
    ctx: &SharedShalomGlobalContext,
    executable_ctx: Arc<T>,
) -> anyhow::Result<()>
where
    T: ExecutableContext + 'static,
{
    let ctx_clone3 = ctx.clone();
    env.add_function(
        "get_all_selections_distinct",
        move |obj_like: ViaDeserialize<ObjectLikeCommon>| -> minijinja::Value {
            let selections = obj_like.0.get_all_selections_distinct(&ctx_clone3);
            minijinja::Value::from_serialize(&selections)
        },
    );

    let executable_ctx_clone3 = executable_ctx.clone();
    env.add_function(
        "object_like_needs_variables",
        move |selection: ViaDeserialize<ObjectLikeCommon>| -> bool {
            object_like_needs_variables(executable_ctx_clone3.as_ref(), &selection.0)
        },
    );

    let executable_ctx_clone = executable_ctx.clone();
    env.add_function(
        "generate_fragment_imports",
        move |current_file_path: String| {
            let mut res = Vec::new();
            for frag in executable_ctx_clone.typedefs().flatten_used_fragments() {
                res.push(
                    calculate_fragment_import_path(&current_file_path, &frag).unwrap_or_else(|_| panic!("Failed to calculate import path for fragment: {}; current file: {}",
                        frag.name(),
                        current_file_path)),
                );
            }
            minijinja::Value::from_serialize(res)
        },
    );

    let executable_ctx_clone2 = executable_ctx.clone();

    fn collect_selections_for_concrete(
        resolve_to: &mut ObjectLikeCommon,
        other_obj: &ObjectLikeCommon,
        global_ctx: &ShalomGlobalContext,
    ) {
        if resolve_to.schema_typename == other_obj.schema_typename
            || global_ctx.schema_ctx.is_type_implementing_interface(
                &resolve_to.schema_typename,
                &other_obj.schema_typename,
            )
        {
            // this object is a subset or same as the other we can safely flatten other's selections here.
            resolve_to.selections.extend(other_obj.selections.clone());

            for frag_name in &other_obj.used_fragments {
                let fragment = global_ctx.get_fragment_strict(frag_name);
                let frag_on_type = &fragment.get_on_type().schema_typename;

                if frag_on_type == &resolve_to.schema_typename {
                    // Fragment is exactly on this concrete type - add it to used_fragments
                    resolve_to.used_fragments.insert(frag_name.clone());
                } else if global_ctx
                    .schema_ctx
                    .is_type_implementing_interface(&resolve_to.schema_typename, frag_on_type)
                {
                    // Fragment is on an interface this type implements
                    // Recursively collect fragments from it but don't add to used_fragments
                    collect_selections_for_concrete(resolve_to, fragment.get_on_type(), global_ctx);
                }
            }

            for frag in other_obj.used_inline_frags.values() {
                // flatten inlinefrag selections directly on here
                collect_selections_for_concrete(resolve_to, &frag.common, global_ctx);
            }
        } else if !resolve_to.contains_field("__typename") {
            let typename_selection = other_obj
                .get_selection("__typename")
                .cloned()
                .unwrap_or_else(|| {
                    panic!(
                        "unions and interfaces MUST select __typename. {} didn't!",
                        other_obj.path_name
                    )
                });
            resolve_to.selections.insert(typename_selection);
        }

        // Also traverse type condition selections to find matching concrete types
        info!(
            "[collect_selections_for_concrete] Traversing {} type_cond_selections",
            other_obj.type_cond_selections.len()
        );
        for (type_cond_name, type_cond_obj) in &other_obj.type_cond_selections {
            info!(
                "  Processing type_cond: {} (schema: {})",
                type_cond_name, type_cond_obj.schema_typename
            );
            collect_selections_for_concrete(resolve_to, type_cond_obj, global_ctx);
        }
    }

    let ctx_clone2 = ctx.clone();

    env.add_function(
        "multitype_selection_resolved_concretes",
        move |fullname: &str| {
            let fullname = fullname.to_string();
            let multitype = executable_ctx_clone2
                .typedefs()
                .get_multitype_selection(&fullname)
                .unwrap_or_else(|| panic!("{fullname} not found"));

            let mut ret = Vec::new();
            for concrete_typename in &multitype.common().possible_concrete_types {
                let concrete_path = format!("{fullname}__{concrete_typename}");
                let mut resolved =
                    ObjectLikeCommon::new(concrete_path.clone(), concrete_typename.clone());
                collect_selections_for_concrete(
                    &mut resolved,
                    &multitype.common().common,
                    &ctx_clone2,
                );
                info!(
                    "[multitype_selection_resolved_concretes] Concrete type '{}' final used_fragments: {:?}",
                    concrete_typename, resolved.used_fragments
                );
                resolved.selections = resolved.get_all_selections_distinct(&ctx_clone2);
                info!(
                    "[multitype_selection_resolved_concretes] After expansion, '{}' has {} selections",
                    concrete_typename, resolved.selections.len()
                );
                ret.push(resolved);
            }
            minijinja::Value::from_serialize(ret)
        },
    );

    let executable_ctx_clone3 = executable_ctx.clone();

    env.add_function(
        "template_log",
        move |a: &minijinja::Value| -> minijinja::Value {
            let template_name = &executable_ctx_clone3.get_root().path_name;
            info!("in template for {template_name}: {a}");
            minijinja::Value::from(0)
        },
    );

    let ctx_clone3 = ctx.clone();
    env.add_function(
        "get_interface_level_fragments",
        move |selection_schema_typename: &str,
              used_fragments: ViaDeserialize<HashSet<String>>|
              -> minijinja::Value {
            // Filter fragments to only include those defined on the interface/union type itself
            // Not on concrete implementors
            let filtered: HashSet<String> = used_fragments
                .0
                .iter()
                .filter(|frag_name| {
                    let fragment = ctx_clone3.get_fragment_strict(frag_name);
                    let frag_on_type = &fragment.get_on_type().schema_typename;
                    // Only include if fragment is on the same type as the selection
                    frag_on_type == selection_schema_typename
                })
                .cloned()
                .collect();
            minijinja::Value::from_serialize(filtered)
        },
    );

    Ok(())
}

impl OperationEnv<'_> {
    fn new(ctx: &SharedShalomGlobalContext, op_ctx: SharedOpCtx) -> anyhow::Result<Self> {
        let mut env = Environment::new();
        register_default_template_fns(&mut env, ctx)?;
        register_executable_fns(&mut env, ctx, op_ctx.clone())?;

        // Add function to check if a selection is defined in a fragment (not in the operation itself)
        let op_ctx_clone2 = op_ctx.clone();
        env.add_function(
            "is_selection_from_fragment",
            move |path_name: &str| -> bool {
                let path_name = path_name.to_string();
                // Check if the selection exists in the operation's own typedefs
                // First check if it's in the operation's own selections
                if op_ctx_clone2.get_selection(&path_name).is_some() {
                    return false;
                }
                // If not found in operation but exists in get_selection (which searches fragments),
                // then it must be from a fragment
                for frag in op_ctx_clone2.typedefs.flatten_used_fragments() {
                    if frag.get_selection(&path_name).is_some() {
                        return true;
                    }
                }
                panic!(
                    "is_selection_from_fragment: failed to find selection {}",
                    path_name
                );
            },
        );
        Ok(OperationEnv { env })
    }

    fn render_operation(
        &self,
        operation_ctx: &OperationContext,
        custom_scalar_imports: HashMap<String, String>,
        schema_import_path: String,
        multi_type_list_selections: Vec<SharedListSelection>,
    ) -> String {
        let template = self.env.get_template("operation").unwrap();
        let mut resolved_query = operation_ctx.query.clone();
        for frag in operation_ctx.typedefs.flatten_used_fragments() {
            resolved_query.push_str(format!("\n {}", frag.fragment_raw).as_str());
        }
        let ctx = context! {
            context => context!{
                operation => operation_ctx,
                custom_scalar_imports => custom_scalar_imports,
                schema_import_path => schema_import_path,
                multi_type_list_selections => multi_type_list_selections,
                resolved_query => resolved_query
            }
        };
        template.render(&ctx).unwrap()
    }
}

impl FragmentEnv<'_> {
    fn new(
        ctx: &SharedShalomGlobalContext,
        fragment_ctx: SharedFragmentContext,
    ) -> anyhow::Result<Self> {
        let mut env = Environment::new();
        let ctx_clone = ctx.clone();
        register_default_template_fns(&mut env, &ctx_clone)?;
        let frag_ctx_clone = fragment_ctx.clone();
        register_executable_fns(&mut env, ctx, frag_ctx_clone)?;
        let frag_ctx_clone1 = fragment_ctx.clone();
        let ctx_clone1 = ctx.clone();

        env.add_function("frag_root_shared_selections", move || {
            let selections = frag_ctx_clone1
                .get_root()
                .get_all_selections_that_apply_on_this_type_only(&ctx_clone1);
            minijinja::value::Value::from_serialize(selections)
        });

        Ok(FragmentEnv { env })
    }

    fn render_fragment(
        &self,
        fragment_ctx: SharedFragmentContext,
        custom_scalar_imports: HashMap<String, String>,
        schema_path: String,
        multi_type_list_selections: Vec<SharedListSelection>,
    ) -> String {
        let template = self.env.get_template("fragment").unwrap();

        // Extract file_path as a string since it's skipped during serialization
        let fragment_file_path = fragment_ctx.file_path.to_string_lossy().to_string();

        let ctx = context! {
            context => context!{
                fragment => fragment_ctx,
                fragment_file_path => fragment_file_path,
                schema_import_path => schema_path,
                custom_scalar_imports => custom_scalar_imports,
                multi_type_list_selections => multi_type_list_selections,
            }
        };

        template.render(&ctx).unwrap()
    }
}

fn create_dir_if_not_exists(path: &Path) {
    if !path.exists() {
        fs::create_dir_all(path).unwrap();
    }
}

static END_OF_FILE: &str = "shalom.dart";
static GRAPHQL_DIRECTORY: &str = "__graphql__";

/// Get the directory where the schema file should be generated
fn get_schema_output_dir(ctx: &ShalomGlobalContext) -> PathBuf {
    if let Some(schema_output_path) = &ctx.config.schema_output_path {
        // Use the configured schema output path (resolve relative to project root)

        if schema_output_path.is_absolute() {
            schema_output_path.clone()
        } else {
            ctx.config.project_root.join(schema_output_path)
        }
    } else {
        // Default to schema file's parent directory + __graphql__
        ctx.schema_file_path
            .parent()
            .expect("Schema file must have a parent directory")
            .join(GRAPHQL_DIRECTORY)
    }
}

/// Get the full path to the generated schema file
fn get_schema_file_path(ctx: &ShalomGlobalContext) -> PathBuf {
    get_schema_output_dir(ctx).join(format!("schema.{}", END_OF_FILE))
}

fn get_generation_path_for_operation(document_path: &Path, operation_name: &str) -> PathBuf {
    let p = document_path.parent().unwrap().join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&p);
    p.join(format!("{}.{}", operation_name, END_OF_FILE))
}

/// Calculate the import path for a fragment from an operation file
fn calculate_fragment_import_path(
    operation_file_path: &str,
    fragment: &FragmentContext,
) -> anyhow::Result<String> {
    let op_path = PathBuf::from(operation_file_path);

    let frag_name = &fragment.name;

    // Get the directory containing operation file
    let op_dir = op_path
        .parent()
        .ok_or_else(|| anyhow::anyhow!("Invalid operation file path {}", operation_file_path))?;

    // Calculate the __graphql__ directory for the operation
    let op_graphql_dir = op_dir.join("__graphql__");

    // Calculate where the fragment will be generated
    let frag_parent_dir = fragment
        .file_path
        .parent()
        .ok_or_else(|| anyhow::anyhow!("Invalid fragment file path"))?;
    let frag_generated_path = frag_parent_dir
        .join("__graphql__")
        .join(format!("{}.shalom.dart", frag_name));

    log::debug!(
        "Fragment '{}': op_graphql_dir={:?}, frag_generated_path={:?}",
        frag_name,
        op_graphql_dir,
        frag_generated_path
    );

    // If in the same __graphql__ directory, use relative import
    if op_graphql_dir == frag_parent_dir.join("__graphql__") {
        log::debug!("Same directory, using simple relative import");
        return Ok(format!("{}.shalom.dart", frag_name));
    }

    // Same package, different directories - use relative path from operation __graphql__ dir
    let relative_from_op = pathdiff::diff_paths(&frag_generated_path, &op_graphql_dir)
        .ok_or_else(|| anyhow::anyhow!("Could not calculate relative path"))?;

    let import_path = relative_from_op.to_string_lossy().replace('\\', "/");
    log::debug!(
        "Different directories in same package, using relative import: {}",
        import_path
    );
    Ok(import_path)
}

fn get_schema_import_path(relative_to: &Path, ctx: &ShalomGlobalContext) -> String {
    // Calculate relative path from operation __graphql__ dir to schema file
    let op_dir = relative_to.parent().unwrap();
    let op_graphql_dir = op_dir.join("__graphql__");
    let schema_path = get_schema_file_path(ctx);
    let schema_import_path = pathdiff::diff_paths(&schema_path, &op_graphql_dir)
        .map(|p| p.to_string_lossy().replace('\\', "/"))
        .unwrap_or_else(|| "schema.shalom.dart".to_string());
    schema_import_path
}

fn generate_operations_file(
    ctx: &SharedShalomGlobalContext,
    name: &str,
    operation: SharedOpCtx,
    custom_scalar_imports: HashMap<String, String>,
) -> anyhow::Result<()> {
    let op_env = OperationEnv::new(ctx, operation.clone())?;

    let operation_file_path = operation.file_path.clone();
    let generation_target = get_generation_path_for_operation(&operation_file_path, name);

    // Calculate relative path from operation __graphql__ dir to schema file

    // Collect multi-type list selections
    let multi_type_list_selections = collect_multi_type_list_selections(operation.as_ref());

    let rendered_content = op_env.render_operation(
        &operation,
        custom_scalar_imports,
        get_schema_import_path(&operation_file_path, ctx),
        multi_type_list_selections,
    );
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());

    Ok(())
}

fn generate_fragment_file(
    ctx: &SharedShalomGlobalContext,
    _pwd: &Path,
    fragment_name: &str,
    fragment_ctx: SharedFragmentContext,
    custom_scalar_imports: HashMap<String, String>,
) -> anyhow::Result<()> {
    let fragment_env = FragmentEnv::new(ctx, fragment_ctx.clone())?;

    // Collect multi-type list selections
    let multi_type_list_selections = collect_multi_type_list_selections(fragment_ctx.as_ref());

    let generated_content = fragment_env.render_fragment(
        fragment_ctx.clone(),
        custom_scalar_imports,
        get_schema_import_path(&fragment_ctx.file_path, ctx),
        multi_type_list_selections,
    );

    // Generate fragment in __graphql__ subdirectory relative to where it's defined
    let fragment_source_dir = fragment_ctx.file_path.parent().ok_or_else(|| {
        anyhow::anyhow!("Invalid fragment file path: {:?}", fragment_ctx.file_path)
    })?;
    let generation_dir = fragment_source_dir.join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&generation_dir);
    let generation_path = generation_dir.join(format!("{}.{}", fragment_name, END_OF_FILE));

    fs::write(&generation_path, generated_content)?;
    info!("Generated fragment file: {}", generation_path.display());
    Ok(())
}

pub fn codegen_entry_point(options: CodegenOptions) -> Result<()> {
    let ctx = shalom_core::entrypoint::parse_directory(&options.pwd, options.strict)?;
    let pwd = &ctx.config.project_root;
    info!("codegen started in working directory {}", pwd.display());

    let template_env = SchemaEnv::new(&ctx)?;

    // Clean up unused operation files
    let existing_op_names =
        glob::glob(pwd.join(format!("**/*.{}", END_OF_FILE)).to_str().unwrap())?;
    for entry in existing_op_names {
        let entry = entry?;
        if entry.is_file() {
            let resolved_name = entry
                .file_name()
                .unwrap()
                .to_str()
                .unwrap()
                .split(format!(".{}", END_OF_FILE).as_str())
                .next()
                .unwrap();
            // Check if it's neither an operation nor a fragment
            if !ctx.operation_exists(resolved_name) && !ctx.fragment_exists(resolved_name) {
                info!("deleting unused file {}", resolved_name);
                fs::remove_file(entry)?;
            }
        }
    }

    generate_schema_file(&template_env, &ctx);
    let custom_scalar_imports = generate_custom_scalar_imports(&ctx);

    // Generate fragment files first (operations might depend on them)
    for (fragment_name, fragment_ctx) in ctx.fragments() {
        let res = generate_fragment_file(
            &ctx,
            pwd,
            &fragment_name,
            fragment_ctx,
            custom_scalar_imports.clone(),
        );
        if let Err(err) = res {
            if options.strict {
                return Err(err);
            }
            error!(
                "Failed to generate fragment '{}' due to: {}",
                fragment_name, err
            );
        }
    }

    // Generate operation files
    for (name, operation) in ctx.operations() {
        let res = generate_operations_file(&ctx, &name, operation, custom_scalar_imports.clone());
        if let Err(err) = res {
            if options.strict {
                return Err(err);
            }
            error!("Failed to generate operation '{}' due to: {}", name, err);
        }
    }

    if options.fmt {
        info!("Formatting generated Dart files...");
        format_generated_files(pwd)?;
    }
    Ok(())
}

fn generate_schema_file(template_env: &SchemaEnv, ctx: &SharedShalomGlobalContext) {
    info!("rendering schema file");

    let rendered_content = template_env.render_schema(ctx);
    let output_dir = get_schema_output_dir(ctx);
    create_dir_if_not_exists(&output_dir);
    let generation_target = output_dir.join(format!("schema.{}", END_OF_FILE));
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
}

pub fn get_dart_command() -> Result<String, String> {
    let dart;
    #[cfg(target_os = "windows")]
    {
        dart = "dart.bat";
    }
    #[cfg(not(target_os = "windows"))]
    {
        dart = "dart";
    }

    // Check if dart is available
    if std::process::Command::new(dart)
        .arg("--version")
        .output()
        .map(|output| output.status.success())
        .unwrap_or(false)
    {
        return Ok(dart.to_string());
    }

    // Check if fvm dart is available
    if std::process::Command::new("fvm")
        .arg("dart")
        .arg("--version")
        .output()
        .map(|output| output.status.success())
        .unwrap_or(false)
    {
        return Ok("fvm dart".to_string());
    }

    Err("Dart SDK not found. Please install Dart SDK or FVM.".to_string())
}

fn format_generated_files(pwd: &Path) -> Result<()> {
    let dart_cmd = get_dart_command().map_err(|e| anyhow::anyhow!(e))?;

    // Split the dart command in case it's "fvm dart"
    let dart_parts: Vec<&str> = dart_cmd.split_whitespace().collect();
    let dart_cmd = dart_parts[0];
    let mut dart_args = dart_parts[1..].to_vec();
    dart_args.push("format");

    // Find all shalom.dart files using glob
    let pattern = pwd.join("**/*.shalom.dart");
    let pattern_str = pattern
        .to_str()
        .ok_or_else(|| anyhow::anyhow!("Invalid path pattern"))?;

    for entry in glob::glob(pattern_str)? {
        match entry {
            Ok(path) => {
                let mut cmd = Command::new(dart_cmd);

                // Add any additional args (like "fvm" if using fvm dart)
                for arg in &dart_args {
                    cmd.arg(arg);
                }

                // Add the file to format
                cmd.arg(&path).current_dir(pwd);

                let output = cmd.output()?;
                if !output.status.success() {
                    error!(
                        "Failed to format file {}: {}",
                        path.display(),
                        String::from_utf8_lossy(&output.stderr)
                    );
                }
            }
            Err(e) => {
                error!("Glob error: {}", e);
            }
        }
    }

    Ok(())
}
