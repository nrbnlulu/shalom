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
  }) async* {
    final meta = requestable.getRequestMeta();

    // Helper for comparing subscription key sets
    // Using static const to avoid repeated allocations

    await for (final res
        in link.request(request: meta.request, headers: headers)) {
      switch (res) {
        case GraphQLData():
          {
            // 1. Initial load from the network response
            final (deserialized, initialSubRefs) =
                meta.loadFn(data: res.data, ctx: ctx);

            // 2. Yield the initial data from the network
            yield GraphQLData(
                data: deserialized,
                errors: res.errors,
                extensions: res.extensions);

            // This variable will track the keys we are currently subscribed to
            var currentSubRefs = initialSubRefs;

            // 3. Start a loop to manage cache subscriptions.
            // This loop will restart if the subscription keys change.
            while (currentSubRefs.isNotEmpty) {
              // 4. Subscribe to the *current* set of keys
              final cacheStream =
                  ctx.subscribe(currentSubRefs).streamController.stream;

              // 5. Listen for cache updates
              await for (final _ in cacheStream) {
                // 6. On update, get fresh data and potentially *new* keys
                final (fromCacheData, newKeys) = meta.fromCacheFn(ctx);

                // 7. Yield the fresh data from the cache
                yield GraphQLData(
                    data: fromCacheData,
                    errors:
                        res.errors, // Re-use errors from original network res
                    extensions: res.extensions // Re-use extensions
                    );

                // 8. Check if the keys this data depends on have changed
                if (!_keyEquals.equals(newKeys, currentSubRefs)) {
                  // 9. If keys differ, update our tracking variable...
                  currentSubRefs = newKeys;

                  // ...and break the inner 'await for' loop.
                  // This causes the outer 'while' loop to re-evaluate.
                  // If currentSubRefs is now empty, the while loop exits.
                  // If it's non-empty, the while loop restarts,
                  // subscribing to the *new* set of keys.
                  break;
                }
              }
            }
          }
        case LinkErrorResponse():
          {
            // Just forward link errors
            yield LinkErrorResponse(res.errors);
          }
      }
    }
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
        case LinkErrorResponse():
          {
            // Just forward link errors
            return LinkErrorResponse(res.errors);
          }
      }
    }

    // This should never be reached as the stream should always yield at least one response
    throw StateError('No response received from GraphQL link');
  }
}
