import 'package:shalom/src/shalom_core_base.dart'
    show JsonObject, OperationInterface;
import 'runtime_client.dart' show ShalomRuntimeClient;

/// A focused cache interface passed to mutation `update` callbacks.
///
/// Mirrors Apollo's `cache` argument in `useMutation({ update(cache, data) })`:
/// read a query's current cached data, modify it, and write it back — all
/// within a single mutation response handler.
class CacheProxy {
  final ShalomRuntimeClient _client;

  const CacheProxy(this._client);

  /// Read the current cache for operation [name].
  ///
  /// Returns `null` when the data is absent or incomplete (missing refs).
  T? readQuery<T>({
    required String name,
    required T Function(JsonObject) decoder,
    Map<String, dynamic>? variables,
  }) => _client.readQuery(name: name, decoder: decoder, variables: variables);

  /// Write [data] to the cache for its generated operation, normalizing it
  /// and notifying any active subscribers.
  void writeQuery<T extends OperationInterface>({
    required T data,
    Map<String, dynamic>? variables,
  }) => _client.writeQuery(data: data, variables: variables);
}
