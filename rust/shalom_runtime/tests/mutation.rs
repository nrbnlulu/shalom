use serde_json::{Map, Value, json};
use tokio::runtime::Builder;
use tokio_stream::StreamExt;

use shalom_runtime::{ExecutionPolicy, ShalomRuntime, SubscriptionId};

// ---------------------------------------------------------------------------
// Test schema + SDL helpers
// ---------------------------------------------------------------------------

const SCHEMA: &str = r#"
    type Query  { user(id: ID!): User }
    type Mutation {
        updateUser(id: ID!, name: String!): User
        createUser(name: String!): User
    }
    type User { id: ID! name: String! }
"#;

const QUERY_OP: &str = r#"
    query GetUser($id: ID!) @observe {
        user(id: $id) { id name }
    }
"#;

const MUTATION_OP: &str = r#"
    mutation UpdateUser($id: ID!, $name: String!) {
        updateUser(id: $id, name: $name) { id name }
    }
"#;

const CREATE_MUTATION_OP: &str = r#"
    mutation CreateUser($name: String!) {
        createUser(name: $name) { id name }
    }
"#;

fn make_runtime() -> ShalomRuntime {
    let runtime = ShalomRuntime::init(SCHEMA, vec![], Default::default()).expect("init runtime");
    runtime
        .register_operation(QUERY_OP)
        .expect("register query");
    runtime
        .register_operation(MUTATION_OP)
        .expect("register mutation");
    runtime
}

fn vars(pairs: &[(&str, Value)]) -> Map<String, Value> {
    pairs
        .iter()
        .map(|(k, v)| (k.to_string(), v.clone()))
        .collect()
}

fn yield_update_sync(runtime: &ShalomRuntime, id: SubscriptionId) -> Value {
    yield_nth_update_sync(runtime, id, 1)
}

fn yield_nth_update_sync(runtime: &ShalomRuntime, id: SubscriptionId, n: usize) -> Value {
    let mut stream = runtime.subscription_stream(&id).expect("stream");
    let tokio_rt = Builder::new_current_thread().enable_all().build().unwrap();
    let data = tokio_rt.block_on(async {
        let mut last = None;
        for _ in 0..n {
            last = stream.next().await;
        }
        last
    });
    runtime.unsubscribe(&id);
    data.unwrap().unwrap().data
}

// ---------------------------------------------------------------------------
// §1d — mutation normalizes shared entity, query subscription fires
// ---------------------------------------------------------------------------

#[test]
fn mutation_normalizes_shared_entity() {
    let runtime = make_runtime();

    // Seed the cache via a query response so a query subscription exists.
    let query_op = runtime.operation_by_name("GetUser").unwrap();
    let query_vars = vars(&[("id", json!("1"))]);
    runtime
        .normalize(
            &query_op,
            json!({ "user": { "id": "1", "name": "Alice" } }),
            Some(&query_vars),
        )
        .expect("query normalize");
    let sub_id = runtime.create_operation_subscription(
        query_op.clone(),
        Some(query_vars.clone()),
        ExecutionPolicy::NetworkFirst,
    );

    // Fire the mutation: updates User:1 name.
    let mutation_op = runtime.operation_by_name("UpdateUser").unwrap();
    let mut_vars = vars(&[("id", json!("1")), ("name", json!("Bob"))]);
    runtime
        .normalize(
            &mutation_op,
            json!({ "updateUser": { "id": "1", "name": "Bob" } }),
            Some(&mut_vars),
        )
        .expect("mutation normalize");

    // The query subscription watching User:1 should have received an update.
    let data = yield_update_sync(&runtime, sub_id);
    assert_eq!(data["user"]["name"], json!("Bob"));
}

// ---------------------------------------------------------------------------
// §1b — write_optimistic updates cache; subscribers fire before network call
// ---------------------------------------------------------------------------

#[test]
fn write_optimistic_updates_cache() {
    let runtime = make_runtime();

    // Seed cache + subscription for User:1.
    let query_op = runtime.operation_by_name("GetUser").unwrap();
    let query_vars = vars(&[("id", json!("1"))]);
    runtime
        .normalize(
            &query_op,
            json!({ "user": { "id": "1", "name": "Alice" } }),
            Some(&query_vars),
        )
        .expect("seed");
    let sub_id = runtime.create_operation_subscription(
        query_op.clone(),
        Some(query_vars),
        ExecutionPolicy::NetworkFirst,
    );

    // Write optimistic data for the mutation (before any network response).
    runtime
        .write_optimistic(
            "UpdateUser",
            json!({ "updateUser": { "id": "1", "name": "OptimisticBob" } }),
        )
        .expect("write_optimistic");

    // The query subscription should immediately see the optimistic value.
    let data = yield_update_sync(&runtime, sub_id);
    assert_eq!(data["user"]["name"], json!("OptimisticBob"));
}

