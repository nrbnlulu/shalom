import 'package:shalom/src/shalom_core_base.dart'
    show FragmentInterface, JsonObject, OperationInterface, ShalomJsonValue;
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
  Future<T?> readQuery<T>({
    required String name,
    T Function(JsonObject)? decoder,
    T Function(ShalomJsonValue)? bridgeDecoder,
    Map<String, dynamic>? variables,
    ShalomJsonValue? variablesValue,
  }) => _client.readQuery(
    name: name,
    decoder: decoder,
    bridgeDecoder: bridgeDecoder,
    variables: variables,
    variablesValue: variablesValue,
  );

  /// Write [data] to the cache for its generated operation, normalizing it
  /// and notifying any active subscribers.
  Future<void> writeQuery<T extends OperationInterface>({
    required T data,
    Map<String, dynamic>? variables,
    ShalomJsonValue? variablesValue,
  }) => _client.writeQuery(
    data: data,
    variables: variables,
    variablesValue: variablesValue,
  );

  /// Read an entity from the cache through the fragment's selection set.
  ///
  /// Returns `null` when the entity is absent or has missing refs.
  Future<T?> readFragment<T>({
    required String fragmentName,
    required String entityKey,
    T Function(JsonObject)? decoder,
    T Function(ShalomJsonValue)? bridgeDecoder,
  }) => _client.readFragment(
    fragmentName: fragmentName,
    entityKey: entityKey,
    decoder: decoder,
    bridgeDecoder: bridgeDecoder,
  );

  /// Write [data] directly into the entity store using the fragment's
  /// selection set, then notify all affected subscribers.
  ///
  /// The target entity is derived from [data]'s `entity$Type()`/`entity$Id()`
  /// — no separate `entityKey` is needed.
  Future<void> writeFragment<T extends FragmentInterface>({required T data}) =>
      _client.writeFragment(data: data);
}
