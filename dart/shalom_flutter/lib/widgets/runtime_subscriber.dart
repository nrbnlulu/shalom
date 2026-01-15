import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shalom_core/shalom_core.dart' as shalom_core;

class RuntimeSubscriberWidget<T> extends StatefulWidget {
  final shalom_core.RuntimeSubscriptionClient runtime;
  final shalom_core.FromCache<T> fromCache;
  final Map<String, dynamic> initialData;
  final String? rootRef;
  final Widget Function(BuildContext context, T data) builder;

  const RuntimeSubscriberWidget({
    super.key,
    required this.runtime,
    required this.fromCache,
    required this.initialData,
    required this.builder,
    this.rootRef,
  });

  @override
  State<RuntimeSubscriberWidget<T>> createState() =>
      _RuntimeSubscriberWidgetState<T>();
}

class _RuntimeSubscriberWidgetState<T>
    extends State<RuntimeSubscriberWidget<T>> {
  StreamSubscription<shalom_core.JsonObject>? _subscription;
  late T _data;

  @override
  void initState() {
    super.initState();
    _data = widget.fromCache.fromCache(widget.initialData);
    _subscribe();
  }

  @override
  void didUpdateWidget(RuntimeSubscriberWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData != widget.initialData ||
        oldWidget.rootRef != widget.rootRef ||
        oldWidget.fromCache.subscriberGlobalID !=
            widget.fromCache.subscriberGlobalID) {
      _data = widget.fromCache.fromCache(widget.initialData);
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
        .subscribeToRefs(
          targetId: widget.fromCache.subscriberGlobalID,
          rootRef: widget.rootRef,
          refs: refs,
        )
        .listen((payload) {
          setState(() {
            _data = widget.fromCache.fromCache(payload);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data);
  }
}
