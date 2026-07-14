import 'package:dio/dio.dart' as dio;
import 'package:shalom/shalom.dart';

class DioTransport extends ShalomHttpTransport {
  final dio.Dio dioClient;

  DioTransport(this.dioClient);

  @override
  Future<String> request({
    required HttpMethod method,
    required String url,
    required JsonObject data,
    HeadersType? headers,
    JsonObject? extra,
  }) async {
    dio.Response<String> response;

    final headersMap = headers != null
        ? Map.fromEntries(headers.map((e) => MapEntry(e.$1, e.$2)))
        : null;

    if (method == HttpMethod.GET) {
      response = await dioClient.get<String>(
        url,
        data: data,
        options: dio.Options(
          headers: headersMap,
          responseType: dio.ResponseType.plain,
        ),
      );
    } else {
      response = await dioClient.post<String>(
        url,
        data: data,
        options: dio.Options(
          headers: headersMap,
          responseType: dio.ResponseType.plain,
        ),
      );
    }

    return response.data ?? '';
  }
}
