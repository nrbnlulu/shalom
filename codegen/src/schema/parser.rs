use super::context::SchemaContext;
use apollo_compiler::{self, Node};
use anyhow::Result;


pub fn parse(schema: &String) -> Result<SchemaContext>{
    let ctx = SchemaContext::new();
    let schema =  match (apollo_compiler::Schema::parse(schema, "schema.graphql")) {
        Ok(schema) => schema,
        Err(e) => return Err(anyhow::anyhow!("Error parsing schema: {}", e))
    };
    for type_ in schema.types{
        
    }
}

fn object_def_from_origin(origin: apollo_compiler::Node<ObjectType>) -> Node<>

mod tests {
    use super::*;

    #[test]
    fn test_parse(){
        let schema = r#"
            type Query{
                hello: String
            }
        "#;
        let ctx = parse(&schema.to_string()).unwrap();
        assert_eq!(ctx.get_type("Query").is_some(), true);
    }
}