use std::path::PathBuf;

use serde_json::{Map, Value, json};
use tokio::runtime::Builder;
use tokio_stream::StreamExt;

use shalom_core::context::ShalomGlobalContext;
use shalom_core::entrypoint::{parse_document, parse_schema, register_fragments_from_document};
use shalom_core::operation::context::SharedOpCtx;
use shalom_core::shalom_config::ShalomConfig;
use shalom_runtime::cache::{CacheRecord, CacheValue};
use shalom_runtime::normalization::NormalizationResult;
use shalom_runtime::{RefObject, ShalomRuntime, SubscriptionId};

fn build_ctx(schema: &str, operation: &str) -> (ShalomRuntime, SharedOpCtx) {
    let schema_ctx = parse_schema(schema).expect("schema parse failed");
    let config = ShalomConfig::default();
    let global_ctx = ShalomGlobalContext::new(schema_ctx, config, PathBuf::from("schema.graphql"));
    register_fragments_from_document(&global_ctx, operation, &PathBuf::from("ops.graphql"))
        .expect("register fragments");
    let ops = parse_document(&global_ctx, operation, &PathBuf::from("ops.graphql"))
        .expect("operation parse failed");
    let op_ctx = ops.values().next().expect("missing op").clone();
    let runtime = ShalomRuntime::new(global_ctx);
    (runtime, op_ctx)
}

fn normalize(
    runtime: &ShalomRuntime,
    op_ctx: &SharedOpCtx,
    data: Value,
    variables: Option<Map<String, Value>>,
) -> NormalizationResult {
    runtime
        .normalize(op_ctx, data, variables.as_ref())
        .expect("normalize")
}

fn subscribe(runtime: &ShalomRuntime, op_ctx: &SharedOpCtx, data: &Value) -> SubscriptionId {
    let refs = RefObject::from_response(data)
        .refs
        .into_iter()
        .collect::<Vec<_>>();
    runtime
        .subscribe(op_ctx.get_operation_name(), None, refs)
        .expect("subscribe")
}

fn single_update(runtime: &ShalomRuntime, id: SubscriptionId) -> Value {
    let mut stream = runtime
        .subscription_stream(id)
        .expect("subscription stream");
    let tokio_rt = Builder::new_current_thread()
        .enable_all()
        .build()
        .expect("tokio runtime");
    let response = tokio_rt
        .block_on(async { stream.next().await })
        .expect("missing update")
        .expect("subscription error");
    runtime.unsubscribe(id);
    response.data
}

fn record(runtime: &ShalomRuntime, key: &str) -> CacheRecord {
    runtime
        .cache()
        .lock()
        .expect("normalized cache lock poisoned")
        .get(key)
        .cloned()
        .unwrap_or_else(|| panic!("record {key} missing"))
}

fn has_record(runtime: &ShalomRuntime, key: &str) -> bool {
    runtime
        .cache()
        .lock()
        .expect("normalized cache lock poisoned")
        .get(key)
        .is_some()
}

fn root_record(runtime: &ShalomRuntime) -> CacheRecord {
    record(runtime, "ROOT_QUERY")
}

fn expect_ref(value: &CacheValue, expected: &str) {
    match value {
        CacheValue::Ref(key) => assert_eq!(key, expected),
        other => panic!("expected ref {expected}, got {other:?}"),
    }
}

fn expect_object(value: &CacheValue) -> &CacheRecord {
    match value {
        CacheValue::Object(record) => record,
        other => panic!("expected object, got {other:?}"),
    }
}

fn expect_list(value: &CacheValue) -> &Vec<CacheValue> {
    match value {
        CacheValue::List(list) => list,
        other => panic!("expected list, got {other:?}"),
    }
}

fn expect_scalar(record: &CacheRecord, key: &str, expected: Value) {
    let value = record.get(key).expect("missing field");
    match value {
        CacheValue::Scalar(actual) => assert_eq!(actual, &expected),
        other => panic!("expected scalar {expected:?}, got {other:?}"),
    }
}

