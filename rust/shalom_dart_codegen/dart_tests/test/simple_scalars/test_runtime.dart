// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';

import '../helpers/mock_link.dart';
import '__graphql__/GetBoolean.shalom.dart';
import '__graphql__/GetBooleanOptional.shalom.dart';
import '__graphql__/GetFloat.shalom.dart';
import '__graphql__/GetFloatOptional.shalom.dart';
import '__graphql__/GetID.shalom.dart';
import '__graphql__/GetIDOptional.shalom.dart';
import '__graphql__/GetInt.shalom.dart';
import '__graphql__/GetIntOptional.shalom.dart';
import '__graphql__/GetString.shalom.dart';
import '__graphql__/GetStringOptional.shalom.dart';

const _schemaSdl = '''
type Query {
  intField: Int!
  intOptional: Int
  string: String!
  stringOptional: String
  idField: ID!
  idOptional: ID
  float: Float!
  floatOptional: Float
  boolean: Boolean!
  booleanOptional: Boolean
}
''';

// Queries use @subscribeable so the Rust runtime injects __used_refs into
// responses, enabling cache-update subscriptions.
const _qGetString = 'query GetString @subscribeable { string }';
const _qGetStringOptional =
    'query GetStringOptional @subscribeable { stringOptional }';
const _qGetInt = 'query GetInt @subscribeable { intField }';
const _qGetIntOptional = 'query GetIntOptional @subscribeable { intOptional }';
const _qGetFloat = 'query GetFloat @subscribeable { float }';
const _qGetFloatOptional =
    'query GetFloatOptional @subscribeable { floatOptional }';
const _qGetBoolean = 'query GetBoolean @subscribeable { boolean }';
const _qGetBooleanOptional =
    'query GetBooleanOptional @subscribeable { booleanOptional }';
const _qGetID = 'query GetID @subscribeable { idField }';
const _qGetIDOptional = 'query GetIDOptional @subscribeable { idOptional }';

