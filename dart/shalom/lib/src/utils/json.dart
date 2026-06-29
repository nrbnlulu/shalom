import 'dart:convert';

import 'package:shalom/src/shalom_core_base.dart';

dynamic decodeJson(String text) => jsonDecode(text);
String encodeJson(JsonObject obj) => jsonEncode(obj);
