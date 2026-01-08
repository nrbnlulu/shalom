import 'package:dio/dio.dart' as dio;
import 'package:shalom_core/shalom_core.dart';

class DioTransport extends ShalomHttpTransport {
  final dio.Dio dioClient;

  DioTransport(this.dioClient);

  @override
  Future<JsonObject> request({
    required HttpMethod method,
    required String url,
    required JsonObject data,
    HeadersType? headers,
    JsonObject? extra,
  }) async {
    final headersMap = headers != null
        ? Map.fromEntries(headers.map((e) => MapEntry(e.$1, e.$2)))
        : null;

    dio.Response response;
    if (method == HttpMethod.GET) {
      response = await dioClient.get(
        url,
        data: data,
        options: dio.Options(headers: headersMap),
      );
    } else {
      response = await dioClient.post(
        url,
        data: data,
        options: dio.Options(headers: headersMap),
      );
    }

    return response.data;
  }
}
