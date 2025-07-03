import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

typedef ID = String;
typedef JsonObject = Map<String, dynamic>;

class NodeManager {
  Map<ID, JsonObject> _rawStore = {};
  Map<ID, List<NodeSubscriber>> _subscriberStore = {};

  List<String> _getChangedFields(JsonObject currentData, JsonObject newData) {
    List<String> changedFields = [];
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
            node.updateWithJson(newData, changedFields);
          }
        }
      }
    } else {
      _rawStore[nodeId] = newData;
    }
  }

  void register(Node node, List<String> subscribedFields) {
    final nodeId = node.id;
    final nodeSubscriber = NodeSubscriber(
      nodeRef: WeakReference(node),
      subscribedFields: subscribedFields,
    );
    _subscriberStore.putIfAbsent(nodeId, () => []).add(nodeSubscriber);
  }
}

class ShalomContext {
  final NodeManager manager;
  ShalomContext({required this.manager});
}

abstract class Node extends ChangeNotifier {
  final ID id;
  Node({required this.id});
  void updateWithJson(JsonObject rawData, List<String> changedFields);
  JsonObject toJson();
  subscribeToChanges(ShalomContext context);
}

class NodeSubscriber {
  final WeakReference<Node> nodeRef;
  final List<String> subscribedFields;
  NodeSubscriber({required this.nodeRef, required this.subscribedFields});
}

class NodeWidget extends StatefulWidget {
  final Node node;
  final Widget Function(BuildContext context, Node node) builder;
  final ShalomContext context;

  NodeWidget({
    super.key,
    required this.node,
    required this.builder,
    required this.context,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
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
}

// --- UI Implementation and Concrete Node Class ---

/// A concrete implementation of the [Node] class representing a user.
class UserNode extends Node {
  String name;
  String email;

  UserNode({required super.id, required this.name, required this.email});

  static UserNode deserialize(JsonObject data, ShalomContext context) {
    final self = UserNode(
      id: data["id"],
      name: data["name"],
      email: data["email"],
    );
    context.manager.parseNodeData(data);
    return self;
  }

  @override
  void subscribeToChanges(ShalomContext context) {
    context.manager.register(this, ["myOwnField", "etc"]);
  }

  @override
  void updateWithJson(JsonObject rawData, List<String> changedFields) {
    bool hasChanged = false;
    if (changedFields.contains('name') && rawData['name'] != name) {
      name = rawData['name'];
      hasChanged = true;
    }
    if (changedFields.contains('email') && rawData['email'] != email) {
      email = rawData['email'];
      hasChanged = true;
    }
    if (hasChanged) {
      notifyListeners();
    }
  }

  @override
  JsonObject toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

// --- Main Application ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Framework Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
      ),
      home: const UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final ShalomContext _shalomContext;
  late UserNode _userNode;

  @override
  void initState() {
    super.initState();
    // 1. Initialize the manager and context
    final nodeManager = NodeManager();
    _shalomContext = ShalomContext(manager: nodeManager);

    // 2. Define the initial data for our user node
    final initialUserData = {
      'id': 'user-123',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    };

    // 3. Create the UserNode instance from the data

    // 4. Add the initial data to the node manager's store
    _userNode = UserNode.deserialize(initialUserData, _shalomContext);
    _userNode.subscribeToChanges(_shalomContext);
  }

  void _simulateDataChange() {
    // This simulates receiving new data from a server or other external source.
    final updatedUserData = {
      'id': 'user-123', // Same ID
      'name': 'Jacob Doe', // Changed name
      'email': 'Jabob.doe.new@example.com', // Changed email
    };
    print("Simulating data change...");
    _userNode = UserNode.deserialize(updatedUserData, _shalomContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // 5. Use NodeWidget to listen for changes and rebuild the UI
          child: NodeWidget(
            context: _shalomContext,
            node: _userNode,
            builder: (context, node) {
              // The builder provides the most up-to-date version of the node.
              // We can safely cast it to UserNode.
              final user = node as UserNode;
              return UserCard(name: user.name, email: user.email);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateDataChange,
        tooltip: 'Change Data',
        child: const Icon(Icons.sync),
      ),
    );
  }
}

// A simple widget to display the user's information
class UserCard extends StatelessWidget {
  final String name;
  final String email;

  const UserCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
