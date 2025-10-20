import 'package:shalom_core/shalom_core.dart';

abstract class GraphQLLink {
  const GraphQLLink();
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    required JsonObject headers,
  });
}

class ShalomClient {
  final ShalomCtx ctx;
  final GraphQLLink link;
  const ShalomClient({required this.ctx, required this.link});

  Stream<GraphQLResponse<T>> request<T>({
    required Requestable<T> requestable,
    required headers,
  }) async* {
    final meta = requestable.getRequestMeta();
    await for (final res
        in link.request(request: meta.request, headers: headers)) {
      switch (res) {
        case GraphQLData():
          {
            final (deserialized, subRefs) =
                meta.loadFn(data: res.data, ctx: ctx);
            yield GraphQLData(
                data: deserialized,
                errors: res.errors,
                extensions: res.extensions);
            await for (final _
                in ctx.subscribe(subRefs).streamController.stream) {
              final (fromCacheData, newKeys) = meta.fromCacheFn(ctx);
              yield GraphQLData(
                  data: fromCacheData,
                  errors: res.errors,
                  extensions: res.extensions);
              if (newKeys != subRefs){
                  
              }
            }
          }
        case LinkErrorResponse():
          {
            yield LinkErrorResponse(res.errors);
          }
      }
    }
  }
}
