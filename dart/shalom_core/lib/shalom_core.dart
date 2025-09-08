import 'src/normelized_cache.dart';

export 'src/shalom_core_base.dart';
export 'src/scalar.dart';
export 'src/normelized_cache.dart'
    show NormelizedCache, RefSubscriber, RefUpdate, RecordRef, RefStreamType;

class ShalomCtx {
  final NormelizedCache cache;
  const ShalomCtx({required this.cache});
}
