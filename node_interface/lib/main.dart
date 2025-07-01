import 'package:flutter/material.dart';
import 'dart:math';

typedef ID = String; 
typedef JsonObject = Map<String, dynamic>;


abstract class Node extends ChangeNotifier {
  final ID id;
  Node({required this.id});
  void updateStoreWithRaw(JsonObject raw, NodeManager nodeManager);
  void updateWithJson(JsonObject newData);
  void setSubscription(JsonObject? data);
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
      node.setSubscription(data);
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
    }
  }


class GetListingResponse {
  /// class members

  final GetListing_listing listing;

  // keywordargs constructor
  GetListingResponse({required this.listing});
  static GetListingResponse fromJson(JsonObject data) {
    final GetListing_listing listing_value;

    listing_value = GetListing_listing.fromJson(data['listing']);

    return GetListingResponse(listing: listing_value);
  }

  GetListingResponse updateWithJson(JsonObject data) {
    final GetListing_listing listing_value;
    if (data.containsKey('listing')) {
      listing_value = GetListing_listing.fromJson(data['listing']);
    } else {
      listing_value = listing;
    }

    return GetListingResponse(listing: listing_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingResponse && other.listing == listing);
  }

  @override
  int get hashCode => listing.hashCode;

  JsonObject toJson() {
    return {'listing': listing.toJson()};
  }
}



// ------------ OBJECT DEFINITIONS -------------

class GetListing_listing {
  /// class members

  final String id;

  final String name;

  final int? price;

  // keywordargs constructor
  GetListing_listing({required this.id, required this.name, this.price});
  static GetListing_listing fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final String name_value;

    name_value = data['name'];

    final int? price_value;

    price_value = data['price'];

    return GetListing_listing(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  GetListing_listing updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final int? price_value;
    if (data.containsKey('price')) {
      price_value = data['price'];
    } else {
      price_value = price;
    }

    return GetListing_listing(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListing_listing &&
            other.id == id &&
            other.name == name &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class GetListingNode extends Node {
  GetListingResponse? _obj;
  bool isSubscribed = false; 
  GetListingNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    if (!isSubscribed) {
      throw Exception("manager must be subscribed to node");
    }
    _obj = GetListingResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (!isSubscribed) {
        throw Exception("must subscribe to node through manager");
    }
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = GetListingResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setSubscription(JsonObject? data) {
    if (data != null) {
     _obj = GetListingResponse.fromJson(data);
    }
     isSubscribed = true;
  }
  
  @override
  JsonObject data() {
    final data = _obj?.toJson();
    if (data != null) {
      return data;
    } else {
      throw Exception("Node has no data");
    }
  }

  GetListingResponse? get obj {
    return _obj;
  }
} 




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Manager Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListingScreen(),
    );
  }
}

/// A screen widget that displays and interacts with a [GetListingNode].
class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  // The manager that holds the central state ("source of truth")
  late final NodeManager _manager;
  // The local node instance that the UI will listen to for changes.
  late final GetListingNode _node;

  static const String listingId = 'listing-123';

  @override
  void initState() {
    super.initState();

    // 1. Initialize the manager and the node.
    _manager = NodeManager();
    _node = GetListingNode(id: listingId);

    _manager.subscribeToNode(_node);
    _node.updateStoreWithRaw({"listing": {"id": listingId, "name": "shalom", "price": 27000}}, _manager);
    _node.addListener(_onNodeUpdate);
  }

  /// This listener is called by the [ChangeNotifier] (our Node).
  ///
  /// It calls `setState` to tell Flutter that this widget needs to be rebuilt
  /// with the new data from the node.
  void _onNodeUpdate() {
    setState(() {
      // The UI will now be rebuilt with the updated `_node.obj` data.
    });
  }

  @override
  void dispose() {
    // 6. It's crucial to remove the listener when the widget is destroyed
    // to prevent memory leaks and errors.
    _node.removeListener(_onNodeUpdate);
    super.dispose();
  }

  /// Simulates an external update, like from a WebSocket or API response.
  ///
  /// This function creates a new JSON payload and uses the node's
  /// `updateStoreWithRaw` method to push the change into the central manager,
  /// which then notifies all subscribers (including our `_node`).
  void _performUpdate(JsonObject updatedListingData) {
    final currentListing = _node.obj?.listing;
    if (currentListing == null) return;

    // According to your `updateStoreWithRaw` implementation, it expects a
    // complete JSON object that can be parsed from scratch. So, we merge
    // the current data with the new data to create a full payload.
    final newListingJson = {
      ...currentListing.toJson(),
      ...updatedListingData,
    };

    final fullUpdatePayload = {'listing': newListingJson};

    _node.updateStoreWithRaw(fullUpdatePayload, _manager);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // The node's object can be null if something goes wrong during init.
    final listing = _node.obj?.listing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Node State Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (listing != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          listing.name,
                          style: textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${listing.price?.toString() ?? 'N/A'}',
                          style: textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.price_change),
                  label: const Text('Increase Price by 10k'),
                  onPressed: () {
                    final newPrice = (listing.price ?? 0) + 10000;
                    _performUpdate({'price': newPrice});
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Change Name'),
                  onPressed: () {
                    final newName = "Sunny Seaside Villa ${Random().nextInt(100)}";
                    _performUpdate({'name': newName});
                  },
                ),
              ] else ...[
                const Text('Error: Listing data is not available.'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}