fn vars(pairs: &[(&str, Value)]) -> Map<String, Value> {
    let mut map = Map::new();
    for (key, value) in pairs {
        map.insert((*key).to_string(), value.clone());
    }
    map
}

fn normalize_input_case(schema: &str, operation: &str, variables: Map<String, Value>, key: &str) {
    let (global_ctx, op_ctx) = build_ctx(schema, operation);
    normalize(
        &global_ctx,
        &op_ctx,
        json!({ "result": { "id": "r1" } }),
        Some(variables),
    );
    assert!(root_record(&global_ctx).contains_key(key));
}

mod scalars {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { value: Int }
        "#;
        let operation = r#"
            query TestOp { value }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(&global_ctx, &op_ctx, json!({ "value": 5 }), None);

        let root = root_record(&global_ctx);
        expect_scalar(&root, "value", json!(5));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { value: String }
        "#;
        let operation = r#"
            query TestOp { value }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(&global_ctx, &op_ctx, json!({ "value": "hello" }), None);

        let root = root_record(&global_ctx);
        expect_scalar(&root, "value", json!("hello"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { value: Int }
        "#;
        let operation = r#"
            query TestOp { value }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(&global_ctx, &op_ctx, json!({ "value": 1 }), None);
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(&global_ctx, &op_ctx, json!({ "value": 2 }), None);

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(data.get("value"), Some(&json!(2)));
    }
}

mod custom_scalars {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            scalar Point
            type Query { point: Point }
        "#;
        let operation = r#"
            query TestOp { point }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "point": "POINT (1,2)" }),
            None,
        );

        let root = root_record(&global_ctx);
        expect_scalar(&root, "point", json!("POINT (1,2)"));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            scalar Point
            type Query { point: Point }
        "#;
        let operation = r#"
            query TestOp { point }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "point": "POINT (9,9)" }),
            None,
        );

        let root = root_record(&global_ctx);
        expect_scalar(&root, "point", json!("POINT (9,9)"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            scalar Point
            type Query { point: Point }
        "#;
        let operation = r#"
            query TestOp { point }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "point": "POINT (1,1)" }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "point": "POINT (2,2)" }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(data.get("point"), Some(&json!("POINT (2,2)")));
    }
}

mod enums {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { status: Status }
        "#;
        let operation = r#"
            query TestOp { status }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(&global_ctx, &op_ctx, json!({ "status": "OPEN" }), None);

        let root = root_record(&global_ctx);
        expect_scalar(&root, "status", json!("OPEN"));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { status: Status }
        "#;
        let operation = r#"
            query TestOp { status }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(&global_ctx, &op_ctx, json!({ "status": "CLOSED" }), None);

        let root = root_record(&global_ctx);
        expect_scalar(&root, "status", json!("CLOSED"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { status: Status }
        "#;
        let operation = r#"
            query TestOp { status }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(&global_ctx, &op_ctx, json!({ "status": "OPEN" }), None);
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(&global_ctx, &op_ctx, json!({ "status": "CLOSED" }), None);

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(data.get("status"), Some(&json!("CLOSED")));
    }
}

mod object_selection {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { user: User }
            type User { id: ID!, name: String!, age: Int }
        "#;
        let operation = r#"
            query TestOp { user { id name age } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "name": "Ada", "age": 30 } }),
            None,
        );

        let root = root_record(&global_ctx);
        expect_ref(root.get("user").expect("user missing"), "User:u1");
        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "name", json!("Ada"));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { user: User }
            type User { id: ID!, name: String!, age: Int }
        "#;
        let operation = r#"
            query TestOp { user { id name age } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "name": "Ada", "age": 30 } }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "age", json!(30));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { user: User }
            type User { id: ID!, name: String!, age: Int }
        "#;
        let operation = r#"
            query TestOp { user { id name age } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "name": "Ada", "age": 30 } }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "name": "Grace", "age": 30 } }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let user = data
            .get("user")
            .and_then(|value| value.as_object())
            .expect("user missing");
        assert_eq!(user.get("name"), Some(&json!("Grace")));
    }
}

