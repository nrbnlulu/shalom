import "shalom_core_base.dart";

typedef ID = String;
typedef JsonObject = Map<String, dynamic>;

abstract class Node extends ChangeNotifier {
  final ID id;
  Node({required this.id});
  void updateStoreWithRaw(JsonObject raw, NodeManager nodeManager);
  void updateWithJson(JsonObject newData);
  void convertToObjAndSet(JsonObject data);
  JsonObject data();
}

class NodeSubscriber {
  final ID subscriberId;
  final WeakReference<Node> nodeRef;
  final List<String> subscribedFields;

  NodeSubscriber({
    required this.subscriberId,
    required this.nodeRef,
    required this.subscribedFields,
  });
}

class NodeManager {
  final Map<ID, JsonObject> _rawStore = {};
  final Map<ID, List<NodeSubscriber>> _subscriberStore = {};
  late final Finalizer<({ID nodeId, ID subscriberId})> _finalizer;

  NodeManager() {
    _finalizer = Finalizer(
      (ids) => _cleanupSubscribers(ids.nodeId, ids.subscriberId),
    );
  }

  void _cleanupSubscribers(ID nodeId, ID subscriberId) {
    final subscribers = _subscriberStore[nodeId];
    if (subscribers == null) return;
    subscribers.removeWhere((s) => s.subscriberId == subscriberId);
    if (subscribers.isEmpty) {
      _subscriberStore.remove(nodeId);
      _rawStore.remove(nodeId);
    }
  }

  void addOrUpdateNode(Node node) {
    final nodeId = node.id; 
    final newData = node.data();
    final oldData = _rawStore[nodeId];
    if (oldData != null) {
      if (oldData != newData) {
        _rawStore[nodeId] = newData;
        List<NodeSubscriber>? subscribers = _subscriberStore[nodeId];
        if (subscribers != null) {
          for (final subscriber in subscribers) {
            Node? node = subscriber.nodeRef.target;
            if (node != null) {
              node.updateWithJson(newData);
            }
          }
        }
      }
    } else {
      _rawStore[nodeId] = newData;
    }
  }

  void subscribeToNode(Node node) {
    final nodeId = node.id;
    JsonObject? data = _rawStore[nodeId];
    if (data != null) {
      node.convertToObjAndSet(data);
      final subscriberId = "foo";
      final subscriber = NodeSubscriber(
        subscriberId: subscriberId,
        nodeRef: WeakReference(node),
        subscribedFields: [],
      );
      _subscriberStore.putIfAbsent(nodeId, () => []).add(subscriber);
      _finalizer.attach(node, (
        nodeId: nodeId,
        subscriberId: subscriberId,
      ), detach: node);
    } else {
      throw Exception();
    }
  }
}
