import 'dart:async';
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        ChangeNotifier,
        ListenableBuilder,
        State,
        StatefulWidget,
        Widget;

import 'shalom_core_base.dart';

typedef ID = String;

abstract class Node extends ChangeNotifier {
  int get instanceId => identityHashCode(this);
  ID id;
  Node({required this.id});
  void updateWithJson(
      JsonObject rawData, Set<String> changedFields, ShalomContext context);
  JsonObject toJson();
  StreamSubscription<Event> subscribeToChanges(ShalomContext context);
}

class NodeSubscriber {
  final StreamController<Event> controller;
  final Set<String> subscribedFields;
  final int nodeInstanceId;
  NodeSubscriber({
    required this.controller,
    required this.subscribedFields,
    required this.nodeInstanceId,
  });
}

class NodeWidget<T extends Node> extends StatefulWidget {
  final T node;
  final Widget Function(BuildContext context, T node) builder;
  final ShalomContext context;

  NodeWidget(
      {super.key,
      required this.node,
      required this.builder,
      required this.context});

  @override
  State<NodeWidget<T>> createState() => _NodeWidgetState<T>();
}

class _NodeWidgetState<T extends Node> extends State<NodeWidget<T>> {
  late StreamSubscription<Event> subscription;
  @override
  void initState() {
    super.initState();
    final node = widget.node;
    subscription = node.subscribeToChanges(widget.context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.node,
      builder: (context, child) {
        return widget.builder(context, widget.node);
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class Event {
  final JsonObject rawData;
  final Set<String> changedFields;
  Event({required this.rawData, required this.changedFields});
}

class NodeManager {
  Map<ID, JsonObject> _rawStore = {};
  Map<ID, List<NodeSubscriber>> _subscriberStore = {};

  Set<String> _getChangedFields(JsonObject currentData, JsonObject newData) {
    Set<String> changedFields = Set();
    for (final field in newData.keys) {
      if (currentData[field] != newData[field]) {
        changedFields.add(field);
      }
    }
    return changedFields;
  }

  void parseNodeData(JsonObject newData) {
    final id = newData["id"];
    final currentData = _rawStore[id];
    if (currentData != null) {
      final changedFields = _getChangedFields(currentData, newData);
      _rawStore[id] = newData;
      final subscribers = _subscriberStore[id];
      if (subscribers != null) {
        for (final subscriber in subscribers) {
          if (changedFields
              .intersection(subscriber.subscribedFields)
              .isNotEmpty) {
            subscriber.controller
                .add(Event(rawData: newData, changedFields: changedFields));
          }
        }
      }
    } else {
      _rawStore[id] = newData;
    }
  }

  StreamSubscription<Event> register(
    Node node,
    Set<String> subscribedFields,
    ShalomContext context,
  ) {
    final controller = StreamController<Event>.broadcast(
      onCancel: () {
        _subscriberStore[node.id]?.removeWhere((subscriber) {
          if (subscriber.nodeInstanceId == node.instanceId) {
            subscriber.controller.close();
            return true;
          }
          return false;
        });
      },
    );
    final subscription = controller.stream.listen((event) {
      node.updateWithJson(event.rawData, event.changedFields, context);
    });
    final nodeSubscriber = NodeSubscriber(
      controller: controller,
      subscribedFields: subscribedFields,
      nodeInstanceId: node.instanceId,
    );
    _subscriberStore.putIfAbsent(node.id, () => []).add(nodeSubscriber);
    return subscription;
  }
}

class ShalomContext {
  final NodeManager manager;
  ShalomContext({required this.manager});
}
