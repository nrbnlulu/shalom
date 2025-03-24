cd shalom_dart_codegen 
cargo run -- ../schema.graphql ../query.graphql ../codegen_tests/lib/schema.dart
cd ../codegen_tests
dart test


