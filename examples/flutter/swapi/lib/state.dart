import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shalom/shalom.dart'
    show HttpLink, ShalomClient, ShalomCtx, ShalomRuntimeClient;
import 'package:dio/dio.dart' as dio;
import 'package:swapi/__graphql__/GetFilms.shalom.dart' show RequestGetFilms;
import 'package:swapi/dio_transport.dart' show DioTransport;

final shalomRuntimeProvider = FutureProvider((ref) async {
  final dioClient = dio.Dio();
  final transport = DioTransport(dioClient);
  final httpLink = HttpLink(
    transportLayer: transport,
    url: 'https://swapi-graphql.netlify.app/graphql',
  );
  final runtime = await ShalomRuntimeClient.init(
    schemaSdl: await rootBundle.loadString("lib/schema.graphql"),
    fragmentSdls: [],
    config: {},
    link: httpLink,
  );
  return runtime;
});
