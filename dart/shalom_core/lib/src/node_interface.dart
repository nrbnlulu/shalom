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
    JsonObject rawData,
    Set<String> changedFields,
    ShalomContext context,
  );
  JsonObject toJson();
  StreamSubscription<NodeDataChange> subscribeToChanges(ShalomContext context);
}

class NodeSubscriber {
  final Node node;
  final Set<String> subscribedFields;
  NodeSubscriber({required this.subscribedFields, required this.node});
}

class NodeWidget<T extends Node> extends StatefulWidget {
  final T node;
  final Widget Function(BuildContext context, T node) builder;
  final ShalomContext context;

  NodeWidget({
    super.key,
    required this.node,
    required this.builder,
    required this.context,
  });

  @override
  State<NodeWidget<T>> createState() => _NodeWidgetState<T>();
}

class _NodeWidgetState<T extends Node> extends State<NodeWidget<T>> {
  late StreamSubscription<NodeDataChange> subscription;
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

class NodeSubscriptionController {
  final void Function() unsubscribe;
  NodeSubscriptionController(this.unsubscribe);
}

class NodeDataChange {
  final JsonObject rawData;
  final Set<String> changedFields;
  NodeDataChange({required this.rawData, required this.changedFields});
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
      final nodeDataChange = NodeDataChange(
        rawData: newData,
        changedFields: changedFields,
      );
      if (subscribers != null) {
        for (final subscriber in subscribers) {
          if (changedFields
              .intersection(subscriber.subscribedFields)
              .isNotEmpty) {
            subscriber.node.updateWithJson(nodeDataChange);
          }
        }
      }
    } else {
      _rawStore[id] = newData;
    }
  }

  NodeSubscriptionController register(
    Node node,
    Set<String> subscribedFields,
    ShalomContext context,
  ) {
    final nodeSubscriber = NodeSubscriber(
      subscribedFields: subscribedFields,
      node: node,
    );
    _subscriberStore.putIfAbsent(node.id, () => []).add(nodeSubscriber);
    return NodeSubscriptionController(() {
      _subscriberStore.removeWhere((id, subs) {
        if (id == node.id && subs.contains(nodeSubscriber)) {
          return true;
        }
        return false;
      });
    });
  }
}

class ShalomContext {
  final NodeManager manager;
  ShalomContext({required this.manager});
}

