use std::{
    fs,
    path::{Path, PathBuf},
    sync::LazyLock,
};

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

static WIDGET_REGEXES: LazyLock<[(WidgetKind, Regex); 4]> = LazyLock::new(|| {
    [
        (WidgetKind::Query, widget_regex("@Query")),
        (WidgetKind::Fragment, widget_regex("@Fragment")),
        (WidgetKind::Mutation, widget_regex("@Mutation")),
        (WidgetKind::Subscription, widget_regex("@Subscription")),
    ]
});

fn widget_regex(tag: &str) -> Regex {
    Regex::new(&format!(
        r#"(?ms){}\s*\(\s*r?("""|''')\s*(.*?)\s*(?:"""|''')\s*\)\s*\n\s*class\s+(\w+)"#,
        tag
    ))
    .unwrap()
}

pub fn scan_dart_widgets(root: &Path, gen_dir: &str) -> Result<Vec<WidgetAnnotation>> {
    let mut results = Vec::new();
    scan_dart_widgets_in_dir(root, gen_dir, &mut results)?;
    Ok(results)
}

fn scan_dart_widgets_in_dir(
    dir: &Path,
    gen_dir: &str,
    results: &mut Vec<WidgetAnnotation>,
) -> Result<()> {
    let entries = match fs::read_dir(dir) {
        Ok(entries) => entries,
        Err(_) => return Ok(()),
    };

    for entry in entries {
        let entry = entry?;
        let path = entry.path();
        let file_type = match entry.file_type() {
            Ok(file_type) => file_type,
            Err(_) => continue,
        };

        if file_type.is_dir() {
            if should_skip_dir(&path, gen_dir) {
                continue;
            }
            scan_dart_widgets_in_dir(&path, gen_dir, results)?;
            continue;
        }

        if !file_type.is_file() || path.extension().and_then(|ext| ext.to_str()) != Some("dart") {
            continue;
        }

        let content = match fs::read_to_string(&path) {
            Ok(content) => content,
            Err(_) => continue,
        };
        if !might_contain_widget_annotation(&content) {
            continue;
        }

        results.extend(parse_widgets_from_content(&content, &path));
    }

    Ok(())
}

fn should_skip_dir(path: &Path, gen_dir: &str) -> bool {
    let Some(name) = path.file_name().and_then(|name| name.to_str()) else {
        return false;
    };

    name == gen_dir || name == "__graphql__" || name == ".dart_tool" || name == "build"
}

fn might_contain_widget_annotation(content: &str) -> bool {
    content.contains("@Query")
        || content.contains("@Fragment")
        || content.contains("@Mutation")
        || content.contains("@Subscription")
}

fn parse_widgets_from_content(content: &str, source_path: &Path) -> Vec<WidgetAnnotation> {
    let mut results = Vec::new();

    for (kind, re) in WIDGET_REGEXES.iter() {
        for cap in re.captures_iter(content) {
            let sdl = cap.get(2).map(|m| m.as_str()).unwrap_or("").to_string();
            let class_name = cap.get(3).map(|m| m.as_str()).unwrap_or("").to_string();
            if class_name.is_empty() || sdl.is_empty() {
                continue;
            }
            results.push(WidgetAnnotation {
                widget_kind: *kind,
                sdl,
                class_name,
                source_path: source_path.to_path_buf(),
            });
        }
    }

    results
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::{SystemTime, UNIX_EPOCH};

    #[test]
    fn scan_dart_widgets_skips_generated_and_cache_dirs() {
        let root = std::env::temp_dir().join(format!(
            "shalom_dart_scanner_{}_{}",
            std::process::id(),
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_nanos()
        ));
        fs::create_dir_all(root.join("lib/__graphql__")).unwrap();
        fs::create_dir_all(root.join(".dart_tool")).unwrap();

        let source_path = root.join("lib/widget.dart");
        fs::write(
            &source_path,
            r#"
@Subscription(r"""
subscription WidgetSub { ping }
""")
class WidgetSub {}
"#,
        )
        .unwrap();
        fs::write(
            root.join("lib/__graphql__/Generated.shalom.dart"),
            r#"
@Query(r"""
query Generated { ping }
""")
class Generated {}
"#,
        )
        .unwrap();
        fs::write(
            root.join("lib/__graphql__/Generated.shalom.dart"),
            r#"
@Query(r"""
query Generated { ping }
""")
class Generated {}
"#,
        )
        .unwrap();
        fs::write(
            root.join(".dart_tool/cached.dart"),
            r#"
@Query(r"""
query Cached { ping }
""")
class Cached {}
"#,
        )
        .unwrap();

        let widgets = scan_dart_widgets(&root, "__graphql__").unwrap();

        assert_eq!(widgets.len(), 1);
        assert_eq!(widgets[0].class_name, "WidgetSub");
        assert_eq!(widgets[0].widget_kind, WidgetKind::Subscription);
        assert_eq!(widgets[0].source_path, source_path);

        fs::remove_dir_all(root).unwrap();
    }
}
