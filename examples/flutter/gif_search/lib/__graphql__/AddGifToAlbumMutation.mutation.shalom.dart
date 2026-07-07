// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'AddGifToAlbumMutation.shalom.dart';

import 'dart:async' show FutureOr;
import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom/shalom.dart' show OptimisticMutationResponse, CacheProxy;
import 'AddGifToAlbumMutation.shalom.dart';

abstract class $AddGifToAlbumMutation {
  String operation$Name() => 'AddGifToAlbumMutation';

  final shalom_core.ShalomRuntimeClient _client;
  const $AddGifToAlbumMutation(this._client);

  /// Execute the mutation and return the normalised response.
  /// The response is written into the shared entity cache, triggering reactive
  /// updates on any query subscriptions watching the same entities.
  Future<shalom_core.GraphQLResponse<AddGifToAlbumMutationData>> execute({
    required String albumId,
    required shalom_core.Maybe<String?> previewUrl,
    required String title,
    required String url,
  }) => _client.mutate<AddGifToAlbumMutationData>(
    name: operation$Name(),

    variables: AddGifToAlbumMutationVariables(
      albumId: albumId,
      previewUrl: previewUrl,
      title: title,
      url: url,
    ).toJson(),

    decoder: AddGifToAlbumMutationData.fromCache,
  );

  /// Execute the mutation and update the cache via [update].
  ///
  /// [update] receives a [CacheProxy] and the typed mutation response data.
  /// It's only called if the mutation returns successful data.
  /// Use [CacheProxy.readQuery] / [CacheProxy.writeQuery] to read the current
  /// cached value of any query and write back a modified version — the typical
  /// pattern for keeping lists in sync after an add / remove / reorder mutation.
  ///
  /// Example:
  /// ```dart
  /// await addTodo.executeWithCacheUpdate(
  ///   input: AddTodoInput(title: 'Buy milk'),
  ///   update: (cache, data) async {
  ///     final current = await cache.readQuery(
  ///       name: 'GetTodos',
  ///       decoder: GetTodosData.fromCache,
  ///     );
  ///     if (current != null) {
  ///       await cache.writeQuery(
  ///         data: GetTodosData(todos: [...current.todos, data.addTodo!]),
  ///       );
  ///     }
  ///   },
  /// );
  /// ```
  Future<shalom_core.GraphQLResponse<AddGifToAlbumMutationData>>
  executeWithCacheUpdate({
    required String albumId,
    required shalom_core.Maybe<String?> previewUrl,
    required String title,
    required String url,
    required FutureOr<void> Function(
      CacheProxy cache,
      AddGifToAlbumMutationData data,
    )
    update,
  }) async {
    final vars = AddGifToAlbumMutationVariables(
      albumId: albumId,
      previewUrl: previewUrl,
      title: title,
      url: url,
    );

    final response = await _client.mutate<AddGifToAlbumMutationData>(
      name: operation$Name(),

      variables: vars.toJson(),

      decoder: AddGifToAlbumMutationData.fromCache,
    );
    if (response case shalom_core.GraphQLData(data: final data)) {
      await update(CacheProxy(_client), data);
    }
    return response;
  }

  /// Execute the mutation with an optimistic cache write applied immediately,
  /// before the network response arrives.
  ///
  /// [optimisticFactory] receives the mutation variables and must return a
  /// predicted [AddGifToAlbumMutationData]. This is written to the cache so that
  /// query subscriptions watching the same entities update instantly.
  ///
  /// [rollbackWhen] is called with the real server response data. Return `true` to
  /// automatically undo the optimistic write (e.g. when the server signals an
  /// error via the data payload). Defaults to no auto-rollback. Only called if
  /// the response is successful [GraphQLData].
  ///
  /// The returned [OptimisticMutationResponse] exposes:
  /// - [OptimisticMutationResponse.response] — the typed server response
  /// - [OptimisticMutationResponse.wasRolledBack] — whether auto-rollback fired
  /// - [OptimisticMutationResponse.rollback()] — async rollback (idempotent)
  Future<OptimisticMutationResponse<AddGifToAlbumMutationData>>
  executeOptimistic(
    AddGifToAlbumMutationData Function(AddGifToAlbumMutationVariables vars)
    optimisticFactory, {
    bool Function(AddGifToAlbumMutationData response)? rollbackWhen,
    required String albumId,
    required shalom_core.Maybe<String?> previewUrl,
    required String title,
    required String url,
  }) async {
    final vars = AddGifToAlbumMutationVariables(
      albumId: albumId,
      previewUrl: previewUrl,
      title: title,
      url: url,
    );
    final writeId = await _client.writeOptimistic(
      name: operation$Name(),
      data: optimisticFactory(vars).toJson(),
    );

    var rolledBack = false;
    Future<void> doRollback() async {
      if (rolledBack) return;
      rolledBack = true;
      await _client.rollbackOptimistic(writeId);
    }

    try {
      final graphqlResponse = await _client.mutate<AddGifToAlbumMutationData>(
        name: operation$Name(),

        variables: vars.toJson(),

        decoder: AddGifToAlbumMutationData.fromCache,
      );
      if (graphqlResponse case shalom_core.GraphQLData(
        data: final responseData,
      )) {
        if (rollbackWhen?.call(responseData) ?? false) await doRollback();
      }
      return OptimisticMutationResponse(
        response: graphqlResponse,
        wasRolledBack: rolledBack,
        client: _client,
        writeId: writeId,
      );
    } catch (e) {
      await doRollback();
      rethrow;
    }
  }
}