// ---------------------------------------------------------------------------
// §1c — rollback_optimistic restores previous cache state; subscribers re-fire
// ---------------------------------------------------------------------------

#[test]
fn rollback_optimistic_restores_state() {
    let runtime = make_runtime();

    // Seed.
    let query_op = runtime.operation_by_name("GetUser").unwrap();
    let query_vars = vars(&[("id", json!("1"))]);
    runtime
        .normalize(
            &query_op,
            json!({ "user": { "id": "1", "name": "Alice" } }),
            Some(&query_vars),
        )
        .expect("seed");

    // Optimistic write.
    let write_id = runtime
        .write_optimistic(
            "UpdateUser",
            json!({ "updateUser": { "id": "1", "name": "OptimisticBob" } }),
        )
        .expect("write_optimistic");

    // Confirm cache has optimistic value.
    let cache = runtime.cache();
    let user_record = cache.lock().get("User:1").cloned().expect("User:1 missing");
    assert!(matches!(
        user_record.get("name"),
        Some(shalom_runtime::cache::CacheValue::Scalar(v)) if v == &json!("OptimisticBob")
    ));

    // Subscribe AFTER the optimistic write so we can see the rollback.
    let sub_id = runtime.create_operation_subscription(
        query_op.clone(),
        Some(query_vars),
        ExecutionPolicy::NetworkFirst,
    );

    // Roll back.
    runtime.rollback_optimistic(write_id).expect("rollback");

    // Subscription should re-emit with original value.
    let data = yield_update_sync(&runtime, sub_id);
    assert_eq!(data["user"]["name"], json!("Alice"));
}

// ---------------------------------------------------------------------------
// §1c — rollback is idempotent (calling twice must not panic or error)
// ---------------------------------------------------------------------------

#[test]
fn rollback_optimistic_is_idempotent() {
    let runtime = make_runtime();

    let write_id = runtime
        .write_optimistic(
            "UpdateUser",
            json!({ "updateUser": { "id": "1", "name": "Bob" } }),
        )
        .expect("write_optimistic");

    runtime
        .rollback_optimistic(write_id)
        .expect("first rollback");
    runtime
        .rollback_optimistic(write_id)
        .expect("second rollback should be no-op");
}

// ---------------------------------------------------------------------------
// §1c — key absent before write is removed (not left stale) on rollback
// ---------------------------------------------------------------------------

#[test]
fn write_optimistic_absent_key_rolls_back_to_absent() {
    let runtime = ShalomRuntime::init(SCHEMA, vec![], Default::default()).unwrap();
    runtime.register_operation(CREATE_MUTATION_OP).unwrap();

    // User:99 does not exist in the cache yet.
    assert!(runtime.cache().lock().get("User:99").is_none());

    let write_id = runtime
        .write_optimistic(
            "CreateUser",
            json!({ "createUser": { "id": "99", "name": "NewPerson" } }),
        )
        .expect("write_optimistic");

    // After optimistic write, User:99 exists.
    assert!(runtime.cache().lock().get("User:99").is_some());

    // After rollback, User:99 must be absent again.
    runtime.rollback_optimistic(write_id).unwrap();
    assert!(
        runtime.cache().lock().get("User:99").is_none(),
        "User:99 should be removed after rollback"
    );
}

#[test]
fn write_operation_resolves_wrapped_observed_fragment_refs() {
    let schema = r#"
        type Query { observedUsers: [User!]!, users: [User!]! }
        type User { id: ID!, name: String! }
    "#;
    let operations = r#"
        fragment UserRow on User @observe { id name }

        query ObservedUsers {
            observedUsers { ...UserRow }
        }

        query Users {
            users { id name }
        }
    "#;
    let runtime = ShalomRuntime::init(schema, vec![], Default::default()).unwrap();
    runtime.register_operation(operations).unwrap();

    let observed_op = runtime.operation_by_name("ObservedUsers").unwrap();
    let observed = runtime
        .normalize(
            &observed_op,
            json!({ "observedUsers": [{ "id": "1", "name": "Ada" }] }),
            None,
        )
        .unwrap()
        .data;
    let user_ref = observed["observedUsers"][0]["$UserRow"].clone();

    runtime
        .write_operation("Users", json!({ "users": [user_ref] }), None)
        .unwrap();

    let users = runtime.try_read_operation("Users", None).unwrap().unwrap();
    assert_eq!(users["users"][0]["id"], json!("1"));
    assert_eq!(users["users"][0]["name"], json!("Ada"));
}

