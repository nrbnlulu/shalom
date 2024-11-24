pub mod schema;

use anyhow::Result;

fn main() -> Result<()> {
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

    let ctx = schema::resolver::resolve(&schema)?;
    let generator = schema::DartGenerator::new(ctx.clone());
    
    let person_object = ctx.borrow().get_type("Person").unwrap().object().unwrap();
    let fields: Vec<schema::types::FieldDefinition> = person_object.fields.iter().cloned().collect();
    
    let dart_code = generator.generate_query_class("Person", &fields);
    println!("Generated Dart code:\n{}", dart_code);

    Ok(())
}
