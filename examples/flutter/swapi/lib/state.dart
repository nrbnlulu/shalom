import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shalom/shalom.dart' show HttpLink, ShalomRuntimeClient;
import 'package:dio/dio.dart' as dio;
import 'package:swapi/dio_transport.dart' show DioTransport;
import 'package:swapi/__graphql__/shalom_init.shalom.dart';

final shalomRuntimeProvider = FutureProvider((ref) async {
  final schemaSdl = await rootBundle.loadString("lib/schema.graphql");

  final dioClient = dio.Dio(
    dio.BaseOptions(
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  final transport = DioTransport(dioClient);
  final httpLink = HttpLink(
    transportLayer: transport,
    url: 'https://swapi-graphql.netlify.app/graphql',
  );

  final runtime = await ShalomRuntimeClient.init(
    schemaSdl: schemaSdl,
    link: httpLink,
  );
  await registerShalomDefinitions(runtime);
  return runtime;
});
