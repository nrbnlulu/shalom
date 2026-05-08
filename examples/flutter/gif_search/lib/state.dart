import 'package:flutter/services.dart';
import 'package:gif_search/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shalom/shalom.dart' show HttpLink, ShalomRuntimeClient;
import 'package:dio/dio.dart' as dio;
import 'package:gif_search/dio_transport.dart' show DioTransport;

const String _graphqlUrl = 'http://127.0.0.1:8000/graphql';

final shalomRuntimeProvider = FutureProvider((ref) async {
  final schemaSdl = await rootBundle.loadString('lib/graphql/schema.graphql');

  final dioClient = dio.Dio(
    dio.BaseOptions(
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  final transport = DioTransport(dioClient);
  final httpLink = HttpLink(
    transportLayer: transport,
    url: _graphqlUrl,
  );

  final runtime = await ShalomRuntimeClient.init(
    schemaSdl: schemaSdl,
    link: httpLink,
  );
  await registerShalomDefinitions(runtime);
  return runtime;
});
