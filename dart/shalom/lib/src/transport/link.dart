import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../shalom_core_base.dart'
    show
        GraphQLData,
        GraphQLError,
        GraphQLResponse,
        HeadersType,
        JsonObject,
        LinkExceptionResponse,
        Request,
        RequestMeta,
        ShalomTransportException;

/// A GraphQL transport. Yields the exact, still-encoded response bytes for
/// each request — no JSON decoding happens here. [ShalomRuntimeClient] hands
/// these bytes straight to the Rust runtime, which does the parsing; callers
/// that need a decoded [GraphQLResponse] (e.g. [ShalomClient]) decode it
/// themselves via [parseGraphQLResponseBytes].
abstract class GraphQLLink {
  Stream<Uint8List> request({required Request request, HeadersType? headers});
}

/// Decodes raw response bytes into a [GraphQLResponse], applying the
/// GraphQL-over-HTTP rules: `data` present -> [GraphQLData], `data` absent
/// with `errors` present -> [GraphQLError], otherwise a [LinkExceptionResponse].
GraphQLResponse<JsonObject> parseGraphQLResponseBytes(Uint8List bytes) {
  try {
    final response = jsonDecode(utf8.decode(bytes));
    if (response is! JsonObject) {
      return LinkExceptionResponse([
        ShalomTransportException(
          message: 'Invalid GraphQL response: expected a JSON object',
          code: 'INVALID_RESPONSE_FORMAT',
        ),
      ]);
    }

    final data = response['data'];
    final errors = response['errors'];
    List<JsonObject>? parsedErrors;

    if (errors != null) {
      if (errors is List) {
        parsedErrors = errors.map((e) => e as JsonObject).toList();
      } else {
        return LinkExceptionResponse([
          ShalomTransportException(
            message: 'Invalid errors format: expected array',
            code: 'INVALID_RESPONSE_FORMAT',
          ),
        ]);
      }
    }

    final extensionsRaw = response['extensions'];
    final JsonObject? extensions =
        extensionsRaw != null && extensionsRaw is Map
        ? Map<String, dynamic>.from(extensionsRaw)
        : null;

    if (data != null) {
      if (data is Map) {
        return GraphQLData(
          data: data as JsonObject,
          errors: parsedErrors,
          extensions: extensions,
        );
      }
      return LinkExceptionResponse([
        ShalomTransportException(
          message: 'Invalid data format: expected JSON object',
          code: 'INVALID_RESPONSE_FORMAT',
        ),
      ]);
    } else if (parsedErrors != null) {
      return GraphQLError(errors: parsedErrors, extensions: extensions);
    }
    return LinkExceptionResponse([
      ShalomTransportException(
        message: 'Invalid GraphQL response: missing both data and errors',
        code: 'INVALID_RESPONSE_FORMAT',
      ),
    ]);
  } catch (e) {
    return LinkExceptionResponse([
      ShalomTransportException(
        message: 'Failed to parse response: ${e.toString()}',
        code: 'RESPONSE_PARSE_ERROR',
      ),
    ]);
  }
}

/// Standalone GraphQL client that decodes responses in Dart, for use without
/// the Rust-backed [ShalomRuntimeClient]/normalized cache.
class ShalomClient {
  final GraphQLLink link;
  const ShalomClient({required this.link});

  Stream<GraphQLResponse<T>> request<T>({
    required RequestMeta<T> meta,
    HeadersType? headers,
  }) {
    final controller = StreamController<GraphQLResponse<T>>();
    StreamSubscription<Uint8List>? linkSubscription;

    controller.onListen = () {
      linkSubscription = link
          .request(request: meta.request, headers: headers)
          .listen(
            (bytes) {
              if (controller.isClosed) return;
              controller.add(_decode(bytes, meta));
            },
            onError: (error) {
              if (!controller.isClosed) {
                controller.addError(error);
              }
            },
            onDone: () {
              if (!controller.isClosed) {
                controller.close();
              }
            },
          );
    };

    controller.onCancel = () {
      linkSubscription?.cancel();
    };

    return controller.stream;
  }

  Future<GraphQLResponse<T>> requestAsync<T>({
    required RequestMeta<T> meta,
    HeadersType? headers,
  }) async {
    await for (final bytes in link.request(
      request: meta.request,
      headers: headers,
    )) {
      return _decode(bytes, meta);
    }
    throw Exception("Stream closed without emitting a response");
  }

  GraphQLResponse<T> _decode<T>(Uint8List bytes, RequestMeta<T> meta) {
    switch (parseGraphQLResponseBytes(bytes)) {
      case GraphQLData(:final data, :final errors, :final extensions):
        return GraphQLData(
          data: meta.parseFn(data),
          errors: errors,
          extensions: extensions,
        );
      case GraphQLError(:final errors, :final extensions):
        return GraphQLError(errors: errors, extensions: extensions);
      case LinkExceptionResponse(:final errors):
        return LinkExceptionResponse(errors);
    }
  }
}
