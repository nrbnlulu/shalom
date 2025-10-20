import 'package:dio/dio.dart' as dio;
import 'package:shalom_core/shalom_core.dart';

class DioTransport extends ShalomHttpTransport {
  final dio.Dio dioClient;

  DioTransport(this.dioClient);

  @override
  Future<JsonObject> request(
       {required HttpMethod method,
       required String url,
       required JsonObject data,
       JsonObject? headers,
       JsonObject? extra}) async {

    dio.Response response;

    if (method == HttpMethod.GET) {
      response = await dioClient.get(url, options: dio.Options(headers: headers));
    } else {
      response = await dioClient.post(url, data: request, options: dio.Options(headers: headers));
    }

    return response.data;
  }
}
