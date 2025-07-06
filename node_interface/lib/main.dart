import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';
import 'package:http/http.dart' as http;

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
    print(_subscriberStore[node.id]?.length);
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
      subscribers.removeWhere(
        (subscriber) => subscriber.nodeRef.target == node,
      );
      print(subscribers.length);
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

class ApiService {
  static Future<List<JsonObject>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?delay=1'),
        headers: {"x-api-key": "reqres-free-v1"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<JsonObject>.from(data['data']);
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
    return [];
  }
}

class UserNode extends Node {
  String firstName;
  String lastName;
  String email;
  String avatarUrl;

  UserNode({
    required super.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';

  static UserNode deserialize(JsonObject data, ShalomContext context) {
    final self = UserNode(
      id: data["id"]?.toString() ?? '',
      firstName: data["first_name"] ?? '',
      lastName: data["last_name"] ?? '',
      email: data["email"] ?? '',
      avatarUrl: data["avatar"] ?? '',
    );
    context.manager.parseNodeData(self.toJson());
    return self;
  }

  @override
  void subscribeToChanges(ShalomContext context) {
    context.manager.register(this, {
      "first_name",
      "last_name",
      "email",
      "avatar",
    });
  }

  @override
  void unSubscribeToChanges(ShalomContext context) {
    context.manager.unRegister(this);
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    bool hasChanged = false;
    for (final fieldName in changedFields) {
      hasChanged = true;
      switch (fieldName) {
        case 'first_name':
          firstName = rawData["first_name"];
          break;
        case 'last_name':
          lastName = rawData["last_name"];
          break;
        case 'email':
          email = rawData["email"];
          break;
        case 'avatar':
          avatarUrl = rawData["avatar"];
          break;
      }
    }
    if (hasChanged) {
      notifyListeners();
    }
  }

  @override
  JsonObject toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar': avatarUrl,
    };
  }
}

// =========================================================================
// SECTION 3: MAIN APPLICATION & UI
// =========================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Framework Demo (No Provider)',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
      ),
      home: const UserListScreen(),
    );
  }
}

// --- User List Screen ---
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final ShalomContext _shalomContext;
  final Map<ID, UserNode> _userNodes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // The ShalomContext is created and owned by this screen.
    _shalomContext = ShalomContext(manager: NodeManager());
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final userData = await ApiService.fetchUsers();
    if (!mounted) return;

    setState(() {
      for (final json in userData) {
        // Pass the context to the deserializer.
        final node = UserNode.deserialize(json, _shalomContext);
        _userNodes[node.id] = node;
      }
      _isLoading = false;
    });
  }

  void _deleteUser(UserNode nodeToDelete) {
    // Remove the node from the state map and rebuild the UI.
    setState(() {
      _userNodes.remove(nodeToDelete.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _userNodes.length,
                itemBuilder: (context, index) {
                  final node = _userNodes.values.elementAt(index);
                  return NodeWidget<UserNode>(
                    node: node,
                    builder:
                        (_, node) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(node.avatarUrl),
                          ),
                          title: Text(node.fullName),
                          subtitle: Text(node.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            tooltip: 'Delete User',
                            onPressed: () => _deleteUser(node),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Pass both the node and the context to the next screen.
                                builder:
                                    (_) => UserProfileScreen(
                                      userNode: node,
                                      context: _shalomContext,
                                    ),
                              ),
                            );
                          },
                        ),
                    context: _shalomContext,
                  );
                },
              ),
    );
  }
}

// --- User Profile Screen ---
class UserProfileScreen extends StatelessWidget {
  final UserNode userNode;
  final ShalomContext context; // Receives the context via constructor.

  const UserProfileScreen({
    super.key,
    required this.userNode,
    required this.context,
  });

  void _simulateUpdate() {
    final updatedData = userNode.toJson();
    final randomLastName = "Manual #${Random().nextInt(100)}";
    updatedData['last_name'] = randomLastName;

    print(
      "Simulating update for ${userNode.id}: new last name '$randomLastName'",
    );
    // Use the passed-in context.
    context.manager.parseNodeData(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NodeWidget<UserNode>(
              node: userNode,
              // Pass the ShalomContext down to the NodeWidget.
              // Use `this.context` to avoid conflict with the BuildContext.
              context: this.context,
              builder:
                  (_, node) => ProfileHeader(
                    avatarUrl: node.avatarUrl,
                    fullName: node.fullName,
                  ),
            ),
            const SizedBox(height: 24),
            NodeWidget<UserNode>(
              node: userNode,
              context: this.context,
              builder: (_, node) => ContactInfoCard(email: node.email),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateUpdate,
        tooltip: 'Simulate Last Name Change',
        child: const Icon(Icons.sync),
      ),
    );
  }
}

// --- Individual UI Components (Unchanged) ---
class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String fullName;
  const ProfileHeader({
    super.key,
    required this.avatarUrl,
    required this.fullName,
  });

  @override
  Widget build(BuildContext context) {
    print("Building ProfileHeader for $fullName");
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
        const SizedBox(height: 16),
        Text(fullName, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final String email;
  const ContactInfoCard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    print("Building ContactInfoCard for $email");
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.email, color: Colors.tealAccent),
            const SizedBox(width: 16),
            Text(email, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