mod nested_objects {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { user: User }
            type User { id: ID!, profile: Profile }
            type Profile { age: Int!, bio: String }
        "#;
        let operation = r#"
            query TestOp { user { id profile { age bio } } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "profile": { "age": 32, "bio": "Rustacean" } } }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        let profile = expect_object(user.get("profile").expect("profile missing"));
        expect_scalar(profile, "age", json!(32));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { user: User }
            type User { id: ID!, profile: Profile }
            type Profile { age: Int!, bio: String }
        "#;
        let operation = r#"
            query TestOp { user { id profile { age bio } } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "profile": { "age": 32, "bio": "Rustacean" } } }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        let profile = expect_object(user.get("profile").expect("profile missing"));
        expect_scalar(profile, "bio", json!("Rustacean"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { user: User }
            type User { id: ID!, profile: Profile }
            type Profile { age: Int!, bio: String }
        "#;
        let operation = r#"
            query TestOp { user { id profile { age bio } } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "profile": { "age": 32, "bio": "Rustacean" } } }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "user": { "id": "u1", "profile": { "age": 33, "bio": "Rustacean" } } }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let user = data
            .get("user")
            .and_then(|value| value.as_object())
            .expect("user missing");
        let profile = user
            .get("profile")
            .and_then(|value| value.as_object())
            .expect("profile missing");
        assert_eq!(profile.get("age"), Some(&json!(33)));
    }
}

mod unions {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { search: SearchResult }
            union SearchResult = User | Admin
            type User { id: ID!, name: String! }
            type Admin { id: ID!, level: Int! }
        "#;
        let operation = r#"
            query TestOp {
                search {
                    __typename
                    ... on User { id name }
                    ... on Admin { id level }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let result = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "search": { "__typename": "User", "id": "u1", "name": "Ada" } }),
            None,
        );

        let root = root_record(&global_ctx);
        expect_ref(root.get("search").expect("search missing"), "User:u1");
        let search = result
            .data
            .get("search")
            .and_then(|v| v.as_object())
            .expect("search missing");
        let ref_meta = search.get("__ref").and_then(|v| v.as_object()).unwrap();
        assert_eq!(ref_meta.get("path"), Some(&json!("ROOT_QUERY_search")));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { search: SearchResult }
            union SearchResult = User | Admin
            type User { id: ID!, name: String! }
            type Admin { id: ID!, level: Int! }
        "#;
        let operation = r#"
            query TestOp {
                search {
                    __typename
                    ... on User { id name }
                    ... on Admin { id level }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "search": { "__typename": "Admin", "id": "a1", "level": 5 } }),
            None,
        );

        let admin = record(&global_ctx, "Admin:a1");
        expect_scalar(&admin, "level", json!(5));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { search: SearchResult }
            union SearchResult = User | Admin
            type User { id: ID!, name: String! }
            type Admin { id: ID!, level: Int! }
        "#;
        let operation = r#"
            query TestOp {
                search {
                    __typename
                    ... on User { id name }
                    ... on Admin { id level }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "search": { "__typename": "User", "id": "u1", "name": "Ada" } }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "search": { "__typename": "Admin", "id": "a1", "level": 7 } }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let search = data
            .get("search")
            .and_then(|value| value.as_object())
            .expect("search missing");
        assert_eq!(search.get("__typename"), Some(&json!("Admin")));
        assert_eq!(search.get("level"), Some(&json!(7)));
    }
}

