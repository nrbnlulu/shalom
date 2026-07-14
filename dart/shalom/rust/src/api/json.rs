use std::collections::HashMap;

use flutter_rust_bridge::frb;
use serde_json::{Map, Number, Value};

/// JSON represented as an FRB-native recursive value.
///
/// This avoids serialising JSON to a string merely to cross the Rust/Dart
/// boundary. Dart converts this value directly to its normal JSON-compatible
/// `Map<String, dynamic>` / `List<dynamic>` representation.
#[frb]
#[derive(Debug, Clone, PartialEq)]
pub enum ShalomJsonValue {
    Null,
    Boolean(bool),
    Integer(i64),
    Float(f64),
    String(String),
    Array(Vec<ShalomJsonValue>),
    Object(HashMap<String, ShalomJsonValue>),
}

impl From<Value> for ShalomJsonValue {
    fn from(value: Value) -> Self {
        match value {
            Value::Null => Self::Null,
            Value::Bool(value) => Self::Boolean(value),
            Value::Number(value) => {
                if let Some(value) = value.as_i64() {
                    Self::Integer(value)
                } else if let Some(value) =
                    value.as_u64().and_then(|value| i64::try_from(value).ok())
                {
                    Self::Integer(value)
                } else {
                    Self::Float(
                        value
                            .as_f64()
                            .expect("serde_json numbers are representable as i64, u64, or f64"),
                    )
                }
            }
            Value::String(value) => Self::String(value),
            Value::Array(values) => {
                Self::Array(values.into_iter().map(ShalomJsonValue::from).collect())
            }
            Value::Object(values) => Self::Object(
                values
                    .into_iter()
                    .map(|(key, value)| (key, ShalomJsonValue::from(value)))
                    .collect(),
            ),
        }
    }
}

impl From<ShalomJsonValue> for Value {
    fn from(value: ShalomJsonValue) -> Self {
        match value {
            ShalomJsonValue::Null => Self::Null,
            ShalomJsonValue::Boolean(value) => Self::Bool(value),
            ShalomJsonValue::Integer(value) => Self::Number(Number::from(value)),
            ShalomJsonValue::Float(value) => Number::from_f64(value)
                .map(Self::Number)
                .unwrap_or(Self::Null),
            ShalomJsonValue::String(value) => Self::String(value),
            ShalomJsonValue::Array(values) => {
                Self::Array(values.into_iter().map(Value::from).collect())
            }
            ShalomJsonValue::Object(values) => Self::Object(
                values
                    .into_iter()
                    .map(|(key, value)| (key, Value::from(value)))
                    .collect::<Map<_, _>>(),
            ),
        }
    }
}

impl ShalomJsonValue {
    pub(crate) fn into_object(self, name: &str) -> anyhow::Result<Map<String, Value>> {
        match Value::from(self) {
            Value::Object(value) => Ok(value),
            Value::Null => Ok(Map::new()),
            _ => Err(anyhow::anyhow!("{name} must be a JSON object or null")),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn round_trips_nested_json() {
        let value = json!({
            "null": null,
            "bool": true,
            "int": 42,
            "float": 1.5,
            "string": "hello",
            "array": [{"nested": -7}],
        });

        assert_eq!(Value::from(ShalomJsonValue::from(value.clone())), value);
    }
}
