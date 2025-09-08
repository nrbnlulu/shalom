import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:shalom_core/shalom_core.dart';

/// this is an internal widget and should prob not be used by users
/// this would later on be used by the codegen to generate UseQuery / UseFragment widgets
class RefSubscriberWidget<T> extends StatefulWidget {
  final Widget child;
  final ShalomCtx shalomCtx;
  final Set<RecordRef> initialRefs;
  final T? Function(JsonObject) parseData;
  
  const RefSubscriberWidget({
    super.key,
    required this.shalomCtx,
    required this.initialRefs,
    required this.child,
  });

  @override
  State<RefSubscriberWidget> createState() => _RefSubscriberWidgetState();
}

class _RefSubscriberWidgetState extends State<RefSubscriberWidget> {
  RefSubscriber? subscription;
  @override
  void initState() {
    super.initState();
    subscription = widget.shalomCtx.cache.subscribeToRefs(widget.initialRefs);
    subscription!.streamController.stream.listen(
        (update){
            setState(() {});
        }
    )
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
