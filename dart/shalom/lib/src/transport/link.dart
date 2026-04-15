import 'dart:async';

import '../shalom_core_base.dart'
    show
        GraphQLData,
        GraphQLError,
        GraphQLResponse,
        HeadersType,
        JsonObject,
        LinkExceptionResponse,
        Request,
        RequestMeta;



abstract class GraphQLLink {
  Stream<GraphQLResponse<JsonObject>> request(
      {required Request request, HeadersType? headers});
}

class ShalomClient {
  final GraphQLLink link;
  const ShalomClient({required this.link});

  Stream<GraphQLResponse<T>> request<T>({
    required RequestMeta<T> meta,
    HeadersType? headers,
  }) {
    final controller = StreamController<GraphQLResponse<T>>();
    StreamSubscription<GraphQLResponse<JsonObject>>? linkSubscription;

    controller.onListen = () {
      linkSubscription =
          link.request(request: meta.request, headers: headers).listen(
        (response) {
          if (controller.isClosed) return;

          switch (response) {
            case GraphQLData(
                :final data,
                :final errors,
                :final extensions
              ):
              final deserialized = meta.parseFn(data);
              controller.add(GraphQLData(
                  data: deserialized,
                  errors: errors,
                  extensions: extensions));
            case GraphQLError(:final errors, :final extensions):
              controller.add(GraphQLError(
                  errors: errors, extensions: extensions));
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
    await for (final res
        in link.request(request: meta.request, headers: headers)) {
      switch (res) {
        case GraphQLData(:final data, :final errors, :final extensions):
          final deserialized = meta.parseFn(data);
          return GraphQLData(
              data: deserialized, errors: errors, extensions: extensions);
        case GraphQLError(:final errors, :final extensions):
          return GraphQLError(errors: errors, extensions: extensions);
        case LinkExceptionResponse(:final errors):
          return LinkExceptionResponse(errors);
      }
    }
    throw Exception("Stream closed without emitting a response");
  }
}
