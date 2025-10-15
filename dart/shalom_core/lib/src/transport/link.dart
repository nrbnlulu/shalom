import 'package:shalom_core/shalom_core.dart';

abstract class GraphQLLink {
  const GraphQLLink();
  Stream<GraphQLResponse> request(
      {required Request request, required JsonObject headers});
}
