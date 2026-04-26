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
// Inline mock link.
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
// Schema.
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
  pet: Pet
}

type Pet {
  id: ID!
  name: String!
}

type Post {
  id: ID!
  title: String!
}
''';

// ---------------------------------------------------------------------------
// Requestables.
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

  // -------------------------------------------------------------------------
  // 2. request() returns normalized data from the network (NetworkFirst).
  // -------------------------------------------------------------------------
  test('request returns normalized data from network', () async {
    final client = await _makeClient([
      GraphQLData(
        data: {
          'user': {'id': '1', 'name': 'Alice'},
        },
      ),
    ]);

    const requestable = _UserRequestable(
      'GetUser',
      'query GetUser @observe { user(id: "1") { id name } }',
    );

    final data = await client.request(requestable: requestable).first;

    expect(data['id'], '1');
    expect(data['name'], 'Alice');

    await client.dispose();
  });

  // -------------------------------------------------------------------------
  // 3. Two operations sharing the same entity DO trigger a subscription update.
  // -------------------------------------------------------------------------
  test(
    'two operations for the same entity update a @observe subscription',
    () async {
      final client = await _makeClient([
        GraphQLData(
          data: {
            'user': {'id': '1', 'name': 'Alice'},
          },
        ),
        GraphQLData(
          data: {
            'user': {'id': '1', 'name': 'Bob'},
          },
        ),
      ]);

      const reqGetUser = _UserRequestable(
        'GetUser',
        'query GetUser @observe { user(id: "1") { id name } }',
      );
      const reqGetUserDetails = _UserRequestable(
        'GetUserDetails',
        'query GetUserDetails @observe { user(id: "1") { id name } }',
      );

      // Collect up to 2 emissions from the GetUser stream.
      final results = <Map<String, dynamic>>[];
      final secondReceived = Completer<void>();

      final sub = client.request(requestable: reqGetUser).listen((data) {
        results.add(data);
        if (results.length == 1) {
          // First emission (Alice) received — now trigger the second write.
          unawaited(
            client.request(requestable: reqGetUserDetails).first,
          );
        } else if (results.length >= 2) {
          if (!secondReceived.isCompleted) secondReceived.complete();
        }
      });

      await secondReceived.future.timeout(const Duration(seconds: 5));
      await sub.cancel();

      expect(results[0]['name'], 'Alice');
      expect(results[1]['name'], 'Bob');

      await client.dispose();
    },
  );

  // -------------------------------------------------------------------------
  // 4. Two unrelated operations do NOT cross-trigger subscriptions.
  // -------------------------------------------------------------------------
  test('two unrelated operations do not cross-trigger subscriptions', () async {
    final client = await _makeClient([
      GraphQLData(
        data: {
          'user': {'id': '1', 'name': 'Alice'},
        },
      ),
      GraphQLData(
        data: {
          'post': {'id': '1', 'title': 'Hello World'},
        },
      ),
    ]);

    const reqGetUser = _UserRequestable(
      'GetUser',
      'query GetUser @observe { user(id: "1") { id name } }',
    );
    const reqGetPost = _PostRequestable(
      'query GetPost @observe { post(id: "1") { id title } }',
    );

    // Keep the user stream alive with listen() so the cache subscription stays
    // registered while we trigger the unrelated Post write.
    final firstReceived = Completer<void>();
    bool gotUpdate = false;
    final sub = client.request(requestable: reqGetUser).listen((data) {
      if (!firstReceived.isCompleted) {
        firstReceived.complete(); // initial network response
      } else {
        gotUpdate = true; // any subsequent cache update would be a bug
      }
    });

    await firstReceived.future.timeout(const Duration(seconds: 5));

    // Trigger an unrelated Post write.
    await client.request(requestable: reqGetPost).first;

    await Future<void>.delayed(const Duration(milliseconds: 100));
    await sub.cancel();

    expect(
      gotUpdate,
      isFalse,
      reason: 'Post write should not trigger User subscription',
    );

    await client.dispose();
  });

  // -------------------------------------------------------------------------
  // 5. subscribeToFragment fires when a @observe fragment's entity
  //    is updated by a subsequent operation.
  //
  // The fragment is inlined in the operation document so the GraphQL validator
  // accepts it. The subscription tracks the Pet entity by its cache key.
  // -------------------------------------------------------------------------
  test('subscribeToFragment fires when fragment entity is updated', () async {
    const petFragDef = '''
      fragment PetFrag on Pet @observe {
        id
        name
      }
    ''';
    const getUserQuery = '''
      $petFragDef
      query GetUser @observe {
        user(id: "1") {
          id
          name
          pet { ...PetFrag }
        }
      }
    ''';

    final client = await _makeClient([
      GraphQLData(
        data: {
          'user': {
            'id': '1',
            'name': 'Alice',
            'pet': {'id': '14', 'name': 'Rex'},
          },
        },
      ),
      GraphQLData(
        data: {
          'user': {
            'id': '1',
            'name': 'Alice',
            'pet': {'id': '14', 'name': 'Max'},
          },
        },
      ),
    ]);

    const reqGetUser = _UserRequestable('GetUser', getUserQuery);

    // Fetch initial data.
    final userMap = await client
        .request(requestable: reqGetUser)
        .first
        .timeout(const Duration(seconds: 5));

    final petData = userMap['pet'] as Map<String, dynamic>?;
    expect(petData, isNotNull, reason: 'pet should be in response');
    expect(petData!['name'], 'Rex');

    // Set up fragment subscription using the known cache key.
    // Pet entities are normalized as "Pet:<id>".
    final petUpdates = client.subscribeToFragment<Map<String, dynamic>>(
      fragmentName: 'PetFrag',
      anchor: 'Pet:14',
      parseFn: (data) => data,
    );

    // Trigger the second fetch (updates Pet:14.name to "Max").
    unawaited(client.request(requestable: reqGetUser).first);

    final updatedPet = await petUpdates.first.timeout(const Duration(seconds: 5));
    expect(updatedPet['name'], 'Max');

    await client.dispose();
  });
}
