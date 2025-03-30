


enum Selection {
    Scalar(String),
}

struct ObjectDefinition {
    type_name: String,
    selections: Vec<Selection>,
}

struct OperationDefinition {
    name: String,
    selections: Vec<Selection>,
}
