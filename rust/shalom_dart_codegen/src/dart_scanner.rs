use std::path::PathBuf;

use anyhow::Result;
use regex::Regex;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum WidgetKind {
    Query,
    Fragment,
    Mutation,
    Subscription,
}

/// A widget annotation found in a Dart file.
#[derive(Debug, Clone)]
pub struct WidgetAnnotation {
    pub class_name: String,
    pub sdl: String,
    pub widget_kind: WidgetKind,
    pub source_path: PathBuf,
}

pub fn scan_dart_widgets(root: &PathBuf, gen_dir: &str) -> Result<Vec<WidgetAnnotation>> {
    let mut results = Vec::new();

    for entry in glob::glob(root.join("**/*.dart").to_str().unwrap())? {
        let entry = entry?;
        if entry.to_string_lossy().contains(gen_dir) {
            continue;
        }
        let content = match std::fs::read_to_string(&entry) {
            Ok(c) => c,
            Err(_) => continue,
        };

        for widget in parse_widgets_from_content(&content, &entry) {
            results.push(widget);
        }
    }

    Ok(results)
}

fn parse_widgets_from_content(content: &str, source_path: &PathBuf) -> Vec<WidgetAnnotation> {
    let mut results = Vec::new();

    for (kind, tag) in [
        (WidgetKind::Query, r"@Query"),
        (WidgetKind::Fragment, r"@Fragment"),
        (WidgetKind::Mutation, r"@Mutation"),
        (WidgetKind::Subscription, r"@Subscription"),
    ] {
        let re = Regex::new(&format!(
            r#"(?ms){}\s*\(\s*r?("""|''')\s*(.*?)\s*(?:"""|''')\s*\)\s*\n\s*class\s+(\w+)"#,
            tag
        ))
        .unwrap();

        for cap in re.captures_iter(content) {
            let sdl = cap.get(2).map(|m| m.as_str()).unwrap_or("").to_string();
            let class_name = cap.get(3).map(|m| m.as_str()).unwrap_or("").to_string();
            if class_name.is_empty() || sdl.is_empty() {
                continue;
            }
            results.push(WidgetAnnotation {
                widget_kind: kind,
                sdl,
                class_name,
                source_path: source_path.clone(),
            });
        }
    }

    results
}
