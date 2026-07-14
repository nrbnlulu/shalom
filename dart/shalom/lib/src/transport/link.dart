import 'dart:async';
import 'dart:convert' show jsonDecode;

import '../rust/api/runtime.dart' as rs_runtime;
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
        ShalomJsonValueAccess,
        ShalomTransportException;

/// The representation of a GraphQL response emitted by a transport link.
sealed class GraphQLLinkPayload {
  const GraphQLLinkPayload();
}

/// A raw GraphQL-over-HTTP response body.
final class RawGraphQLLinkPayload extends GraphQLLinkPayload {
  final String json;
  const RawGraphQLLinkPayload({required this.json});
}

/// A response parsed by Rust's WebSocket protocol state machine.
final class ParsedGraphQLLinkPayload extends GraphQLLinkPayload {
  final rs_runtime.GraphQlResponseInput response;
  const ParsedGraphQLLinkPayload({required this.response});
}

abstract class GraphQLLink {
  Stream<GraphQLResponse<GraphQLLinkPayload>> request({
    required Request request,
    HeadersType? headers,
  });
}

class ShalomClient {
  final GraphQLLink link;
  const ShalomClient({required this.link});

  Stream<GraphQLResponse<T>> request<T>({
    required RequestMeta<T> meta,
    HeadersType? headers,
  }) {
    final controller = StreamController<GraphQLResponse<T>>();
    StreamSubscription<GraphQLResponse<GraphQLLinkPayload>>? linkSubscription;

    controller.onListen = () {
      linkSubscription = link
          .request(request: meta.request, headers: headers)
          .listen(
            (response) {
              if (controller.isClosed) return;

              switch (response) {
                case GraphQLData(:final data):
                  controller.add(switch (data) {
                    RawGraphQLLinkPayload(:final json) => _decodeRawResponse(
                      json,
                      meta.parseFn,
                    ),
                    ParsedGraphQLLinkPayload(:final response) =>
                      _decodeTypedResponse(response, meta.parseFn),
                  });
                case GraphQLError(:final errors, :final extensions):
                  controller.add(
                    GraphQLError(errors: errors, extensions: extensions),
                  );
                case LinkExceptionResponse(:final errors):
                  controller.add(LinkExceptionResponse(errors));
              }
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
    await for (final res in link.request(
      request: meta.request,
      headers: headers,
    )) {
      switch (res) {
        case GraphQLData(:final data):
          return switch (data) {
            RawGraphQLLinkPayload(:final json) => _decodeRawResponse(
              json,
              meta.parseFn,
            ),
            ParsedGraphQLLinkPayload(:final response) => _decodeTypedResponse(
              response,
              meta.parseFn,
            ),
          };
        case GraphQLError(:final errors, :final extensions):
          return GraphQLError(errors: errors, extensions: extensions);
        case LinkExceptionResponse(:final errors):
          return LinkExceptionResponse(errors);
      }
    }
    throw Exception("Stream closed without emitting a response");
  }
}

GraphQLResponse<T> _decodeTypedResponse<T>(
  rs_runtime.GraphQlResponseInput response,
  T Function(JsonObject) decoder,
) => switch (response) {
  rs_runtime.GraphQlResponseInput_Data(
    :final data,
    :final errors,
    :final extensions,
  ) =>
    GraphQLData(
      data: decoder(data.toJsonValue() as JsonObject),
      errors: errors
          ?.map((error) => error.toJsonValue() as JsonObject)
          .toList(growable: false),
      extensions: extensions?.toJsonValue() as JsonObject?,
    ),
  rs_runtime.GraphQlResponseInput_Error(:final errors, :final extensions) =>
    GraphQLError(
      errors: errors
          .map((error) => error.toJsonValue() as JsonObject)
          .toList(growable: false),
      extensions: extensions?.toJsonValue() as JsonObject?,
    ),
  rs_runtime.GraphQlResponseInput_TransportError(
    :final message,
    :final code,
    :final details,
  ) =>
    LinkExceptionResponse([
      ShalomTransportException(
        message: message,
        code: code,
        details: details?.toJsonValue() as JsonObject?,
      ),
    ]),
};

GraphQLResponse<T> _decodeRawResponse<T>(
  String raw,
  T Function(JsonObject) decoder,
) {
  final response = jsonDecode(raw);
  if (response is! Map<String, dynamic>) {
    throw const FormatException('GraphQL response must be a JSON object');
  }
  final errors = switch (response['errors']) {
    final List<dynamic> values => values.cast<JsonObject>(),
    _ => null,
  };
  final extensions = response['extensions'] as JsonObject?;
  final data = response['data'];
  if (data is JsonObject) {
    return GraphQLData(
      data: decoder(data),
      errors: errors,
      extensions: extensions,
    );
  }
  if (errors != null) {
    return GraphQLError(errors: errors, extensions: extensions);
  }
  throw const FormatException('GraphQL response must include data or errors');
}
