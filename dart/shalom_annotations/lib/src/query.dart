import 'package:meta/meta.dart';

@immutable
class Query {
  final String sdl;
  const Query(this.sdl);
}
