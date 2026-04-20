import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:shalom/shalom.dart';
import 'package:shalom/shalom.dart' as shalom;
import 'package:test/test.dart';

String get _nativeLibPath {
  if (Platform.isLinux) return '.dart_tool/lib/libshalom_ffi.so';
  if (Platform.isMacOS) return '.dart_tool/lib/libshalom_ffi.dylib';
  if (Platform.isWindows) return '.dart_tool/lib/shalom_ffi.dll';
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

// ---------------------------------------------------------------------------
// Inline mock link — no codegen helpers needed in this package.
// ---------------------------------------------------------------------------

class _MockLink extends GraphQLLink {
  final Queue<GraphQLResponse<JsonObject>> _queue;

  _MockLink(List<GraphQLResponse<JsonObject>> responses)
    : _queue = Queue.from(responses);

  @override
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  }) {
    if (_queue.isEmpty) {
      throw StateError(
        '_MockLink: no more responses queued for ${request.opName}',
      );
    }
    return Stream.value(_queue.removeFirst());
  }
}

// ---------------------------------------------------------------------------
// Schema used by all tests.
//
// User has an `id` field => entity key = "User:<id>" in the normalized cache.
// Post  has an `id` field => entity key = "Post:<id>".
// ---------------------------------------------------------------------------

const _schemaSdl = '''
type Query {
  user(id: ID!): User
  post(id: ID!): Post
  version: String!
}

type User {
  id: ID!
  name: String!
}

type Post {
  id: ID!
  title: String!
}
''';

// ---------------------------------------------------------------------------
// Requestable implementations used for tests 2-4.
// ---------------------------------------------------------------------------

class _UserRequestable extends Requestable<Map<String, dynamic>> {
  final String opName;
  final String query;

  const _UserRequestable(this.opName, this.query);

  @override
  RequestMeta<Map<String, dynamic>> getRequestMeta() => RequestMeta(
    request: Request(
      query: query,
      variables: {},
      opType: OperationType.Query,
      opName: opName,
    ),
    parseFn: (data) => (data['user'] as Map<String, dynamic>?) ?? {},
  );
}

class _PostRequestable extends Requestable<Map<String, dynamic>> {
  final String query;

  const _PostRequestable(this.query);

  @override
  RequestMeta<Map<String, dynamic>> getRequestMeta() => RequestMeta(
    request: Request(
      query: query,
      variables: {},
      opType: OperationType.Query,
      opName: 'GetPost',
    ),
    parseFn: (data) => (data['post'] as Map<String, dynamic>?) ?? {},
  );
}

// ---------------------------------------------------------------------------
// Helpers.
// ---------------------------------------------------------------------------

Future<ShalomRuntimeClient> _makeClient(
  List<GraphQLResponse<JsonObject>> responses,
) {
  return ShalomRuntimeClient.init(
    schemaSdl: _schemaSdl,
    fragmentSdls: [],
    link: _MockLink(responses),
  );
}

