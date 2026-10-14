import 'dart:collection';
import 'dart:convert';

import 'package:shalom/shalom.dart';

/// A [GraphQLLink] that returns pre-configured responses from a queue.
/// Each call to [request] pops the next response. Throws [StateError] if the
/// queue is exhausted.
class MockGraphQLLink extends GraphQLLink {
  final Queue<GraphQLResponse<GraphQLLinkPayload>> _queue;

  MockGraphQLLink(List<GraphQLResponse<JsonObject>> responses)
    : _queue = Queue.from(responses.map(_rawResponse));

  @override
  Stream<GraphQLResponse<GraphQLLinkPayload>> request({
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

GraphQLResponse<GraphQLLinkPayload> _rawResponse(
  GraphQLResponse<JsonObject> response,
) => switch (response) {
  GraphQLData(:final data, :final errors, :final extensions) => GraphQLData(
    data: RawGraphQLLinkPayload(
      json: jsonEncode({
        'data': data,
        ...?errors == null ? null : {'errors': errors},
        ...?extensions == null ? null : {'extensions': extensions},
      }),
    ),
  ),
  GraphQLError(:final errors, :final extensions) => GraphQLError(
    errors: errors,
    extensions: extensions,
  ),
  LinkExceptionResponse(:final errors) => LinkExceptionResponse(errors),
};
