



// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'CreateAlbumMutation.shalom.dart';

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart' show OptimisticMutationResponse;
import 'CreateAlbumMutation.shalom.dart';

abstract class $CreateAlbumMutation {
    final shalom_core.ShalomRuntimeClient _client;
    const $CreateAlbumMutation(this._client);

    /// Execute the mutation and return the normalised response.
    /// The response is written into the shared entity cache, triggering reactive
    /// updates on any query subscriptions watching the same entities.
    Future<CreateAlbumMutationData> execute({
        required String name,
        }) => _client.mutate<CreateAlbumMutationData>(
        name: 'CreateAlbumMutation',
        
        variables: CreateAlbumMutationVariables(
            name: name,
            ).toJson(),
        
        decoder: CreateAlbumMutationData.fromCache,
    );

    /// Execute the mutation with an optimistic cache write applied immediately,
    /// before the network response arrives.
    ///
    /// [optimisticFactory] receives the mutation variables and must return a
    /// predicted [CreateAlbumMutationData]. This is written to the cache so that
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
    Future<OptimisticMutationResponse<CreateAlbumMutationData>> executeOptimistic(
        CreateAlbumMutationData Function(CreateAlbumMutationVariables vars) optimisticFactory, {
        bool Function(CreateAlbumMutationData response)? rollbackWhen,
        required String name,
        }) async {
        
        final vars = CreateAlbumMutationVariables(
            name: name,
            );
        final writeId = await _client.writeOptimistic(
            name: 'CreateAlbumMutation',
            data: optimisticFactory(vars).toJson(),
        );
        
        var rolledBack = false;
        void doRollback() {
            if (rolledBack) return;
            rolledBack = true;
            _client.rollbackOptimistic(writeId);
        }
        try {
            final response = await _client.mutate<CreateAlbumMutationData>(
                name: 'CreateAlbumMutation',
                
                variables: vars.toJson(),
                
                decoder: CreateAlbumMutationData.fromCache,
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