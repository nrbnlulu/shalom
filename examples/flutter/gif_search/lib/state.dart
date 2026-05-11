import 'package:flutter/services.dart';
import 'package:shalom/shalom.dart' show HttpLink, ShalomRuntimeClient;
import 'package:dio/dio.dart' as dio;
import 'package:gif_search/dio_transport.dart' show DioTransport;
import 'package:gif_search/graphql/__graphql__/shalom_init.shalom.dart';

const String _graphqlUrl = 'http://127.0.0.1:7000/graphql';

Future<ShalomRuntimeClient> createShalomClient() async {
  final schemaSdl = await rootBundle.loadString('lib/graphql/schema.graphql');

  final dioClient = dio.Dio(
    dio.BaseOptions(
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  final transport = DioTransport(dioClient);
  final httpLink = HttpLink(transportLayer: transport, url: _graphqlUrl);

  final client = ShalomRuntimeClient.create(
    schemaSdl: schemaSdl,
    link: httpLink,
  );
  registerShalomDefinitions(client);
  return client;
}
