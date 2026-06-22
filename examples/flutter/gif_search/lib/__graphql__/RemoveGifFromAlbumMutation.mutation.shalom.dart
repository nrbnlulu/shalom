// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'RemoveGifFromAlbumMutation.shalom.dart';

import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom/shalom.dart' show OptimisticMutationResponse, CacheProxy;
import 'RemoveGifFromAlbumMutation.shalom.dart';

abstract class $RemoveGifFromAlbumMutation {
  String operation$Name() => 'RemoveGifFromAlbumMutation';

  final shalom_core.ShalomRuntimeClient _client;
  const $RemoveGifFromAlbumMutation(this._client);

  /// Execute the mutation and return the normalised response.
  /// The response is written into the shared entity cache, triggering reactive
  /// updates on any query subscriptions watching the same entities.
  Future<RemoveGifFromAlbumMutationData> execute({
    required String albumId,
    required String gifId,
  }) => _client.mutate<RemoveGifFromAlbumMutationData>(
    name: operation$Name(),

    variables: RemoveGifFromAlbumMutationVariables(
      albumId: albumId,
      gifId: gifId,
    ).toJson(),

    decoder: RemoveGifFromAlbumMutationData.fromCache,
  );

  /// Execute the mutation and update the cache via [update].
  ///
  /// [update] receives a [CacheProxy] and the typed mutation response.
  /// Use [CacheProxy.readQuery] / [CacheProxy.writeQuery] to read the current
  /// cached value of any query and write back a modified version — the typical
  /// pattern for keeping lists in sync after an add / remove / reorder mutation.
  ///
  /// Example:
  /// ```dart
  /// await addTodo.executeWithCacheUpdate(
  ///   input: AddTodoInput(title: 'Buy milk'),
  ///   update: (cache, data) {
  ///     final current = cache.readQuery(
  ///       name: 'GetTodos',
  ///       decoder: GetTodosData.fromCache,
  ///     );
  ///     if (current != null) {
  ///       cache.writeQuery(
  ///         data: GetTodosData(todos: [...current.todos, data.addTodo!]),
  ///       );
  ///     }
  ///   },
  /// );
  /// ```
  Future<RemoveGifFromAlbumMutationData> executeWithCacheUpdate({
    required String albumId,
    required String gifId,
    required void Function(
      CacheProxy cache,
      RemoveGifFromAlbumMutationData data,
    )
    update,
  }) async {
    final vars = RemoveGifFromAlbumMutationVariables(
      albumId: albumId,
      gifId: gifId,
    );

    final data = await _client.mutate<RemoveGifFromAlbumMutationData>(
      name: operation$Name(),

      variables: vars.toJson(),

      decoder: RemoveGifFromAlbumMutationData.fromCache,
    );
    update(CacheProxy(_client), data);
    return data;
  }

  /// Execute the mutation with an optimistic cache write applied immediately,
  /// before the network response arrives.
  ///
  /// [optimisticFactory] receives the mutation variables and must return a
  /// predicted [RemoveGifFromAlbumMutationData]. This is written to the cache so that
  /// query subscriptions watching the same entities update instantly.
  ///
  /// [rollbackWhen] is called with the real server response. Return `true` to
  /// automatically undo the optimistic write (e.g. when the server signals an
  /// error via the data payload). Defaults to no auto-rollback.
  ///
  /// The returned [OptimisticMutationResponse] exposes:
  /// - [OptimisticMutationResponse.response] — the typed server response
  /// - [OptimisticMutationResponse.wasRolledBack] — whether auto-rollback fired
  /// - [OptimisticMutationResponse.rollback()] — imperative rollback (idempotent)
  Future<OptimisticMutationResponse<RemoveGifFromAlbumMutationData>>
  executeOptimistic(
    RemoveGifFromAlbumMutationData Function(
      RemoveGifFromAlbumMutationVariables vars,
    )
    optimisticFactory, {
    bool Function(RemoveGifFromAlbumMutationData response)? rollbackWhen,
    required String albumId,
    required String gifId,
  }) async {
    final vars = RemoveGifFromAlbumMutationVariables(
      albumId: albumId,
      gifId: gifId,
    );
    final writeId = await _client.writeOptimistic(
      name: operation$Name(),
      data: optimisticFactory(vars).toJson(),
    );

    var rolledBack = false;
    void doRollback() {
      if (rolledBack) return;
      rolledBack = true;
      _client.rollbackOptimistic(writeId);
    }

    try {
      final response = await _client.mutate<RemoveGifFromAlbumMutationData>(
        name: operation$Name(),

        variables: vars.toJson(),

        decoder: RemoveGifFromAlbumMutationData.fromCache,
      );
      if (rollbackWhen?.call(response) ?? false) doRollback();
      return OptimisticMutationResponse(
        response: response,
        wasRolledBack: rolledBack,
        client: _client,
        writeId: writeId,
      );
    } catch (e) {
      doRollback();
      rethrow;
    }
  }
}
