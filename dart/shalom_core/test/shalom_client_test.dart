import 'dart:async';
import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';

/// Fake GraphQL Link that allows controlling when responses are emitted
class FakeGraphQLLink extends GraphQLLink {
  final StreamController<GraphQLResponse<JsonObject>> _controller =
      StreamController<GraphQLResponse<JsonObject>>.broadcast();

  @override
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  }) {
    return _controller.stream;
  }

  void emitData(JsonObject data) {
    _controller.add(GraphQLData(data: data));
  }

  void emitError(List<JsonObject> errors) {
    _controller.add(GraphQLError(errors: errors));
  }

  void close() {
    _controller.close();
  }
}

/// Test requestable implementation
class TestRequestable<T> implements Requestable<T> {
  final Request request;
  final (T, Set<String>) Function(JsonObject data, ShalomCtx ctx) loader;
  final (T, Set<String>) Function(ShalomCtx ctx) cacheReader;

  TestRequestable({
    required this.request,
    required this.loader,
    required this.cacheReader,
  });

  @override
  Request toRequest() => request;

  @override
  RequestMeta<T> getRequestMeta() {
    return RequestMeta(
      request: request,
      loadFn: ({required JsonObject data, required ShalomCtx ctx}) =>
          loader(data, ctx),
      fromCacheFn: (ShalomCtx ctx) => cacheReader(ctx),
    );
  }
}

