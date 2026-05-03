import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shalom/shalom.dart' show HttpLink, ShalomRuntimeClient, init;
import 'package:dio/dio.dart' as dio;
import 'package:shalom/shalom.dart' as shalom;
import 'package:swapi/dio_transport.dart' show DioTransport;
import 'package:swapi/__graphql__/shalom_init.shalom.dart';

final shalomRuntimeProvider = FutureProvider((ref) async {
  final dioClient = dio.Dio();
  final transport = DioTransport(dioClient);

  final httpLink = HttpLink(
    transportLayer: transport,
    url: 'https://graphql.org/swapi-graphql',
  );
  final runtime = await ShalomRuntimeClient.init(
    schemaSdl: await rootBundle.loadString("lib/schema.graphql"),
    config: {},
    link: httpLink,
  );
  await registerShalomDefinitions(runtime);
  return runtime;
});
