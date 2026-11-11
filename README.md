<p align="center">
  <img src="docs/assets/shalom_banner.png" alt="Shalom" width="100%">
</p>

<p align="center">
  <strong>High-performance GraphQL client runtime & codegen for Dart and Flutter, backed by Rust.</strong>
</p>

<p align="center">
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/Rust-DEA584?logo=rust&logoColor=black" alt="Rust"></a>
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/GraphQL-E10098?logo=graphql&logoColor=white" alt="GraphQL"></a>
</p>

---

### Installation

1. Build the CLI from source:

```bash
cargo install --git https://github.com/nrbnlulu/shalom.git --branch main shalom_dart_codegen
```

2. add flutter deps
```bash
dart pub add shalom_flutter
dart pub add shalom_annotations
```

### Benchmarks

Rust cache benchmarks run on [CodSpeed](https://app.codspeed.io/) for pushes to
`main`, pull requests, and manual workflow runs. CodSpeed tracks the baseline,
compares regressions, and posts PR reports. Enable `nrbnlulu/shalom` in the
CodSpeed GitHub app to receive reports; public-repository uploads need no secret.
The workflow follows the [CodSpeed Criterion integration](https://codspeed.io/docs/benchmarks/rust/criterion)
and measures CPU simulation and heap memory on a standard GitHub runner.

To check the instrumented workloads locally:

```bash
cargo install cargo-codspeed --version 6.0.0 --locked -j 2
CARGO_BUILD_JOBS=2 cargo codspeed build --locked -p shalom_runtime --bench runtime_bench --measurement-mode simulation,memory
cargo codspeed run --measurement-mode simulation
cargo codspeed run --measurement-mode memory
```

Actual simulation measurements and uploads happen in CI. For local wall-clock
measurements, run `cargo bench -j 2 -p shalom_runtime --bench runtime_bench`.
Each iteration creates fresh state outside the measured section.

CodSpeed memory profiling replaces the custom counting allocator and JSON timing
harness. The existing normalization and read workloads cover cache allocations
and retained memory. Dart subscriber timing/RSS diagnostics remain in
`dart/shalom/benchmark/subscribers.dart`; these local diagnostics are not uploaded
to CodSpeed.

### File uploads

`HttpLink` supports the [GraphQL multipart request specification](https://github.com/jaydenseric/graphql-multipart-request-spec).
Map your schema's `Upload` scalar in `shalom.yml`:

```yaml
custom_scalars:
  Upload:
    graphql_name: Upload
    output_type:
      import_path: package:shalom/shalom.dart
      symbol_name: ShalomUpload
    impl_symbol:
      import_path: package:shalom/shalom.dart
      symbol_name: shalomUploadScalar
```

Pass `ShalomUpload(filename: 'photo.png', bytes: imageBytes, contentType: 'image/png')`
to the generated mutation's upload argument. Uploads may appear inside input
objects or lists; omitted optional inputs remain omitted and explicit nulls stay
null. Repeated files with the same name, content type and bytes share a part.

Your HTTP adapter must implement `ShalomMultipartHttpTransport` as well as its
ordinary `request` method. For example, with `package:http`:

```dart
@override
Future<String> requestMultipart({
  required String url,
  required ShalomMultipartRequest data,
  HeadersType? headers,
  JsonObject? extra,
}) async {
  final request = http.MultipartRequest('POST', Uri.parse(url));
  for (final (name, value) in headers ?? <(String, String)>[]) {
    request.headers[name] = value;
  }
  request.fields['operations'] = jsonEncode(data.operations);
  request.fields['map'] = jsonEncode(data.fileMap);
  for (final entry in data.files.entries) {
    request.files.add(http.MultipartFile.fromBytes(
      entry.key,
      entry.value.bytes,
      filename: entry.value.filename,
      contentType: MediaType.parse(entry.value.contentType),
    ));
  }
  final response = await http.Response.fromStream(await client.send(request));
  return response.body;
}
```

This example uses `dart:convert`, `package:http/http.dart` as `http`, and
`MediaType` from `package:http_parser/http_parser.dart`. The adapter owns the
multipart boundary. `HttpLink` removes any supplied Content-Type for uploads,
retains other headers, and uses POST even when `useGet` is enabled. Transports
without multipart support receive a `LinkExceptionResponse` for uploads.

Files are buffered in memory and encoded as base64 only while passing through
the Rust JSON boundary; the server receives binary multipart file parts. This
adds memory overhead, so use direct storage uploads for large files. The
`Upload` scalar is intended for inputs; servers should return file metadata or
URLs. Strawberry servers must enable `multipart_uploads_enabled=True`.