mod interfaces {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            interface Node { id: ID! }
            type User implements Node { id: ID!, name: String! }
            type Query { node: Node }
        "#;
        let operation = r#"
            query TestOp {
                node {
                    __typename
                    id
                    ... on User { name }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let result = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "node": { "__typename": "User", "id": "u1", "name": "Ada" } }),
            None,
        );

        let node = result
            .data
            .get("node")
            .and_then(|v| v.as_object())
            .expect("node missing");
        let ref_meta = node.get("__ref").and_then(|v| v.as_object()).unwrap();
        assert_eq!(ref_meta.get("path"), Some(&json!("ROOT_QUERY_node")));
        assert!(ref_meta.get("id").is_none());
        assert!(has_record(&global_ctx, "User:u1"));
    }

    #[test]
    fn test_read() {
        let schema = r#"
            interface Node { id: ID! }
            type User implements Node { id: ID!, name: String! }
            type Query { node: Node }
        "#;
        let operation = r#"
            query TestOp {
                node {
                    __typename
                    id
                    ... on User { name }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "node": { "__typename": "User", "id": "u1", "name": "Ada" } }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "name", json!("Ada"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            interface Node { id: ID! }
            type User implements Node { id: ID!, name: String! }
            type Query { node: Node }
        "#;
        let operation = r#"
            query TestOp {
                node {
                    __typename
                    id
                    ... on User { name }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "node": { "__typename": "User", "id": "u1", "name": "Ada" } }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "node": { "__typename": "User", "id": "u1", "name": "Grace" } }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let node = data
            .get("node")
            .and_then(|value| value.as_object())
            .expect("node missing");
        assert_eq!(node.get("name"), Some(&json!("Grace")));
    }
}

mod fragments {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { post: Post }
            type Post { id: ID!, title: String!, author: User }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            fragment PostFields on Post {
                id
                title
                author { id name }
            }
            query TestOp {
                post { ...PostFields }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "post": {
                    "id": "p1",
                    "title": "Hello",
                    "author": { "id": "u1", "name": "Ada" }
                }
            }),
            None,
        );

        let post = record(&global_ctx, "Post:p1");
        expect_scalar(&post, "title", json!("Hello"));
        expect_ref(post.get("author").expect("author missing"), "User:u1");
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { post: Post }
            type Post { id: ID!, title: String!, author: User }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            fragment PostFields on Post {
                id
                title
                author { id name }
            }
            query TestOp {
                post { ...PostFields }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "post": {
                    "id": "p1",
                    "title": "Hello",
                    "author": { "id": "u1", "name": "Ada" }
                }
            }),
            None,
        );

        let author = record(&global_ctx, "User:u1");
        expect_scalar(&author, "name", json!("Ada"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { post: Post }
            type Post { id: ID!, title: String!, author: User }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            fragment PostFields on Post {
                id
                title
                author { id name }
            }
            query TestOp {
                post { ...PostFields }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "post": {
                    "id": "p1",
                    "title": "Hello",
                    "author": { "id": "u1", "name": "Ada" }
                }
            }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "post": {
                    "id": "p1",
                    "title": "Hello",
                    "author": { "id": "u1", "name": "Grace" }
                }
            }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let post = data
            .get("post")
            .and_then(|value| value.as_object())
            .expect("post missing");
        let author = post
            .get("author")
            .and_then(|value| value.as_object())
            .expect("author missing");
        assert_eq!(author.get("name"), Some(&json!("Grace")));
    }
}

mod list_of_scalars {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { tags: [String!]! }
        "#;
        let operation = r#"
            query TestOp { tags }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(&global_ctx, &op_ctx, json!({ "tags": ["a", "b"] }), None);

        let root = root_record(&global_ctx);
        let tags = expect_list(root.get("tags").expect("tags missing"));
        assert_eq!(tags.len(), 2);
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { tags: [String!]! }
        "#;
        let operation = r#"
            query TestOp { tags }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(&global_ctx, &op_ctx, json!({ "tags": ["a", "b"] }), None);

        let root = root_record(&global_ctx);
        let tags = expect_list(root.get("tags").expect("tags missing"));
        assert!(matches!(tags[0], CacheValue::Scalar(_)));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { tags: [String!]! }
        "#;
        let operation = r#"
            query TestOp { tags }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(&global_ctx, &op_ctx, json!({ "tags": ["a", "b"] }), None);
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(&global_ctx, &op_ctx, json!({ "tags": ["a", "c"] }), None);

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(data.get("tags"), Some(&json!(["a", "c"])));
    }
}

