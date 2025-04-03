use std::{
    collections::HashMap,
    fs,
    path::{Path, PathBuf},
};

use anyhow::Result;
use lazy_static::lazy_static;
use log::{debug, info, trace};
use minijinja::{context, value::ViaDeserialize, Environment};
use serde::Serialize;
use shalom_core::operation::types::Selection;

struct TemplateEnv<'a> {
    env: Environment<'a>,
}

lazy_static! {
    static ref DEFAULT_SCALARS_MAP: HashMap<String, String> = HashMap::from([
        ("ID".to_string(), "String".to_string()),
        ("String".to_string(), "String".to_string()),
        ("Int".to_string(), "int".to_string()),
        ("Float".to_string(), "double".to_string()),
        ("Boolean".to_string(), "bool".to_string()),
    ]);
}

fn type_name_for_selection(selection: ViaDeserialize<Selection>) -> String {
    match selection.0 {
        Selection::Scalar(scalar) => {
            let resolved = DEFAULT_SCALARS_MAP.get(&scalar.concrete_type.name).unwrap();
            if scalar.common.is_optional {
                format!("{}?", resolved)
            } else {
                resolved.to_string()
            }
        }
        _ => todo!("unsupported type: {:?}", selection.0),
    }
}
impl TemplateEnv<'_> {
    fn new() -> Self {
        let mut env = Environment::new();
        env.add_template(
            "operation",
            include_str!("../templates/operation.dart.jinja"),
        )
        .unwrap();
        env.add_function("type_name_for_selection", type_name_for_selection);
        Self { env }
    }

    fn render_operation<S: Serialize>(&self, ctx: S) -> String {
        let template = self.env.get_template("operation").unwrap();
        trace!("resolved operation template; rendering...");
        template.render(context! {context=>ctx}).unwrap()
    }
}

lazy_static! {
    static ref TEMPLATE_ENV: TemplateEnv<'static> = TemplateEnv::new();
}
fn create_dir_if_not_exists(path: &Path) {
    if !path.exists() {
        std::fs::create_dir_all(path).unwrap();
    }
}

fn get_generation_path_for_operation(document_path: &Path, operation_name: &str) -> PathBuf {
    let p = document_path.parent().unwrap().join("__graphql__");
    create_dir_if_not_exists(&p);
    p.join(format!("{}.dart", operation_name))
}

pub fn codegen_entry_point(pwd: &Path) -> Result<()> {
    info!("codegen started in working directory {}", pwd.display());
    let ctx = shalom_core::entrypoint::parse_directory(pwd)?;
    for (name, operation) in ctx.operations() {
        info!("rendering operation {}", name);
        let content = TEMPLATE_ENV.render_operation(&operation);
        let generation_target = get_generation_path_for_operation(&operation.file_path, &name);
        fs::write(&generation_target, content).unwrap();
        info!("Generated {}", generation_target.display());
    }
    Ok(())
}
