import 'shalom_core_base.dart';
import 'package:flutter/material.dart';

typedef ID = String;

abstract class Node extends ChangeNotifier {
  int widgetsSubscribed = 0;
  ID id;
  Node({required this.id});
  void updateWithJson(JsonObject rawData, Set<String> changedFields);
  JsonObject toJson();
  subscribeToChanges(ShalomContext context);
  unSubscribeToChanges(ShalomContext context);
}

class NodeSubscriber {
  final WeakReference<Node> nodeRef;
  final Set<String> subscribedFields;
  NodeSubscriber({required this.nodeRef, required this.subscribedFields});
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
  @override
  void initState() {
    super.initState();
    final node = widget.node;
    node.subscribeToChanges(widget.context);
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
    widget.node.unSubscribeToChanges(widget.context);
    super.dispose();
  }
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
    final nodeId = newData["id"];
    final currentData = _rawStore[nodeId];
    if (currentData != null) {
      final changedFields = _getChangedFields(currentData, newData);
      _rawStore[nodeId] = newData;
      final subscribers = _subscriberStore[nodeId];
      if (subscribers != null) {
        for (final subscriber in subscribers) {
          final node = subscriber.nodeRef.target;
          if (node != null) {
            if (changedFields
                .intersection(subscriber.subscribedFields)
                .isNotEmpty) {
              node.updateWithJson(newData, changedFields);
            }
          }
        }
      }
    } else {
      _rawStore[nodeId] = newData;
    }
  }

  void register(Node node, Set<String> subscribedFields) {
    final nodeId = node.id;
    final nodeSubscriber = NodeSubscriber(
      nodeRef: WeakReference(node),
      subscribedFields: subscribedFields,
    );
    _subscriberStore.putIfAbsent(nodeId, () => []).add(nodeSubscriber);
    print(
      "Number of subscribers for node $nodeId after addition: ${_subscriberStore[nodeId]?.length}",
    );
  }

  void unRegister(Node node) {
    final nodeId = node.id;
    final subscribers = _subscriberStore[nodeId];
    if (subscribers != null) {
      subscribers.removeWhere(
        (subscriber) => subscriber.nodeRef.target == node,
      );
      print(
        "Number of subscribers for node $nodeId after removal: ${subscribers.length}",
      );
    }
  }
}

class ShalomContext {
  final NodeManager manager;
  ShalomContext({required this.manager});
}