Future<ShalomRuntimeClient> _makeClient(
  List<GraphQLResponse<JsonObject>> responses,
) {
  return ShalomRuntimeClient.init(
    schemaSdl: _schemaSdl,
    fragmentSdls: [],
    link: MockGraphQLLink(responses),
  );
}

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('Scalars Cache Normalization via Rust Runtime', () {
    test('String scalar update propagates through cache', () async {
      final client = await _makeClient([
        GraphQLData(data: {'string': 'initial'}),
        GraphQLData(data: {'string': 'updated'}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetString,
        fromCache: GetStringResponse.cacheBuilder,
      );
      expect(initial.data.string, 'initial');
      expect(initial.refs, isNotEmpty);

      final updates = await client.setupSubscription(
        fromCache: GetStringResponse.cacheBuilder,
        refs: initial.refs,
      );

      // Trigger second request — Rust normalizes new response into cache,
      // which fires the subscription.
      unawaited(
        client.requestTyped(
          query: _qGetString,
          fromCache: GetStringResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.string, 'updated');

      await client.dispose();
    });

    test('StringOptional scalar update propagates (non-null → non-null)',
        () async {
      final client = await _makeClient([
        GraphQLData(data: {'stringOptional': 'hello'}),
        GraphQLData(data: {'stringOptional': 'world'}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetStringOptional,
        fromCache: GetStringOptionalResponse.cacheBuilder,
      );
      expect(initial.data.stringOptional, 'hello');

      final updates = await client.setupSubscription(
        fromCache: GetStringOptionalResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetStringOptional,
          fromCache: GetStringOptionalResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.stringOptional, 'world');

      await client.dispose();
    });

    test('StringOptional scalar update propagates (non-null → null)', () async {
      final client = await _makeClient([
        GraphQLData(data: {'stringOptional': 'something'}),
        GraphQLData(data: {'stringOptional': null}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetStringOptional,
        fromCache: GetStringOptionalResponse.cacheBuilder,
      );
      expect(initial.data.stringOptional, 'something');

      final updates = await client.setupSubscription(
        fromCache: GetStringOptionalResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetStringOptional,
          fromCache: GetStringOptionalResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.stringOptional, isNull);

      await client.dispose();
    });

    test('Int scalar update propagates through cache', () async {
      final client = await _makeClient([
        GraphQLData(data: {'intField': 1}),
        GraphQLData(data: {'intField': 42}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetInt,
        fromCache: GetIntResponse.cacheBuilder,
      );
      expect(initial.data.intField, 1);

      final updates = await client.setupSubscription(
        fromCache: GetIntResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetInt,
          fromCache: GetIntResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.intField, 42);

      await client.dispose();
    });

    test('Float scalar update propagates through cache', () async {
      final client = await _makeClient([
        GraphQLData(data: {'float': 1.1}),
        GraphQLData(data: {'float': 9.9}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetFloat,
        fromCache: GetFloatResponse.cacheBuilder,
      );
      expect(initial.data.float, 1.1);

      final updates = await client.setupSubscription(
        fromCache: GetFloatResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetFloat,
          fromCache: GetFloatResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.float, 9.9);

      await client.dispose();
    });

    test('Boolean scalar update propagates through cache', () async {
      final client = await _makeClient([
        GraphQLData(data: {'boolean': true}),
        GraphQLData(data: {'boolean': false}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetBoolean,
        fromCache: GetBooleanResponse.cacheBuilder,
      );
      expect(initial.data.boolean, true);

      final updates = await client.setupSubscription(
        fromCache: GetBooleanResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetBoolean,
          fromCache: GetBooleanResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.boolean, false);

      await client.dispose();
    });

    test('ID scalar update propagates through cache', () async {
      final client = await _makeClient([
        GraphQLData(data: {'idField': 'id-1'}),
        GraphQLData(data: {'idField': 'id-2'}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetID,
        fromCache: GetIDResponse.cacheBuilder,
      );
      expect(initial.data.idField, 'id-1');

      final updates = await client.setupSubscription(
        fromCache: GetIDResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetID,
          fromCache: GetIDResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.idField, 'id-2');

      await client.dispose();
    });

    test('IntOptional propagates null update', () async {
      final client = await _makeClient([
        GraphQLData(data: {'intOptional': 10}),
        GraphQLData(data: {'intOptional': null}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetIntOptional,
        fromCache: GetIntOptionalResponse.cacheBuilder,
      );
      expect(initial.data.intOptional, 10);

      final updates = await client.setupSubscription(
        fromCache: GetIntOptionalResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetIntOptional,
          fromCache: GetIntOptionalResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.intOptional, isNull);

      await client.dispose();
    });

    test('BooleanOptional propagates null update', () async {
      final client = await _makeClient([
        GraphQLData(data: {'booleanOptional': true}),
        GraphQLData(data: {'booleanOptional': null}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetBooleanOptional,
        fromCache: GetBooleanOptionalResponse.cacheBuilder,
      );
      expect(initial.data.booleanOptional, true);

      final updates = await client.setupSubscription(
        fromCache: GetBooleanOptionalResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetBooleanOptional,
          fromCache: GetBooleanOptionalResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.booleanOptional, isNull);

      await client.dispose();
    });

    test('FloatOptional propagates null update', () async {
      final client = await _makeClient([
        GraphQLData(data: {'floatOptional': 3.14}),
        GraphQLData(data: {'floatOptional': null}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetFloatOptional,
        fromCache: GetFloatOptionalResponse.cacheBuilder,
      );
      expect(initial.data.floatOptional, 3.14);

      final updates = await client.setupSubscription(
        fromCache: GetFloatOptionalResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetFloatOptional,
          fromCache: GetFloatOptionalResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.floatOptional, isNull);

      await client.dispose();
    });

    test('IDOptional propagates null update', () async {
      final client = await _makeClient([
        GraphQLData(data: {'idOptional': 'some-id'}),
        GraphQLData(data: {'idOptional': null}),
      ]);

      final initial = await client.requestTyped(
        query: _qGetIDOptional,
        fromCache: GetIDOptionalResponse.cacheBuilder,
      );
      expect(initial.data.idOptional, 'some-id');

      final updates = await client.setupSubscription(
        fromCache: GetIDOptionalResponse.cacheBuilder,
        refs: initial.refs,
      );

      unawaited(
        client.requestTyped(
          query: _qGetIDOptional,
          fromCache: GetIDOptionalResponse.cacheBuilder,
        ),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated.idOptional, isNull);

      await client.dispose();
    });
  });
}
