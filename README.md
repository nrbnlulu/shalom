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

Use a lazy source for large files (this example uses `File` from `dart:io`):

```dart
final file = File('/path/to/photo.png');
final upload = ShalomUpload.stream(
  filename: 'photo.png',
  length: await file.length(),
  openRead: () => file.openRead(),
  contentType: 'image/png',
);
try {
  await UploadImageMutation(client).execute(file: upload);
} finally {
  upload.dispose();
}
```

`UploadImageMutation` represents your generated mutation. For bytes already in
memory, use `ShalomUpload(filename: 'photo.png', bytes: imageBytes)` instead.
Only an opaque ID is serialized into GraphQL variables and crosses the Rust
boundary. File contents, paths and stream factories stay in the originating
Dart isolate. Uploads may appear inside input objects or lists; omitted inputs
remain omitted and explicit nulls stay null. Reusing the same upload object
shares one multipart part; distinct sources keep distinct parts without reading
or hashing their contents.

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
    request.files.add(http.MultipartFile(
      entry.key,
      entry.value.openRead(),
      entry.value.length,
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

The transport streams binary file parts directly from Dart. Each `openRead`
call must return a fresh stream for retries and concurrent requests, yielding
exactly `length` bytes. Keep the source available until every request using it
finishes, then call `dispose()` in `finally` on success or failure. Disposal is
idempotent, invalidates the ID and releases the registry's source reference;
it does not close streams already opened by the transport. IDs cannot be
persisted, transferred to another isolate, or reused after disposal. Unknown or
disposed IDs produce a link error before any HTTP request is sent.

The `Upload` scalar is intended for inputs; servers should return file metadata
or URLs. Strawberry servers must enable `multipart_uploads_enabled=True`.
