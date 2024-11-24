use std::collections::HashMap;
use minijinja::{Environment, context};
use super::{
    context::SharedSchemaContext,
    types::{FieldDefinition, FieldType, ScalarType},
};

const CLASS_TEMPLATE: &str = r#"class {{ class_name }} {
  const {{ class_name }}({
    {%- for field in fields %}
    this.{{ field.name }},
    {%- endfor %}
  });

  {%- for field in fields %}
  final {{ field.type }} {{ field.name }};
  {%- endfor %}

  factory {{ class_name }}.fromJson(Map<String, dynamic> json) {
    return {{ class_name }}(
      {%- for field in fields %}
      {{ field.name }}: {{ field.deserializer }},
      {%- endfor %}
    );
  }
}"#;

pub struct DartGenerator {
    ctx: SharedSchemaContext,
    env: Environment<'static>,
}

impl DartGenerator {
    pub fn new(ctx: SharedSchemaContext) -> Self {
        let mut env = Environment::new();
        env.add_template("class", CLASS_TEMPLATE).unwrap();
        DartGenerator { ctx, env }
    }

    pub fn generate_query_class(&self, query_name: &str, fields: &[FieldDefinition]) -> String {
        let fields: Vec<HashMap<&str, String>> = fields.iter().map(|field| {
            let field_type = self.resolve_field_type(&field.ty);
            let deserializer = self.generate_field_deserializer(&field.ty, &format!("json['{}']", field.name));
            HashMap::from([
                ("name", field.name.clone()),
                ("type", field_type),
                ("deserializer", deserializer),
            ])
        }).collect();

        let tmpl = self.env.get_template("class").unwrap();
        let ctx = context! {
            class_name => query_name,
            fields => fields,
        };
        tmpl.render(ctx).unwrap()
    }

    fn resolve_field_type(&self, field_type: &FieldType) -> String {
        match field_type {
            FieldType::Named(type_ref) => {
                if let Some(scalar) = type_ref.get_scalar() {
                    self.scalar_to_dart_type(&scalar)
                } else if let Some(object) = type_ref.get_object() {
                    object.name.clone()
                } else {
                    "dynamic".to_string()
                }
            }
            FieldType::NonNullNamed(type_ref) => {
                if let Some(scalar) = type_ref.get_scalar() {
                    self.scalar_to_dart_type(&scalar)
                } else if let Some(object) = type_ref.get_object() {
                    object.name.clone()
                } else {
                    "dynamic".to_string()
                }
            }
            FieldType::List(inner) => format!("List<{}>", self.resolve_field_type(inner)),
            FieldType::NonNullList(inner) => format!("List<{}>", self.resolve_field_type(inner)),
        }
    }

    fn scalar_to_dart_type(&self, scalar: &ScalarType) -> String {
        match scalar.name.as_str() {
            "String" => "String?".to_string(),
            "Int" => "int".to_string(),
            "Float" => "double".to_string(),
            "Boolean" => "bool".to_string(),
            "ID" => "String".to_string(),
            "DateTime" => "DateTime".to_string(),
            _ => "dynamic".to_string(),
        }
    }

    fn generate_field_deserializer(&self, field_type: &FieldType, json_expr: &str) -> String {
        match field_type {
            FieldType::Named(type_ref) | FieldType::NonNullNamed(type_ref) => {
                if let Some(scalar) = type_ref.get_scalar() {
                    match scalar.name.as_str() {
                        "String" => format!("{} as String?", json_expr),
                        "Int" => format!("{} as int", json_expr),
                        "Float" => format!("{} as double", json_expr),
                        "Boolean" => format!("{} as bool", json_expr),
                        "ID" => format!("{} as String", json_expr),
                        "DateTime" => format!("DateTime.parse({} as String)", json_expr),
                        _ => format!("{}", json_expr),
                    }
                } else if let Some(object) = type_ref.get_object() {
                    format!("{}.fromJson({} as Map<String, dynamic>)", object.name, json_expr)
                } else {
                    json_expr.to_string()
                }
            }
            FieldType::List(inner) | FieldType::NonNullList(inner) => {
                let inner_deserializer = self.generate_field_deserializer(inner, "e");
                format!("({} as List).map((e) => {}).toList()", json_expr, inner_deserializer)
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::schema::resolver::resolve;

    #[test]
    fn test_generate_person_query() {
        let schema = r#"
            type Person {
                name: String
                age: Int!
                dateOfBirth: DateTime!
            }
            type Query {
                person(id: Int!): Person
            }
        "#.to_string();

        let ctx = resolve(&schema).unwrap();
        let generator = DartGenerator::new(ctx.clone());
        
        let query_object = ctx.borrow().get_type("Person").unwrap().object().unwrap();
        let fields: Vec<_> = query_object.fields.iter().cloned().collect();
        
        let dart_code = generator.generate_query_class("Person", &fields);
        
        assert!(dart_code.contains("class Person"));
        assert!(dart_code.contains("final String? name"));
        assert!(dart_code.contains("final int age"));
        assert!(dart_code.contains("final DateTime dateOfBirth"));
        assert!(dart_code.contains("factory Person.fromJson"));
    }
}