import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:shalom_core/shalom_core.dart';

/// this is an internal widget and should prob not be used by users
/// this would later on be used by the codegen to generate UseQuery / UseFragment widgets
class RefSubscriberWidget<T> extends StatefulWidget {
  final ShalomCtx shalomCtx;
  final Set<RecordRef> initialRefs;
  final T initialResult;
  final T Function(List<RefUpdate>) onRefUpdate;
  final Widget Function({BuildContext ctx, T data}) childBuilder;
  
  const RefSubscriberWidget({
    super.key,
    required this.initialResult,
    required this.onRefUpdate,
    required this.shalomCtx,
    required this.initialRefs,
    required this.childBuilder
  });

  @override
  State<RefSubscriberWidget<T>> createState() => _RefSubscriberWidgetState();
}

class _RefSubscriberWidgetState<T> extends State<RefSubscriberWidget<T>> {
  RefSubscriber? subscription;
  late T data = widget.initialResult;
  
  @override
  void initState() {
    super.initState();
    subscription = widget.shalomCtx.cache.subscribeToRefs(widget.initialRefs);
    subscription!.streamController.stream.listen(
        (update){
            setState(() {
                data = widget.onRefUpdate(update);
            });
        }
    )
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return widget.childBuilder(
          ctx: context, data:data
      );
      
  }
}
