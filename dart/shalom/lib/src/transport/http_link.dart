import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:shalom/src/shalom_core_base.dart';
import 'package:shalom/src/transport/link.dart' show GraphQLLink;

enum HttpMethod {
  // ignore: constant_identifier_names
  GET,
  // ignore: constant_identifier_names
  POST,
}

abstract class ShalomHttpTransport {
  /// Performs the HTTP request and returns the raw, still-encoded response
  /// body bytes. Implementations should NOT parse the body as JSON — decoding
  /// happens downstream (in Rust) to avoid a redundant decode/re-encode.
  Future<Uint8List> request({
    required HttpMethod method,
    required String url,
    required JsonObject data,
    HeadersType? headers,
    JsonObject? extra,
  });
}

/// Implementation of GraphQL over HTTP protocol as specified in:
/// https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md
class HttpLink extends GraphQLLink {
  final ShalomHttpTransport transportLayer;
  final String url;
  final bool useGet;
  final HeadersType defaultHeaders;

  /// Creates an HTTP link for GraphQL requests.
  ///
  /// [transportLayer] - The transport layer implementation to use for HTTP requests
  /// [url] - The GraphQL endpoint URL
  /// [useGet] - Whether to use GET requests (only for queries, not mutations). Defaults to false.
  /// [defaultHeaders] - Default headers to include with every request
  HttpLink({
    required this.transportLayer,
    required this.url,
    this.useGet = false,
    this.defaultHeaders = const [],
  });

  @override
  Stream<Uint8List> request({
    required Request request,
    HeadersType? headers,
  }) async* {
    try {
      // Merge default headers with request-specific headers
      var finalHeaders = [...defaultHeaders, ...?headers];
      finalHeaders = _ensureAcceptHeader(finalHeaders);

      final methodForThisRequest =
          useGet && request.opType == OperationType.Query
          ? HttpMethod.GET
          : HttpMethod.POST;

      // Prepare the request
      JsonObject requestBody;

      if (methodForThisRequest == HttpMethod.GET) {
        // GET requests: parameters go in URL query string
        requestBody = _prepareGetRequest(request);
      } else {
        // POST requests: parameters go in JSON body
        requestBody = _preparePostRequest(request);
        finalHeaders = [
          ('Content-Type', 'application/json; charset=utf-8'),
          ...finalHeaders,
        ];
      }

      // Make the request through the transport layer, and hand its bytes
      // straight through — no JSON decoding happens on the Dart side.
      yield await transportLayer.request(
        method: methodForThisRequest,
        url: url,
        data: requestBody,
        headers: finalHeaders,
      );
    } catch (e) {
      throw ShalomTransportException(
        message: 'Network error: ${e.toString()}',
        code: 'NETWORK_ERROR',
      );
    }
  }

  /// Prepares a POST request body according to the GraphQL over HTTP spec
  JsonObject _preparePostRequest(Request request) {
    final body = <String, dynamic>{
      'query': request.query,
      'operationName': request.opName,
    };

    // Only include variables if non-empty
    if (request.variables.isNotEmpty) {
      body['variables'] = request.variables;
    }

    return body;
  }

  /// Prepares a GET request with query parameters
  JsonObject _prepareGetRequest(Request request) {
    final params = <String, dynamic>{'query': request.query};

    if (request.opName.isNotEmpty) {
      params['operationName'] = request.opName;
    }

    if (request.variables.isNotEmpty) {
      // Variables must be JSON encoded for GET requests
      params['variables'] = jsonEncode(request.variables);
    }

    return params;
  }

  /// Gets the Accept header value according to the spec.
  /// Prefers application/graphql-response+json with application/json as fallback
  HeadersType _ensureAcceptHeader(HeadersType headers) {
    // If user already specified Accept header, use it
    final acceptHeader = headers.firstWhereOrNull((e) => e.$1 == 'Accept');
    if (acceptHeader != null) {
      return headers;
    }
    // Default: prefer graphql-response+json, fallback to json

    return [
      ...headers,
      ("Accept", 'application/graphql-response+json, application/json;q=0.9'),
    ];
  }
}