void main() {
  group('ShalomClient', () {
    late ShalomCtx ctx;
    late FakeGraphQLLink link;
    late ShalomClient client;

    setUp(() {
      ctx = ShalomCtx.withCapacity();
      link = FakeGraphQLLink();
      client = ShalomClient(ctx: ctx, link: link);
    });

    tearDown(() {
      // Link is closed in individual tests before cancel
    });

    test('receives initial data from link', () async {
      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) {
          return ({'userId': data['user']['id']}, {});
        },
        cacheReader: (ctx) {
          return ({'userId': 'cached'}, {});
        },
      );

      final responses = <GraphQLResponse<Map<String, dynamic>>>[];
      final subscription = client
          .request(requestable: requestable)
          .listen((response) => responses.add(response));

      // Emit initial data
      link.emitData({
        'user': {'id': '123'}
      });

      await Future.delayed(Duration(milliseconds: 100));

      expect(responses.length, 1);
      expect(responses[0], isA<GraphQLData>());
      final data = responses[0] as GraphQLData;
      expect(data.data['userId'], '123');

      link.close();
      await subscription.cancel();
    });

    test('receives cache updates after initial load', () async {
      const cacheKey = 'User:123';

      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id name } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) {
          // Write to cache
          ctx.insertToCache(cacheKey, data['user'] as JsonObject);
          return (
            {'userId': data['user']['id'], 'userName': data['user']['name']},
            {cacheKey}
          );
        },
        cacheReader: (ctx) {
          final cached = ctx.getCachedRecord(cacheKey);
          return (
            {
              'userId': cached?['id'] ?? 'unknown',
              'userName': cached?['name'] ?? 'unknown'
            },
            {cacheKey}
          );
        },
      );

      final responses = <GraphQLResponse<Map<String, dynamic>>>[];
      final subscription = client
          .request(requestable: requestable)
          .listen((response) => responses.add(response));

      // Emit initial data
      link.emitData({
        'user': {'id': '123', 'name': 'Alice'}
      });

      await Future.delayed(Duration(milliseconds: 100));

      // Update cache (simulating another query/mutation)
      ctx.insertToCache(cacheKey, {
        'id': '123',
        'name': 'Alice Updated',
      });
      ctx.invalidateRefs({cacheKey});

      await Future.delayed(Duration(milliseconds: 100));

      expect(responses.length, 2);

      // First response from link
      expect(responses[0], isA<GraphQLData>());
      final firstData = responses[0] as GraphQLData;
      expect(firstData.data['userName'], 'Alice');

      // Second response from cache
      expect(responses[1], isA<GraphQLData>());
      final secondData = responses[1] as GraphQLData;
      expect(secondData.data['userName'], 'Alice Updated');

      link.close();
      await subscription.cancel();
    });

    test('requestOnce returns only initial data without cache subscription',
        () async {
      const cacheKey = 'User:123';

      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id name } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) {
          ctx.insertToCache(cacheKey, data['user'] as JsonObject);
          return (
            {'userId': data['user']['id'], 'userName': data['user']['name']},
            {cacheKey}
          );
        },
        cacheReader: (ctx) {
          final cached = ctx.getCachedRecord(cacheKey);
          return (
            {
              'userId': cached?['id'] ?? 'unknown',
              'userName': cached?['name'] ?? 'unknown'
            },
            {cacheKey}
          );
        },
      );

      // Start requestOnce
      final responseFuture = client.requestOnce(requestable: requestable);

      // Emit data
      link.emitData({
        'user': {'id': '123', 'name': 'Alice'}
      });

      final response = await responseFuture;

      expect(response, isA<GraphQLData>());
      final data = response as GraphQLData;
      expect(data.data['userName'], 'Alice');

      // Update cache - should not trigger any response
      ctx.insertToCache(cacheKey, {
        'id': '123',
        'name': 'Alice Updated',
      });
      ctx.invalidateRefs({cacheKey});

      await Future.delayed(Duration(milliseconds: 100));

      // requestOnce should have already completed, so no updates expected
      // (This test just verifies no errors occur)

      link.close();
    });

    test('receives concurrent updates from both link and cache', () async {
      const cacheKey = 'User:123';

      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'subscription { userUpdated { id name } }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'UserSubscription',
        ),
        loader: (data, ctx) {
          // Write to cache
          ctx.insertToCache(cacheKey, data['userUpdated'] as JsonObject);
          return (
            {
              'userId': data['userUpdated']['id'],
              'userName': data['userUpdated']['name'],
              'source': 'link'
            },
            {cacheKey}
          );
        },
        cacheReader: (ctx) {
          final cached = ctx.getCachedRecord(cacheKey);
          return (
            {
              'userId': cached?['id'] ?? 'unknown',
              'userName': cached?['name'] ?? 'unknown',
              'source': 'cache'
            },
            {cacheKey}
          );
        },
      );

      final responses = <GraphQLResponse<Map<String, dynamic>>>[];
      final subscription = client
          .request(requestable: requestable)
          .listen((response) => responses.add(response));

      // Emit first subscription event
      link.emitData({
        'userUpdated': {'id': '123', 'name': 'Alice'}
      });

      await Future.delayed(Duration(milliseconds: 100));

      // Update cache (simulating another operation)
      ctx.insertToCache(cacheKey, {
        'id': '123',
        'name': 'Alice Modified',
      });
      ctx.invalidateRefs({cacheKey});

      await Future.delayed(Duration(milliseconds: 100));

      // Emit second subscription event - this should still work!
      // This is the KEY test - link should NOT be blocked by cache subscription
      link.emitData({
        'userUpdated': {'id': '123', 'name': 'Alice from Subscription'}
      });

      await Future.delayed(Duration(milliseconds: 100));

      // Update cache again
      ctx.insertToCache(cacheKey, {
        'id': '123',
        'name': 'Alice Final',
      });
      ctx.invalidateRefs({cacheKey});

      await Future.delayed(Duration(milliseconds: 100));

      // Should have 4 responses total
      expect(responses.length, 4,
          reason: 'Should receive all updates from both link and cache');

      // First: from link
      expect((responses[0] as GraphQLData).data['userName'], 'Alice');
      expect((responses[0] as GraphQLData).data['source'], 'link');

      // Second: from cache
      expect((responses[1] as GraphQLData).data['userName'], 'Alice Modified');
      expect((responses[1] as GraphQLData).data['source'], 'cache');

      // Third: from link again (this proves link is NOT blocked!)
      expect((responses[2] as GraphQLData).data['userName'],
          'Alice from Subscription');
      expect((responses[2] as GraphQLData).data['source'], 'link');

      // Fourth: from cache again
      expect((responses[3] as GraphQLData).data['userName'], 'Alice Final');
      expect((responses[3] as GraphQLData).data['source'], 'cache');

      link.close();
      await subscription.cancel();
    });

    test('handles changing cache dependencies', () async {
      const initialKey = 'User:123';
      const newKey = 'User:456';

      var useNewKey = false;

      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) {
          final userId = data['user']['id'] as String;
          final key = 'User:$userId';
          ctx.insertToCache(key, data['user'] as JsonObject);
          return ({'userId': userId, 'key': key}, {key});
        },
        cacheReader: (ctx) {
          final key = useNewKey ? newKey : initialKey;
          final cached = ctx.getCachedRecord(key);
          return (
            {
              'userId': cached?['id'] ?? 'unknown',
              'key': key,
            },
            {key}
          );
        },
      );

      final responses = <GraphQLResponse<Map<String, dynamic>>>[];
      final subscription = client
          .request(requestable: requestable)
          .listen((response) => responses.add(response));

      // Emit initial data for user 123
      link.emitData({
        'user': {'id': '123'}
      });

      await Future.delayed(Duration(milliseconds: 100));

      // Update user 123 - should trigger cache update
      ctx.insertToCache(initialKey, {'id': '123'});
      ctx.invalidateRefs({initialKey});

      await Future.delayed(Duration(milliseconds: 100));

      // Change to use new key
      useNewKey = true;

      // Update user 456 - should trigger cache update with new key
      ctx.insertToCache(newKey, {'id': '456'});
      ctx.invalidateRefs({newKey});

      await Future.delayed(Duration(milliseconds: 100));

      // Update user 123 - should NOT trigger cache update (we unsubscribed)
      ctx.insertToCache(initialKey, {'id': '123'});
      ctx.invalidateRefs({initialKey});

      await Future.delayed(Duration(milliseconds: 100));

      // Should have 3 responses: initial, cache update for 123, cache update for 456
      expect(responses.length, 3);
      expect((responses[0] as GraphQLData).data['key'], initialKey);
      expect((responses[1] as GraphQLData).data['key'], initialKey);
      expect((responses[2] as GraphQLData).data['key'], newKey);

      link.close();
      await subscription.cancel();
    });

    test('requestOnce returns only initial data without cache subscription',
        () async {
      const cacheKey = 'User:123';

      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id name } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) {
          ctx.insertToCache(cacheKey, data['user'] as JsonObject);
          return (
            {'userId': data['user']['id'], 'userName': data['user']['name']},
            {cacheKey}
          );
        },
        cacheReader: (ctx) {
          final cached = ctx.getCachedRecord(cacheKey);
          return (
            {
              'userId': cached?['id'] ?? 'unknown',
              'userName': cached?['name'] ?? 'unknown'
            },
            {cacheKey}
          );
        },
      );

      // Start requestOnce
      final responseFuture = client.requestOnce(requestable: requestable);

      // Emit data
      link.emitData({
        'user': {'id': '123', 'name': 'Alice'}
      });

      final response = await responseFuture;

      expect(response, isA<GraphQLData>());
      final data = response as GraphQLData;
      expect(data.data['userName'], 'Alice');

      // Update cache - should not trigger any response
      ctx.insertToCache(cacheKey, {
        'id': '123',
        'name': 'Alice Updated',
      });
      ctx.invalidateRefs({cacheKey});

      await Future.delayed(Duration(milliseconds: 100));

      // requestOnce should have already completed, so no updates expected
      // (This test just verifies no errors occur)
    });

    test('forwards GraphQL errors from link', () async {
      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) => ({}, {}),
        cacheReader: (ctx) => ({}, {}),
      );

      final responses = <GraphQLResponse<Map<String, dynamic>>>[];
      final subscription = client
          .request(requestable: requestable)
          .listen((response) => responses.add(response));

      // Emit error
      link.emitError([
        {'message': 'Something went wrong'}
      ]);

      await Future.delayed(Duration(milliseconds: 100));

      expect(responses.length, 1);
      expect(responses[0], isA<GraphQLError>());
      final error = responses[0] as GraphQLError;
      expect(error.errors[0]['message'], 'Something went wrong');

      link.close();
      await subscription.cancel();
    });

    test('handles multiple cache updates in quick succession', () async {
      const cacheKey = 'User:123';

      final requestable = TestRequestable<Map<String, dynamic>>(
        request: Request(
          query: 'query { user { id name } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'TestQuery',
        ),
        loader: (data, ctx) {
          ctx.insertToCache(cacheKey, data['user'] as JsonObject);
          return ({'userName': data['user']['name']}, {cacheKey});
        },
        cacheReader: (ctx) {
          final cached = ctx.getCachedRecord(cacheKey);
          return ({'userName': cached?['name'] ?? 'unknown'}, {cacheKey});
        },
      );

      final responses = <GraphQLResponse<Map<String, dynamic>>>[];
      final subscription = client
          .request(requestable: requestable)
          .listen((response) => responses.add(response));

      // Emit initial data
      link.emitData({
        'user': {'id': '123', 'name': 'Alice'}
      });

      await Future.delayed(Duration(milliseconds: 100));

      // Multiple rapid cache updates
      for (var i = 1; i <= 3; i++) {
        ctx.insertToCache(cacheKey, {
          'id': '123',
          'name': 'Alice Update $i',
        });
        ctx.invalidateRefs({cacheKey});
        await Future.delayed(Duration(milliseconds: 50));
      }

      await Future.delayed(Duration(milliseconds: 100));

      // Should have initial + 3 cache updates
      expect(responses.length, 4);
      expect((responses[0] as GraphQLData).data['userName'], 'Alice');
      expect((responses[1] as GraphQLData).data['userName'], 'Alice Update 1');
      expect((responses[2] as GraphQLData).data['userName'], 'Alice Update 2');
      expect((responses[3] as GraphQLData).data['userName'], 'Alice Update 3');

      link.close();
      await subscription.cancel();
    });
  });
}
