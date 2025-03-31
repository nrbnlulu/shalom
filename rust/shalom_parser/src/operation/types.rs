enum Selection {
    Scalar(String),
}

struct ObjectDefinition {
    parent_selection: Option<Selection>,
    type_name: String,
    selections: Vec<Selection>,
}

struct OperationDefinition {
    name: String,
    selections: Vec<Selection>,
}