mod list_of_custom_scalars {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            scalar Point
            type Query { points: [Point!]! }
        "#;
        let operation = r#"
            query TestOp { points }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "points": ["POINT (1,1)", "POINT (2,2)"] }),
            None,
        );

        let root = root_record(&global_ctx);
        let points = expect_list(root.get("points").expect("points missing"));
        assert_eq!(points.len(), 2);
    }

    #[test]
    fn test_read() {
        let schema = r#"
            scalar Point
            type Query { points: [Point!]! }
        "#;
        let operation = r#"
            query TestOp { points }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "points": ["POINT (1,1)", "POINT (2,2)"] }),
            None,
        );

        let root = root_record(&global_ctx);
        let points = expect_list(root.get("points").expect("points missing"));
        match &points[1] {
            CacheValue::Scalar(Value::String(val)) => assert_eq!(val, "POINT (2,2)"),
            other => panic!("expected scalar point, got {other:?}"),
        }
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            scalar Point
            type Query { points: [Point!]! }
        "#;
        let operation = r#"
            query TestOp { points }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "points": ["POINT (1,1)", "POINT (2,2)"] }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "points": ["POINT (1,1)", "POINT (3,3)"] }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(
            data.get("points"),
            Some(&json!(["POINT (1,1)", "POINT (3,3)"]))
        );
    }
}

mod list_of_objects {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { users: [User!]! }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            query TestOp { users { id name } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "users": [{ "id": "u1", "name": "Ada" }] }),
            None,
        );

        let root = root_record(&global_ctx);
        let users = expect_list(root.get("users").expect("users missing"));
        expect_ref(&users[0], "User:u1");
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { users: [User!]! }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            query TestOp { users { id name } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "users": [{ "id": "u1", "name": "Ada" }] }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "name", json!("Ada"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { users: [User!]! }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            query TestOp { users { id name } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "users": [
                    { "id": "u1", "name": "Ada" },
                    { "id": "u2", "name": "Grace" }
                ]
            }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "users": [
                    { "id": "u2", "name": "Grace" },
                    { "id": "u1", "name": "Ada" }
                ]
            }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let users = data
            .get("users")
            .and_then(|value| value.as_array())
            .expect("users missing");
        let first = users
            .first()
            .and_then(|value| value.as_object())
            .expect("first user missing");
        assert_eq!(first.get("id"), Some(&json!("u2")));
    }
}

mod list_of_enums {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { statuses: [Status!]! }
        "#;
        let operation = r#"
            query TestOp { statuses }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "statuses": ["OPEN", "CLOSED"] }),
            None,
        );

        let root = root_record(&global_ctx);
        let statuses = expect_list(root.get("statuses").expect("statuses missing"));
        assert_eq!(statuses.len(), 2);
    }

    #[test]
    fn test_read() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { statuses: [Status!]! }
        "#;
        let operation = r#"
            query TestOp { statuses }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "statuses": ["OPEN", "CLOSED"] }),
            None,
        );

        let root = root_record(&global_ctx);
        let statuses = expect_list(root.get("statuses").expect("statuses missing"));
        match &statuses[0] {
            CacheValue::Scalar(Value::String(val)) => assert_eq!(val, "OPEN"),
            other => panic!("expected enum scalar, got {other:?}"),
        }
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { statuses: [Status!]! }
        "#;
        let operation = r#"
            query TestOp { statuses }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "statuses": ["OPEN", "CLOSED"] }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "statuses": ["OPEN", "OPEN"] }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(data.get("statuses"), Some(&json!(["OPEN", "OPEN"])));
    }
}

