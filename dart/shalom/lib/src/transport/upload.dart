import 'dart:math';
import 'dart:typed_data';

import '../scalar.dart';
import '../shalom_core_base.dart';

/// A Dart-owned source for a GraphQL `Upload` input scalar.
///
/// Only an opaque ID crosses the Rust boundary. Use [ShalomUpload.stream] for
/// large files and supply a fresh stream for each request or retry. Call
/// [dispose] after all requests using this upload have finished, usually in a
/// `finally` block, to release the ID and its source from the registry.
final class ShalomUpload {
  static const _marker = r'$shalom.upload';
  static final _uploads = <String, ShalomUpload>{};
  static final _random = Random.secure();
  static final _session = List.generate(
    4,
    (_) => _random.nextInt(0x100000000).toRadixString(16).padLeft(8, '0'),
  ).join();
  static int _nextId = 0;

  final String _id = '$_session:${_nextId++}';
  final String filename;
  final String contentType;
  final int length;
  Stream<List<int>> Function()? _source;
  bool _disposed = false;

  /// Convenience constructor for files already held in memory.
  factory ShalomUpload({
    required String filename,
    required List<int> bytes,
    String contentType = 'application/octet-stream',
  }) {
    final data = Uint8List.fromList(bytes).asUnmodifiableView();
    return ShalomUpload.stream(
      filename: filename,
      length: data.length,
      openRead: () => Stream.value(data),
      contentType: contentType,
    );
  }

  /// Creates a lazy, repeatable source without reading or buffering the file.
  ///
  /// For a native `File`, pass `length: await file.length()` and
  /// `openRead: () => file.openRead()`. The transport opens and consumes the
  /// stream; a retry or concurrent request must receive its own fresh stream.
  ShalomUpload.stream({
    required this.filename,
    required this.length,
    required Stream<List<int>> Function() openRead,
    this.contentType = 'application/octet-stream',
  }) : _source = openRead {
    if (length < 0) {
      throw ArgumentError.value(length, 'length', 'Must be nonnegative');
    }
  }

  Stream<List<int>> openRead() {
    _checkNotDisposed();
    return _source!();
  }

  JsonObject toJson() {
    _checkNotDisposed();
    _uploads[_id] = this;
    return {_marker: _id};
  }

  /// Resolves an upload ID in the originating Dart isolate.
  ///
  /// Upload markers are process-local references, not persistable JSON data.
  factory ShalomUpload.fromJson(dynamic value) {
    final id = value is Map<String, dynamic> ? value[_marker] : null;
    final upload = id is String ? _uploads[id] : null;
    if (upload == null) {
      throw FormatException('Unknown or disposed ShalomUpload ID');
    }
    return upload;
  }

  /// Invalidates the ID and releases the registered stream factory.
  ///
  /// Wait for all requests using this source to finish before disposing it.
  /// Repeated disposal is safe. Streams already opened are owned by the caller.
  void dispose() {
    _uploads.remove(_id);
    _source = null;
    _disposed = true;
  }

  void _checkNotDisposed() {
    if (_disposed) throw StateError('ShalomUpload has been disposed');
  }

  static bool isUpload(Object? value) =>
      value is Map<String, dynamic> &&
      value.length == 1 &&
      value.containsKey(_marker);
}

/// Configure this implementation for the schema's `Upload` custom scalar.
const shalomUploadScalar = _UploadScalar();

final class _UploadScalar extends CustomScalarImpl<ShalomUpload> {
  const _UploadScalar();

  @override
  ShalomUpload deserialize(dynamic raw) => ShalomUpload.fromJson(raw);

  @override
  JsonObject serialize(ShalomUpload value) => value.toJson();
}

/// A GraphQL multipart request, with files replaced by null in [operations].
///
/// Send fields in this order: JSON-encoded `operations`, JSON-encoded `map`
/// ([fileMap]), then binary [files], keyed by their multipart field names.
final class ShalomMultipartRequest {
  final JsonObject operations;
  final Map<String, List<String>> fileMap;
  final Map<String, ShalomUpload> files;

  ShalomMultipartRequest._(this.operations, this.fileMap, this.files);

  factory ShalomMultipartRequest.fromRequest(Request request) {
    final files = <String, ShalomUpload>{};
    final fileMap = <String, List<String>>{};
    final fileKeys = <ShalomUpload, String>{};

    Object? extract(Object? value, String path) {
      if (value is ShalomUpload) value = value.toJson();
      if (ShalomUpload.isUpload(value)) {
        final file = ShalomUpload.fromJson(value);
        final key = fileKeys.putIfAbsent(file, () => '${files.length}');
        files[key] = file;
        (fileMap[key] ??= []).add(path);
        return null;
      }
      if (value is Map<String, dynamic>) {
        return value.map(
          (key, child) => MapEntry(key, extract(child, '$path.$key')),
        );
      }
      if (value is List) {
        return [
          for (var i = 0; i < value.length; i++) extract(value[i], '$path.$i'),
        ];
      }
      return value;
    }

    return ShalomMultipartRequest._(
      {
        'query': request.query,
        'operationName': request.opName,
        if (request.variables.isNotEmpty)
          'variables': extract(request.variables, 'variables'),
      },
      fileMap,
      files,
    );
  }
}
