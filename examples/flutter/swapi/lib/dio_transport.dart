import 'package:dio/dio.dart' as dio;
import 'package:shalom_core/shalom_core.dart';

class DioTransport extends TransportLayer {
  final dio.Dio dioClient;

  DioTransport(this.dioClient);

  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    final url = extra?['url'] as String;
    final method = extra?['method'] as String? ?? 'POST';

    dio.Response response;

    if (method == 'GET') {
      response = await dioClient.get(url, queryParameters: request, options: dio.Options(headers: headers));
    } else {
      response = await dioClient.post(url, data: request, options: dio.Options(headers: headers));
    }

    yield response.data;
  }
}
