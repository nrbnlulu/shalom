import 'package:riverpod/riverpod.dart';
import 'package:shalom_core/shalom_core.dart'
    show ShalomClient, ShalomCtx, HttpLink;
import 'package:dio/dio.dart' as dio;
import 'package:swapi/__graphql__/GetFilms.shalom.dart' show RequestGetFilms;
import 'package:swapi/dio_transport.dart' show DioTransport;

final graphqlClientProvider = Provider((ref) {
  final dioClient = dio.Dio();
  final transport = DioTransport(dioClient);
  final httpLink = HttpLink(
    transportLayer: transport,
    url: 'https://swapi-graphql.netlify.app/graphql',
  );
  final ctx = ShalomCtx.withCapacity();
  final client = ShalomClient(ctx: ctx, link: httpLink);
  return client;
});

final filmsProvider = StreamProvider((ref) async* {
  // it is a best-practice to use streams (watch) even or queries since you
  // might get updates from other places in the schema / other operations
  // automatically because shalom normalizes your data.
  yield* ref
      .read(graphqlClientProvider)
      .request(requestable: RequestGetFilms());
});