#[test]
fn write_operation_does_not_treat_user_fields_as_observed_refs() {
    let schema = r#"
        type Query { boxes: [Box!]! }
        type Box { observable_id: String!, anchor: String! }
    "#;
    let operation = r#"
        query Boxes {
            boxes { observable_id anchor }
        }
    "#;
    let runtime = ShalomRuntime::init(schema, vec![], Default::default()).unwrap();
    runtime.register_operation(operation).unwrap();

    runtime
        .write_operation(
            "Boxes",
            json!({
                "boxes": [
                    { "observable_id": "ordinary-field", "anchor": "ordinary-value" }
                ]
            }),
            None,
        )
        .unwrap();

    let boxes = runtime.try_read_operation("Boxes", None).unwrap().unwrap();
    assert_eq!(boxes["boxes"][0]["observable_id"], json!("ordinary-field"));
    assert_eq!(boxes["boxes"][0]["anchor"], json!("ordinary-value"));
}

// ---------------------------------------------------------------------------
// evict_operation — manual cache eviction of an operation's root field(s)
// ---------------------------------------------------------------------------

#[test]
fn evict_operation_removes_matching_root_field_only() {
    let runtime = make_runtime();

    runtime
        .write_operation(
            "GetUser",
            json!({ "user": { "id": "1", "name": "Alice" } }),
            Some(&vars(&[("id", json!("1"))])),
        )
        .unwrap();
    runtime
        .write_operation(
            "GetUser",
            json!({ "user": { "id": "2", "name": "Bob" } }),
            Some(&vars(&[("id", json!("2"))])),
        )
        .unwrap();

    // Evicting a non-matching set of variables is a no-op.
    let evicted_missing = runtime
        .evict_operation("GetUser", Some(&vars(&[("id", json!("3"))])))
        .unwrap();
    assert!(!evicted_missing);
    assert!(
        runtime
            .try_read_operation("GetUser", Some(&vars(&[("id", json!("1"))])))
            .unwrap()
            .is_some()
    );

    let evicted = runtime
        .evict_operation("GetUser", Some(&vars(&[("id", json!("1"))])))
        .unwrap();
    assert!(evicted);

    // The evicted variant is gone, the other is untouched.
    assert!(
        runtime
            .try_read_operation("GetUser", Some(&vars(&[("id", json!("1"))])))
            .unwrap()
            .is_none()
    );
    assert_eq!(
        runtime
            .try_read_operation("GetUser", Some(&vars(&[("id", json!("2"))])))
            .unwrap()
            .unwrap()["user"]["name"],
        json!("Bob")
    );
}

#[test]
fn evict_operation_updates_subscriber_tracked_refs() {
    let runtime = make_runtime();
    let query_op = runtime.operation_by_name("GetUser").unwrap();
    let query_vars = vars(&[("id", json!("1"))]);

    runtime
        .normalize(
            &query_op,
            json!({ "user": { "id": "1", "name": "Alice" } }),
            Some(&query_vars),
        )
        .expect("seed");
    let sub_id = runtime.create_operation_subscription(
        query_op.clone(),
        Some(query_vars.clone()),
        ExecutionPolicy::NetworkFirst,
    );

    // Eviction leaves the read incomplete, so — like GC and optimistic
    // rollback — the subscriber gets no spurious "empty" push here.
    let evicted = runtime
        .evict_operation("GetUser", Some(&query_vars))
        .unwrap();
    assert!(evicted);
    assert!(
        runtime
            .try_read_operation("GetUser", Some(&query_vars))
            .unwrap()
            .is_none()
    );

    // A subsequent write for the same key is still delivered, proving the
    // subscriber's tracked refs survived the eviction correctly.
    runtime
        .normalize(
            &query_op,
            json!({ "user": { "id": "1", "name": "Carol" } }),
            Some(&query_vars),
        )
        .expect("re-seed");
    let update = yield_update_sync(&runtime, sub_id);
    assert_eq!(update["user"]["name"], json!("Carol"));
}
