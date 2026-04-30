import 'dart:collection';

import 'package:shalom/shalom.dart';

/// A [GraphQLLink] that returns pre-configured responses from a queue.
/// Each call to [request] pops the next response. Throws [StateError] if the
/// queue is exhausted.
class MockGraphQLLink extends GraphQLLink {
  final Queue<GraphQLResponse<JsonObject>> _queue;

  MockGraphQLLink(List<GraphQLResponse<JsonObject>> responses)
    : _queue = Queue.from(responses);

  @override
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  }) {
    if (_queue.isEmpty) {
      throw StateError(
        'MockGraphQLLink: no more responses queued for ${request.opName}',
      );
    }
    return Stream.value(_queue.removeFirst());
  }

  bool get isEmpty => _queue.isEmpty;
  int get remaining => _queue.length;
}
