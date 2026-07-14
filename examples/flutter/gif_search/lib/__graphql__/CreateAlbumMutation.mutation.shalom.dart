// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'CreateAlbumMutation.shalom.dart';

import 'dart:async' show FutureOr;
import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom/shalom.dart' show OptimisticMutationResponse, CacheProxy;
import 'CreateAlbumMutation.shalom.dart';

abstract class $CreateAlbumMutation {
  String operation$Name() => 'CreateAlbumMutation';

  final shalom_core.ShalomRuntimeClient _client;
  const $CreateAlbumMutation(this._client);

  /// Execute the mutation and return the normalised response.
  /// The response is written into the shared entity cache, triggering reactive
  /// updates on any query subscriptions watching the same entities.
  Future<shalom_core.GraphQLResponse<CreateAlbumMutationData>> execute({
    required String name,
  }) => _client.mutate<CreateAlbumMutationData>(
    name: operation$Name(),

    variables: CreateAlbumMutationVariables(name: name).toJson(),

    decoder: CreateAlbumMutationData.fromCache,
  );

  /// Execute the mutation and update the cache via [update].
  ///
  /// [update] receives a [CacheProxy] and the typed mutation response data.
  /// It's only called if the mutation returns successful data.
  /// Use [CacheProxy.readOperation] / [CacheProxy.writeOperation] to read the current
  /// cached value of any query and write back a modified version — the typical
  /// pattern for keeping lists in sync after an add / remove / reorder mutation.
  ///
  /// Example:
  /// ```dart
  /// await addTodo.executeWithCacheUpdate(
  ///   input: AddTodoInput(title: 'Buy milk'),
  ///   update: (cache, data) async {
  ///     final current = await cache.readOperation(
  ///       name: 'GetTodos',
  ///       decoder: GetTodosData.fromCache,
  ///     );
  ///     if (current != null) {
  ///       await cache.writeOperation(
  ///         data: GetTodosData(todos: [...current.todos, data.addTodo!]),
  ///       );
  ///     }
  ///   },
  /// );
  /// ```
  Future<shalom_core.GraphQLResponse<CreateAlbumMutationData>>
  executeWithCacheUpdate({
    required String name,
    required FutureOr<void> Function(
      CacheProxy cache,
      CreateAlbumMutationData data,
    )
    update,
  }) async {
    final vars = CreateAlbumMutationVariables(name: name);

    final response = await _client.mutate<CreateAlbumMutationData>(
      name: operation$Name(),

      variables: vars.toJson(),

      decoder: CreateAlbumMutationData.fromCache,
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
  /// predicted [CreateAlbumMutationData]. This is written to the cache so that
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
  Future<OptimisticMutationResponse<CreateAlbumMutationData>> executeOptimistic(
    CreateAlbumMutationData Function(CreateAlbumMutationVariables vars)
    optimisticFactory, {
    bool Function(CreateAlbumMutationData response)? rollbackWhen,
    required String name,
  }) async {
    final vars = CreateAlbumMutationVariables(name: name);
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
      final graphqlResponse = await _client.mutate<CreateAlbumMutationData>(
        name: operation$Name(),

        variables: vars.toJson(),

        decoder: CreateAlbumMutationData.fromCache,
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