// ---------------------------------------------------------------------------
// Tests.
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() async {
    await shalom.init(_nativeLibPath);
  });

  test('runtime initialises without error', () async {
    final client = await _makeClient([]);
    await client.dispose();
  });

  test('requestTyped returns normalized data from cache', () async {
    final client = await _makeClient([
      GraphQLData(
        data: {
          'user': {'id': '1', 'name': 'Alice'},
        },
      ),
    ]);

    const requestable = _UserRequestable(
      'GetUser',
      'query GetUser @subscribeable { user(id: "1") { id name } }',
    );

    final result = await client.requestTyped(requestable: requestable);

    expect(result.data['id'], '1');
    expect(result.data['name'], 'Alice');
    // @subscribeable ensures __used_refs are injected.
    expect(result.refs, isNotEmpty);

    await client.dispose();
  });

  // -------------------------------------------------------------------------
  // 3. Two operations sharing the same entity DO trigger a subscription update.
  //
  // GetUser and GetUserDetails both return user id="1". Because entity-key
  // normalization merges them into the same "User:1" cache entry, a second
  // write (from GetUserDetails) mutates keys that GetUser's subscription
  // watches, and the subscription fires.
  // -------------------------------------------------------------------------
  test(
    'two operations for the same entity update a @subscribeable subscription',
    () async {
      final client = await _makeClient([
        // First request (GetUser) — initial data.
        GraphQLData(
          data: {
            'user': {'id': '1', 'name': 'Alice'},
          },
        ),
        // Second request (GetUserDetails) — updated name on the same entity.
        GraphQLData(
          data: {
            'user': {'id': '1', 'name': 'Bob'},
          },
        ),
      ]);

      const reqGetUser = _UserRequestable(
        'GetUser',
        'query GetUser @subscribeable { user(id: "1") { id name } }',
      );
      const reqGetUserDetails = _UserRequestable(
        'GetUserDetails',
        'query GetUserDetails @subscribeable { user(id: "1") { id name } }',
      );

      // Normalize the first response into the cache.
      final initial = await client.requestTyped(requestable: reqGetUser);
      expect(initial.data['name'], 'Alice');
      expect(initial.refs, isNotEmpty);

      // Set up subscription BEFORE the second write so we don't miss the update.
      final updates = client.subscribeToRefs(
        requestable: reqGetUser,
        refs: initial.refs,
      );

      // Fire the second operation. It writes to the same "User:1" entity.
      unawaited(
        client.requestTyped(requestable: reqGetUserDetails),
      );

      final updated = await updates.first.timeout(const Duration(seconds: 5));
      expect(updated['name'], 'Bob');

      await client.dispose();
    },
  );

  // -------------------------------------------------------------------------
  // 4. Two unrelated operations do NOT trigger each other's subscription.
  //
  // GetUser watches "User:1" entity keys. GetPost writes to "Post:1" entity
  // keys. These sets are disjoint => the GetUser subscription must NOT fire.
  // -------------------------------------------------------------------------
  test('two unrelated operations do not cross-trigger subscriptions', () async {
    final client = await _makeClient([
      // GetUser — sets up the subscription we are watching.
      GraphQLData(
        data: {
          'user': {'id': '1', 'name': 'Alice'},
        },
      ),
      // GetPost — a completely different entity; should NOT wake GetUser.
      GraphQLData(
        data: {
          'post': {'id': '1', 'title': 'Hello World'},
        },
      ),
    ]);

    const reqGetUser = _UserRequestable(
      'GetUser',
      'query GetUser @subscribeable { user(id: "1") { id name } }',
    );
    const reqGetPost = _PostRequestable(
      'query GetPost @subscribeable { post(id: "1") { id title } }',
    );

    // Normalize the user response.
    final initial = await client.requestTyped(requestable: reqGetUser);
    expect(initial.refs, isNotEmpty);

    final updates = client.subscribeToRefs(
      requestable: reqGetUser,
      refs: initial.refs,
    );

    // Normalize a Post — unrelated entity. Must run BEFORE subscribing to
    // `updates`: FRB holds the handle lock for the entire listen_updates
    // async function, so starting the listener first would deadlock requestTyped.
    // The Rust subscription is already registered and its channel is live, so
    // any incorrect notification is buffered and detected after we subscribe.
    await client.requestTyped(requestable: reqGetPost);

    // Now subscribe and check: no buffered update should be present.
    // Do NOT await sub.cancel() — that waits for the Rust listen_updates loop
    // to exit, which blocks until the subscription channel receives data.
    // Instead cancel without awaiting (mirroring how Stream.first works).
    bool gotUpdate = false;
    final sub = updates.listen((_) => gotUpdate = true);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await sub.cancel();

    expect(
      gotUpdate,
      isFalse,
      reason: 'Post write should not trigger User subscription',
    );

    await client.dispose();
  });
}