mod list_of_unions {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { results: [SearchResult!]! }
            union SearchResult = User | Admin
            type User { id: ID!, name: String! }
            type Admin { id: ID!, level: Int! }
        "#;
        let operation = r#"
            query TestOp {
                results {
                    __typename
                    ... on User { id name }
                    ... on Admin { id level }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "results": [
                    { "__typename": "User", "id": "u1", "name": "Ada" },
                    { "__typename": "Admin", "id": "a1", "level": 5 }
                ]
            }),
            None,
        );

        let root = root_record(&global_ctx);
        let results = expect_list(root.get("results").expect("results missing"));
        expect_ref(&results[0], "User:u1");
        expect_ref(&results[1], "Admin:a1");
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { results: [SearchResult!]! }
            union SearchResult = User | Admin
            type User { id: ID!, name: String! }
            type Admin { id: ID!, level: Int! }
        "#;
        let operation = r#"
            query TestOp {
                results {
                    __typename
                    ... on User { id name }
                    ... on Admin { id level }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "results": [
                    { "__typename": "User", "id": "u1", "name": "Ada" }
                ]
            }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "name", json!("Ada"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { results: [SearchResult!]! }
            union SearchResult = User | Admin
            type User { id: ID!, name: String! }
            type Admin { id: ID!, level: Int! }
        "#;
        let operation = r#"
            query TestOp {
                results {
                    __typename
                    ... on User { id name }
                    ... on Admin { id level }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "results": [
                    { "__typename": "User", "id": "u1", "name": "Ada" },
                    { "__typename": "Admin", "id": "a1", "level": 5 }
                ]
            }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "results": [
                    { "__typename": "Admin", "id": "a1", "level": 5 },
                    { "__typename": "User", "id": "u1", "name": "Ada" }
                ]
            }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let results = data
            .get("results")
            .and_then(|value| value.as_array())
            .expect("results missing");
        let first = results
            .first()
            .and_then(|value| value.as_object())
            .expect("first result missing");
        assert_eq!(first.get("__typename"), Some(&json!("Admin")));
    }
}

mod list_of_interfaces {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            interface Node { id: ID! }
            type User implements Node { id: ID!, name: String! }
            type Query { nodes: [Node!]! }
        "#;
        let operation = r#"
            query TestOp {
                nodes {
                    __typename
                    id
                    ... on User { name }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "nodes": [
                    { "__typename": "User", "id": "u1", "name": "Ada" }
                ]
            }),
            None,
        );

        let root = root_record(&global_ctx);
        let nodes = expect_list(root.get("nodes").expect("nodes missing"));
        expect_ref(&nodes[0], "User:u1");
    }

    #[test]
    fn test_read() {
        let schema = r#"
            interface Node { id: ID! }
            type User implements Node { id: ID!, name: String! }
            type Query { nodes: [Node!]! }
        "#;
        let operation = r#"
            query TestOp {
                nodes {
                    __typename
                    id
                    ... on User { name }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "nodes": [
                    { "__typename": "User", "id": "u1", "name": "Ada" }
                ]
            }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "name", json!("Ada"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            interface Node { id: ID! }
            type User implements Node { id: ID!, name: String! }
            type Query { nodes: [Node!]! }
        "#;
        let operation = r#"
            query TestOp {
                nodes {
                    __typename
                    id
                    ... on User { name }
                }
            }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "nodes": [
                    { "__typename": "User", "id": "u1", "name": "Ada" }
                ]
            }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({
                "nodes": [
                    { "__typename": "User", "id": "u1", "name": "Grace" }
                ]
            }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let nodes = data
            .get("nodes")
            .and_then(|value| value.as_array())
            .expect("nodes missing");
        let first = nodes
            .first()
            .and_then(|value| value.as_object())
            .expect("node missing");
        assert_eq!(first.get("name"), Some(&json!("Grace")));
    }
}

mod list_of_fragments {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { users: [User!]! }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            fragment UserFields on User { id name }
            query TestOp { users { ...UserFields } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "users": [{ "id": "u1", "name": "Ada" }] }),
            None,
        );

        let root = root_record(&global_ctx);
        let users = expect_list(root.get("users").expect("users missing"));
        expect_ref(&users[0], "User:u1");
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { users: [User!]! }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            fragment UserFields on User { id name }
            query TestOp { users { ...UserFields } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "users": [{ "id": "u1", "name": "Ada" }] }),
            None,
        );

        let user = record(&global_ctx, "User:u1");
        expect_scalar(&user, "name", json!("Ada"));
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { users: [User!]! }
            type User { id: ID!, name: String! }
        "#;
        let operation = r#"
            fragment UserFields on User { id name }
            query TestOp { users { ...UserFields } }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "users": [{ "id": "u1", "name": "Ada" }] }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "users": [{ "id": "u1", "name": "Grace" }] }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        let users = data
            .get("users")
            .and_then(|value| value.as_array())
            .expect("users missing");
        let first = users
            .first()
            .and_then(|value| value.as_object())
            .expect("user missing");
        assert_eq!(first.get("name"), Some(&json!("Grace")));
    }
}

