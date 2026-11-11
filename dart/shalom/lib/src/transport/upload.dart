import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';

import '../scalar.dart';
import '../shalom_core_base.dart';

/// An in-memory file for a GraphQL `Upload` input scalar.
///
/// The JSON representation carries base64 bytes across the Rust runtime boundary.
/// `HttpLink` replaces it with a binary multipart part before sending the request.
/// Files are buffered in memory; prefer direct storage uploads for large files.
final class ShalomUpload {
  static const _marker = r'$shalom.upload';

  final String filename;
  final String contentType;
  final Uint8List bytes;

  ShalomUpload({
    required this.filename,
    required List<int> bytes,
    this.contentType = 'application/octet-stream',
  }) : bytes = Uint8List.fromList(bytes).asUnmodifiableView();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShalomUpload &&
          filename == other.filename &&
          contentType == other.contentType &&
          const ListEquality<int>().equals(bytes, other.bytes);

  @override
  int get hashCode =>
      Object.hash(filename, contentType, const ListEquality<int>().hash(bytes));

  JsonObject toJson() => {
    _marker: {
      'filename': filename,
      'contentType': contentType,
      'base64': base64Encode(bytes),
    },
  };

  factory ShalomUpload.fromJson(dynamic value) {
    final data =
        (value as Map<String, dynamic>)[_marker] as Map<String, dynamic>;
    return ShalomUpload(
      filename: data['filename'] as String,
      contentType: data['contentType'] as String,
      bytes: base64Decode(data['base64'] as String),
    );
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
