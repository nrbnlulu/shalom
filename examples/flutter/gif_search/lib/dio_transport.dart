import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:shalom/shalom.dart';

class DioTransport extends ShalomHttpTransport {
  final dio.Dio dioClient;

  DioTransport(this.dioClient);

  @override
  Future<Uint8List> request({
    required HttpMethod method,
    required String url,
    required JsonObject data,
    HeadersType? headers,
    JsonObject? extra,
  }) async {
    dio.Response<List<int>> response;

    final headersMap = headers != null
        ? Map.fromEntries(headers.map((e) => MapEntry(e.$1, e.$2)))
        : null;
    final options = dio.Options(
      headers: headersMap,
      responseType: dio.ResponseType.bytes,
    );

    if (method == HttpMethod.GET) {
      response = await dioClient.get<List<int>>(
        url,
        data: data,
        options: options,
      );
    } else {
      response = await dioClient.post<List<int>>(
        url,
        data: data,
        options: options,
      );
    }

    return Uint8List.fromList(response.data!);
  }
}
