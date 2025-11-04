import 'dart:async';
import 'package:shalom_core/shalom_core.dart';
// Add this import for reliable Set comparison
import 'package:collection/collection.dart';

typedef HeadersType = List<(String, String)>;

abstract class GraphQLLink {
  const GraphQLLink();
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  });
}

/// helper class that can deserialize generated requests automatically
/// and auto listen for cache updates
class ShalomClient {
  final ShalomCtx ctx;
  final GraphQLLink link;

  // Static const to avoid repeated allocations of SetEquality
  static const _keyEquals = SetEquality<String>();

  const ShalomClient({required this.ctx, required this.link});

  Stream<GraphQLResponse<T>> request<T>({
    required Requestable<T> requestable,
    HeadersType? headers,
  }) {
    final meta = requestable.getRequestMeta();
    final controller = StreamController<GraphQLResponse<T>>();

    // Track the current cache subscription
    Set<String>? currentSubRefs;
    StreamSubscription<ShalomCtx>? cacheSubscription;
    StreamSubscription<GraphQLResponse<JsonObject>>? linkSubscription;

    // Track the last network response for reusing errors/extensions in cache updates
    GraphQLData<JsonObject>? lastNetworkResponse;

    void updateCacheSubscription(Set<String> newRefs) {
      if (_keyEquals.equals(newRefs, currentSubRefs)) {
        return;
      }

      // Cancel old subscription
      cacheSubscription?.cancel();
      currentSubRefs = newRefs;

      if (newRefs.isEmpty) {
        return;
      }

      // Subscribe to new cache keys
      cacheSubscription = ctx.subscribe(newRefs).streamController.stream.listen(
        (_) {
          if (controller.isClosed) return;

          // Get fresh data from cache
          final (fromCacheData, updatedRefs) = meta.fromCacheFn(ctx);

          // Yield the fresh data from the cache
          controller.add(GraphQLData(
            data: fromCacheData,
            errors: lastNetworkResponse?.errors,
            extensions: lastNetworkResponse?.extensions,
          ));

          // Update subscription if dependencies changed
          updateCacheSubscription(updatedRefs);
        },
        onError: (error) {
          if (!controller.isClosed) {
            controller.addError(error);
          }
        },
      );
    }

    // Subscribe to link stream
    linkSubscription =
        link.request(request: meta.request, headers: headers).listen(
      (response) {
        if (controller.isClosed) return;

        switch (response) {
          case GraphQLData():
            {
              // Load from the network response
              final (deserialized, initialSubRefs) =
                  meta.loadFn(data: response.data, ctx: ctx);

              // Store for cache updates
              lastNetworkResponse = response;

              // Yield the initial data from the network
              controller.add(GraphQLData(
                data: deserialized,
                errors: response.errors,
                extensions: response.extensions,
              ));

              // Set up or update cache subscription
              updateCacheSubscription(initialSubRefs);
            }
          case LinkExceptionResponse():
            {
              // Just forward link errors
              controller.add(LinkExceptionResponse(response.errors));
            }
          case GraphQLError():
            {
              // Just forward GraphQL errors
              controller.add(GraphQLError(
                  errors: response.errors, extensions: response.extensions));
            }
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

    // Set up cleanup when subscription is cancelled
    controller.onCancel = () {
      linkSubscription?.cancel();
      cacheSubscription?.cancel();
    };

    return controller.stream;
  }

  /// don't subscribe to changes of this operation and just get the initial data
  Future<GraphQLResponse<T>> requestOnce<T>({
    required Requestable<T> requestable,
    HeadersType? headers,
  }) async {
    final meta = requestable.getRequestMeta();

    await for (final res
        in link.request(request: meta.request, headers: headers)) {
      switch (res) {
        case GraphQLData():
          {
            // Load from the network response and return immediately
            final (deserialized, _) = meta.loadFn(data: res.data, ctx: ctx);

            return GraphQLData(
                data: deserialized,
                errors: res.errors,
                extensions: res.extensions);
          }
        case LinkExceptionResponse():
          {
            // Just forward link errors
            return LinkExceptionResponse(res.errors);
          }
        case GraphQLError():
          {
            // Just forward GraphQL errors
            return GraphQLError(errors: res.errors, extensions: res.extensions);
          }
      }
    }

    // This should never be reached as the stream should always yield at least one response
    throw StateError('No response received from GraphQL link');
  }
}
