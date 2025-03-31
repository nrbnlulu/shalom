use std::{collections::HashMap, sync::Arc};

use super::types::ObjectSelection;

/// the name of i.e object in a graphql query based on the parent fields.
type FullPathName = String;

#[derive(Debug)]
struct OperationTypes {
    objects: HashMap<FullPathName, Arc<ObjectSelection>>,
}
