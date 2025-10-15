import 'package:shalom_core/shalom_core.dart' show JsonObject;

abstract class TransportLayer {
  Stream<dynamic> request(
      {required JsonObject request, JsonObject? headers, JsonObject? extra});
}
