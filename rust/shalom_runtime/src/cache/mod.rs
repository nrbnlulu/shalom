use std::collections::HashMap;

/// graphql scalars
#[derive(Debug)]
pub enum CachedScalar {
    String(String),
    Int(i64),
    Float(f64),
    Boolean(bool),
    Custom(String),
}


#[derive(Debug)]
pub struct CachedObject {
    fields: Vec<(String, Box<CacheEntry>)>,
}


#[derive(Debug)]
pub struct CacheRef {
    id: String,
    typename: String,
}


#[derive(Debug)]
pub enum CacheEntry {
    Scalar(CachedScalar),
    List(Vec<Box<CacheEntry>>),
    Object(CachedObject),
    Ref(CacheRef),
}

pub struct Cache {
    entries: HashMap<String, CacheEntry>
}
