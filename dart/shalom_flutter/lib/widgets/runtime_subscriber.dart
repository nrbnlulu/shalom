import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;

class RuntimeSubscriberWidget<T> extends StatefulWidget {
  final shalom_core.RuntimeSubscriptionClient runtime;
  final shalom_core.Requestable<T> requestable;
  final Map<String, dynamic> initialData;
  final Widget Function(BuildContext context, T data) builder;

  const RuntimeSubscriberWidget({
    super.key,
    required this.runtime,
    required this.requestable,
    required this.initialData,
    required this.builder,
  });

  @override
  State<RuntimeSubscriberWidget<T>> createState() =>
      _RuntimeSubscriberWidgetState<T>();
}

class _RuntimeSubscriberWidgetState<T>
    extends State<RuntimeSubscriberWidget<T>> {
  StreamSubscription<T>? _subscription;
  late T _data;

  @override
  void initState() {
    super.initState();
    _data = widget.requestable.getRequestMeta().parseFn(widget.initialData);
    _subscribe();
  }

  @override
  void didUpdateWidget(RuntimeSubscriberWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData != widget.initialData ||
        oldWidget.requestable.toRequest().opName !=
            widget.requestable.toRequest().opName) {
      _data = widget.requestable.getRequestMeta().parseFn(widget.initialData);
      _subscribe();
    }
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  void _subscribe() {
    unawaited(_subscription?.cancel());
    final refs = shalom_core.collectRuntimeRefs(widget.initialData);
    _subscription = widget.runtime
        .subscribeToRefs(requestable: widget.requestable, refs: refs)
        .listen((data) {
          setState(() {
            _data = data;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data);
  }
}
