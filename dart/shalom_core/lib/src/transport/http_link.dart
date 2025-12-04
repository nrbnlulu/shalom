import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shalom_core/src/shalom_core_base.dart';
import 'package:shalom_core/src/transport/link.dart'
    show GraphQLLink, HeadersType;

enum HttpMethod {
  // ignore: constant_identifier_names
  GET,
  // ignore: constant_identifier_names
  POST,
}

abstract class ShalomHttpTransport {
  Future<JsonObject> request({
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
  const HttpLink({
    required this.transportLayer,
    required this.url,
    this.useGet = false,
    this.defaultHeaders = const [],
  });

  @override
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  }) async* {
    try {
      // Merge default headers with request-specific headers
      var finalHeaders = [...defaultHeaders, if (headers != null) ...headers];
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

      // Make the request through the transport layer
      final $response = await transportLayer.request(
        method: methodForThisRequest,
        url: url,
        data: requestBody,
        headers: finalHeaders,
      );

      // Parse and yield the response
      yield _parseResponse($response);
    } catch (e) {
      // Return a link error for any exceptions
      yield LinkExceptionResponse([
        ShalomTransportException(
          message: 'Network error: ${e.toString()}',
          code: 'NETWORK_ERROR',
        ),
      ]);
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

  /// Parses the transport layer response into a GraphQLResponse
  GraphQLResponse<JsonObject> _parseResponse(JsonObject response) {
    try {
      final data = response['data'];

      // Check for errors field
      final errors = response['errors'];
      List<JsonObject>? parsedErrors;

      if (errors != null) {
        if (errors is List) {
          parsedErrors = errors.map((e) => e as JsonObject).toList();
        } else {
          return LinkExceptionResponse([
            ShalomTransportException(
              message: 'Invalid errors format: expected array',
              code: 'INVALID_RESPONSE_FORMAT',
            ),
          ]);
        }
      }

      // Check for extensions field
      final extensionsRaw = response['extensions'];
      final JsonObject? $extensions =
          extensionsRaw != null && extensionsRaw is Map
              ? Map<String, dynamic>.from(extensionsRaw)
              : null;

      // According to GraphQL spec:
      // - If data is not null, it's a valid response
      // - If data is null or absent, errors must be present
      if (data != null) {
        // Handle data field - it must be a map
        if (data is Map) {
          return GraphQLData(
            data: data as JsonObject,
            errors: parsedErrors,
            extensions: $extensions,
          );
        } else {
          // Invalid data type
          return LinkExceptionResponse([
            ShalomTransportException(
              message: 'Invalid data format: expected JSON object',
              code: 'INVALID_RESPONSE_FORMAT',
            ),
          ]);
        }
      } else if (parsedErrors != null) {
        // No valid data, but has errors - this is a GraphQL error response
        return GraphQLError(
          errors: parsedErrors,
          extensions: $extensions,
        );
      } else {
        // Neither valid data nor errors - invalid response
        return LinkExceptionResponse([
          ShalomTransportException(
            message: 'Invalid GraphQL response: missing both data and errors',
            code: 'INVALID_RESPONSE_FORMAT',
          ),
        ]);
      }
    } catch (e) {
      return LinkExceptionResponse([
        ShalomTransportException(
          message: 'Failed to parse response: ${e.toString()}',
          code: 'RESPONSE_PARSE_ERROR',
        ),
      ]);
    }
  }
}