mod nested_list {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { matrix: [[Int!]!]! }
        "#;
        let operation = r#"
            query TestOp { matrix }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "matrix": [[1, 2], [3, 4]] }),
            None,
        );

        let root = root_record(&global_ctx);
        let matrix = expect_list(root.get("matrix").expect("matrix missing"));
        assert_eq!(matrix.len(), 2);
    }

    #[test]
    fn test_read() {
        let schema = r#"
            type Query { matrix: [[Int!]!]! }
        "#;
        let operation = r#"
            query TestOp { matrix }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "matrix": [[1, 2], [3, 4]] }),
            None,
        );

        let root = root_record(&global_ctx);
        let matrix = expect_list(root.get("matrix").expect("matrix missing"));
        let row = expect_list(&matrix[0]);
        match &row[1] {
            CacheValue::Scalar(Value::Number(val)) => assert_eq!(val.as_i64(), Some(2)),
            other => panic!("expected scalar int, got {other:?}"),
        }
    }

    #[test]
    fn test_subscribe() {
        let schema = r#"
            type Query { matrix: [[Int!]!]! }
        "#;
        let operation = r#"
            query TestOp { matrix }
        "#;
        let (global_ctx, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &global_ctx,
            &op_ctx,
            json!({ "matrix": [[1, 2], [3, 4]] }),
            None,
        );
        let sub_id = subscribe(&global_ctx, &op_ctx, &initial.data);
        normalize(
            &global_ctx,
            &op_ctx,
            json!({ "matrix": [[1, 3], [3, 4]] }),
            None,
        );

        let data = single_update(&global_ctx, sub_id);
        assert_eq!(data.get("matrix"), Some(&json!([[1, 3], [3, 4]])));
    }
}

mod input_scalar {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { result(term: String!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($term: String!) {
                result(term: $term) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("term", Value::String("foo".to_string()))]),
            "result_term:foo",
        );
    }
}

mod input_custom_scalar {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            scalar Point
            type Query { result(point: Point!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($point: Point!) {
                result(point: $point) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("point", Value::String("POINT (1,2)".to_string()))]),
            "result_point:POINT (1,2)",
        );
    }
}

mod input_object {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            input Filter { limit: Int!, active: Boolean! }
            type Query { result(filter: Filter!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($filter: Filter!) {
                result(filter: $filter) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("filter", json!({ "limit": 10, "active": true }))]),
            "result_filter:{active:true,limit:10}",
        );
    }
}

mod input_enum {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { result(status: Status!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($status: Status!) {
                result(status: $status) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("status", Value::String("OPEN".to_string()))]),
            "result_status:OPEN",
        );
    }
}

mod input_list_scalar {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            type Query { result(values: [Int!]!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($values: [Int!]!) {
                result(values: $values) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("values", json!([1, 2, 3]))]),
            "result_values:[1,2,3]",
        );
    }
}

mod input_list_custom_scalar {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            scalar Point
            type Query { result(points: [Point!]!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($points: [Point!]!) {
                result(points: $points) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("points", json!(["POINT (1,1)", "POINT (2,2)"]))]),
            "result_points:[POINT (1,1),POINT (2,2)]",
        );
    }
}

mod input_list_object {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            input Filter { limit: Int!, active: Boolean! }
            type Query { result(filters: [Filter!]!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($filters: [Filter!]!) {
                result(filters: $filters) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[(
                "filters",
                json!([
                    { "limit": 1, "active": true },
                    { "limit": 2, "active": false }
                ]),
            )]),
            "result_filters:[{active:true,limit:1},{active:false,limit:2}]",
        );
    }
}

mod input_list_enum {
    use super::*;

