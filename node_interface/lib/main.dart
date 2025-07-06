import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

typedef ID = String;
typedef JsonObject = Map<String, dynamic>;

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
            bool hasChanged = false;
            for (final field in subscriber.subscribedFields) {
              if (changedFields.contains(field)) {
                 hasChanged = true;
                 break;
              }
            }
            if (hasChanged) {
              node.updateWithJson(newData, changedFields);
            }
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

  void unRegister(Node node) {
    final nodeId = node.id;
    final subscribers = _subscriberStore[nodeId];
    if (subscribers != null) {
       subscribers.removeWhere((subscriber) => subscriber.nodeRef.target == node);
    }
  }
}

class ShalomContext {
  final NodeManager manager;
  ShalomContext({required this.manager});
}

abstract class Node extends ChangeNotifier {
  final ID id;
  Node({required this.id});
  void updateWithJson(JsonObject rawData, Set<String> changedFields);
  JsonObject toJson();
  subscribeToChanges(ShalomContext context);
  unSubscribeToChanges(ShalomContext context);
}

class NodeSubscriber {
  final WeakReference<Node> nodeRef;
  final List<String> subscribedFields;
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
    context.manager.register(this, ["email", "name"]);
  }

  @override
  void unSubscribeToChanges(ShalomContext context) {
    context.manager.unRegister(this);
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    for (final f_name in changedFields) {
      switch (f_name) {
        case 'name': 
           name = rawData["name"];
           break;
        case 'email':
           email = rawData["email"];
           break;
      }
    }
    notifyListeners();
  }

  @override
  JsonObject toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

// --- Main Application --- (No changes here, included for context)
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



// --- MODIFIED: UserProfileScreen ---

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final ShalomContext _shalomContext;
  // Changed to a regular list from final to allow removal
  late List<UserNode> _userNodes;
  int _updateCounter = 0;

  @override
  void initState() {
    super.initState();
    final nodeManager = NodeManager();
    _shalomContext = ShalomContext(manager: nodeManager);

    // Initialize with two distinct users
    _userNodes = [
      UserNode.deserialize({
        'id': 'user-123',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
      }, _shalomContext),
      UserNode.deserialize({
        'id': 'user-123',
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
      }, _shalomContext),
    ];
  }

  void _simulateDataChange() {
    final targetIndex = _updateCounter % _userNodes.length;
    final targetNode = _userNodes[targetIndex];

    final updatedUserData = {
      'id': targetNode.id,
      'name': '${targetNode.name.split(" ").first} Updated',
      'email': '${targetNode.id}@example-updated.com',
    };

    _shalomContext.manager.parseNodeData(updatedUserData);

    setState(() {
      _updateCounter++;
    });
  }

  // --- NEW: Method to handle removing a node ---
  void _removeUser(UserNode nodeToRemove) {
    setState(() {
      _userNodes.removeWhere((node) => node.id == nodeToRemove.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Removable User Cards'),
        backgroundColor: Colors.black26,
      ),
      body: _userNodes.isEmpty
          ? const Center(child: Text("No users left. Add functionality to add them back!"))
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: _userNodes.length,
              itemBuilder: (context, index) {
                final userNode = _userNodes[index];
                return NodeWidget<UserNode>(
                  context: _shalomContext,
                  node: userNode,
                  builder: (context, user) {
                    // Pass the removal handler to the UserCard
                    return UserCard(
                      name: user.name,
                      email: user.email,
                      onRemove: () => _removeUser(user),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateDataChange,
        tooltip: 'Change Data',
        child: const Icon(Icons.sync),
      ),
    );
  }
}

// --- MODIFIED: UserCard ---
// A simple widget to display the user's information
class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onRemove; // Callback for the remove button

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    this.onRemove,
  });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: onRemove,
                    tooltip: 'Remove User',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}