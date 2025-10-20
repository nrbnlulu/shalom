import 'dart:async';
import 'dart:convert';

import 'package:shalom_core/src/shalom_core_base.dart';
import 'package:shalom_core/src/transport/link.dart' show GraphQLLink;

enum HttpMethod {
  // ignore: constant_identifier_names
  GET,
  // ignore: constant_identifier_names
  POST
}

abstract class ShalomHttpTransport {
  Future<JsonObject> request(
      {required HttpMethod method,
      required String url,
      required JsonObject data,
      JsonObject? headers,
      JsonObject? extra});
}

/// Implementation of GraphQL over HTTP protocol as specified in:
/// https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md
class HttpLink extends GraphQLLink {
  final ShalomHttpTransport transportLayer;
  final String url;
  final bool useGet;
  final JsonObject defaultHeaders;

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
    this.defaultHeaders = const {},
  });

  @override
  Stream<GraphQLResponse<JsonObject>> request(
      {required Request request, JsonObject? headers}) async* {
    try {
      // Merge default headers with request-specific headers
      final mergedHeaders = <String, dynamic>{
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

      final methodForThisRequest =
          useGet && request.opType == OperationType.Query
              ? HttpMethod.GET
              : HttpMethod.POST;

      // Prepare the request
      JsonObject requestBody;
      JsonObject finalHeaders;

      if (methodForThisRequest == HttpMethod.GET) {
        // GET requests: parameters go in URL query string
        requestBody = _prepareGetRequest(request);
        finalHeaders = {
          ...mergedHeaders,
          'Accept': _getAcceptHeader(mergedHeaders),
        };
      } else {
        // POST requests: parameters go in JSON body
        requestBody = _preparePostRequest(request);
        finalHeaders = {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': _getAcceptHeader(mergedHeaders),
          ...mergedHeaders,
        };
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
      yield LinkErrorResponse([
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
    final params = <String, dynamic>{
      'query': request.query,
    };

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
  String _getAcceptHeader(JsonObject headers) {
    // If user already specified Accept header, use it
    if (headers.containsKey('Accept')) {
      return headers['Accept'] as String;
    }

    // Default: prefer graphql-response+json, fallback to json
    return 'application/graphql-response+json, application/json;q=0.9';
  }

  /// Parses the transport layer response into a GraphQLResponse
  GraphQLResponse<JsonObject> _parseResponse(JsonObject response) {
    try {
      // Check for data field
      final $hasData = response.containsKey('data');
      final $data = response['data'];

      // Check for errors field
      final $errors = response['errors'];
      List<JsonObject>? $parsedErrors;

      if ($errors != null) {
        if ($errors is List) {
          $parsedErrors = $errors.map((e) => e as JsonObject).toList();
        } else {
          return LinkErrorResponse([
            ShalomTransportException(
              message: 'Invalid errors format: expected array',
              code: 'INVALID_RESPONSE_FORMAT',
            ),
          ]);
        }
      }

      // Check for extensions field
      final $extensionsRaw = response['extensions'];
      final $extensions = $extensionsRaw != null && $extensionsRaw is Map
          ? Map<String, dynamic>.from($extensionsRaw)
          : <String, dynamic>{};

      // According to GraphQL spec:
      // - If data is present (even if null), it's a valid response
      // - If data is not present, errors must be present
      if ($hasData) {
        // Handle data field - it can be null, a map, or other types
        JsonObject $dataMap;
        if ($data == null) {
          $dataMap = <String, dynamic>{};
        } else if ($data is Map) {
          $dataMap = Map<String, dynamic>.from($data);
        } else {
          // Invalid data type
          return LinkErrorResponse([
            ShalomTransportException(
              message: 'Invalid data format: expected JSON object or null',
              code: 'INVALID_RESPONSE_FORMAT',
            ),
          ]);
        }

        return GraphQLData(
          data: $dataMap,
          errors: $parsedErrors,
          extensions: $extensions,
        );
      } else if ($parsedErrors != null) {
        // No data field, but has errors - this is a request error
        return LinkErrorResponse([
          ShalomTransportException(
            message: 'GraphQL request error',
            code: 'GRAPHQL_ERROR',
            details: {'errors': $parsedErrors, 'extensions': $extensions},
          ),
        ]);
      } else {
        // Neither data nor errors - invalid response
        return LinkErrorResponse([
          ShalomTransportException(
            message: 'Invalid GraphQL response: missing both data and errors',
            code: 'INVALID_RESPONSE_FORMAT',
          ),
        ]);
      }
    } catch (e) {
      return LinkErrorResponse([
        ShalomTransportException(
          message: 'Failed to parse response: ${e.toString()}',
          code: 'RESPONSE_PARSE_ERROR',
        ),
      ]);
    }
  }
}
