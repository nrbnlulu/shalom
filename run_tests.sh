cd shalom_dart_codegen 
SCHEMA_PATH="../shalom_dart/test/schema_feature/__graphql__/schema.dart"
rm $SCHEMA_PATH 
touch $SCHEMA_PATH 
cargo run -- ../schema.graphql ../query.graphql $SCHEMA_PATH 
cd ../shalom_dart
dart test


