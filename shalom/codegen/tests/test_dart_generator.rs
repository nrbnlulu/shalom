use shalom_codegen::schema::{resolver::resolve, DartGenerator};

#[test]
fn test_generate_hello_world_query() {
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
    
    let person_object = ctx.borrow().get_type("Person").unwrap().object().unwrap();
    let fields: Vec<_> = person_object.fields.iter().collect();
    
    let dart_code = generator.generate_query_class("Person", &fields);
    
    // Verify the generated code has all required elements
    assert!(dart_code.contains("class Person {"));
    assert!(dart_code.contains("final String? name;"));
    assert!(dart_code.contains("final int age;"));
    assert!(dart_code.contains("final DateTime dateOfBirth;"));
    assert!(dart_code.contains("factory Person.fromJson(Map<String, dynamic> json)"));
    assert!(dart_code.contains("name: json['name'] as String?,"));
    assert!(dart_code.contains("age: json['age'] as int,"));
    assert!(dart_code.contains("dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),"));
}