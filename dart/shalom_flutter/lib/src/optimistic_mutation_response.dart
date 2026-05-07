import 'package:shalom/shalom.dart' show ShalomRuntimeClient;

/// Returned by `$<MutationName>.executeOptimistic()`.
///
/// Carries the real server response together with a handle to undo the
/// optimistic cache write that was applied before the network call.
class OptimisticMutationResponse<T> {
  OptimisticMutationResponse({
    required this.response,
    required this.wasRolledBack,
    required ShalomRuntimeClient client,
    required BigInt writeId,
  }) : _client = client,
       _writeId = writeId,
       _rolledBack = wasRolledBack;

  /// The decoded server response.
  final T response;

  /// `true` if the `rollbackWhen` predicate fired and the optimistic write was
  /// already undone before this object was returned to the caller.
  final bool wasRolledBack;

  final ShalomRuntimeClient _client;
  final BigInt _writeId;
  bool _rolledBack;

  /// Undo the optimistic cache write, restoring the pre-write state and
  /// re-notifying all affected subscribers.
  ///
  /// Idempotent — safe to call even if `wasRolledBack` is already `true` or
  /// if this method has already been called.
  void rollback() {
    if (_rolledBack) return;
    _rolledBack = true;
    _client.rollbackOptimistic(_writeId);
  }
}