    #[test]
    fn test_normalize() {
        let schema = r#"
            enum Status { OPEN CLOSED }
            type Query { result(statuses: [Status!]!): Result }
            type Result { id: ID! }
        "#;
        let operation = r#"
            query TestOp($statuses: [Status!]!) {
                result(statuses: $statuses) { id }
            }
        "#;
        normalize_input_case(
            schema,
            operation,
            vars(&[("statuses", json!(["OPEN", "CLOSED"]))]),
            "result_statuses:[OPEN,CLOSED]",
        );
    }
}

mod fragment_subscriptions {
    use super::*;

    #[test]
    fn test_fragment_subscription_by_id() {
        let schema = r#"
            type Query { person: Person }
            type Person { id: ID!, name: String }
        "#;
        let operation = r#"
            fragment PersonFrag on Person { id name }
            query GetPerson { person { ...PersonFrag } }
        "#;
        let (runtime, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &runtime,
            &op_ctx,
            json!({ "person": { "id": "1", "name": "Ana" } }),
            None,
        );
        let person = initial
            .data
            .get("person")
            .and_then(|value| value.as_object())
            .expect("person missing");
        let root_ref = person
            .get("__ref")
            .and_then(|value| value.as_object())
            .and_then(|meta| meta.get("id"))
            .and_then(|value| value.as_str())
            .expect("person ref id missing")
            .to_string();
        let name_ref = person
            .get("__ref_name")
            .and_then(|value| value.as_str())
            .expect("person name ref missing")
            .to_string();
        let sub_id = runtime
            .subscribe("PersonFrag", Some(root_ref), vec![name_ref])
            .expect("subscribe");
        normalize(
            &runtime,
            &op_ctx,
            json!({ "person": { "id": "1", "name": "Bea" } }),
            None,
        );

        let data = single_update(&runtime, sub_id);
        let obj = data.as_object().expect("fragment data object");
        let meta = obj
            .get("__ref")
            .and_then(|v| v.as_object())
            .expect("ref meta");
        assert_eq!(meta.get("id"), Some(&json!("Person:1")));
        assert_eq!(obj.get("name"), Some(&json!("Bea")));
        assert_eq!(obj.get("__ref_name"), Some(&json!("Person:1_name")));
    }

    #[test]
    fn test_fragment_subscription_by_path() {
        let schema = r#"
            type Query { person: Person }
            type Person { id: ID!, pet: Pet }
            type Pet { name: String }
        "#;
        let operation = r#"
            fragment PetFrag on Pet { name }
            query GetPerson { person { id pet { ...PetFrag } } }
        "#;
        let (runtime, op_ctx) = build_ctx(schema, operation);
        let initial = normalize(
            &runtime,
            &op_ctx,
            json!({ "person": { "id": "1", "pet": { "name": "Coco" } } }),
            None,
        );
        let person = initial
            .data
            .get("person")
            .and_then(|value| value.as_object())
            .expect("person missing");
        let pet = person
            .get("pet")
            .and_then(|value| value.as_object())
            .expect("pet missing");
        let root_ref = pet
            .get("__ref")
            .and_then(|value| value.as_object())
            .and_then(|meta| meta.get("path"))
            .and_then(|value| value.as_str())
            .expect("pet ref path missing")
            .to_string();
        let name_ref = pet
            .get("__ref_name")
            .and_then(|value| value.as_str())
            .expect("pet name ref missing")
            .to_string();
        let sub_id = runtime
            .subscribe("PetFrag", Some(root_ref), vec![name_ref])
            .expect("subscribe");
        normalize(
            &runtime,
            &op_ctx,
            json!({ "person": { "id": "1", "pet": { "name": "Milo" } } }),
            None,
        );

        let data = single_update(&runtime, sub_id);
        let obj = data.as_object().expect("fragment data object");
        let meta = obj
            .get("__ref")
            .and_then(|v| v.as_object())
            .expect("ref meta");
        assert_eq!(meta.get("path"), Some(&json!("Person:1_pet")));
        assert_eq!(obj.get("name"), Some(&json!("Milo")));
        assert_eq!(obj.get("__ref_name"), Some(&json!("Person:1_pet_name")));
    }
}
