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

abstract class Node extends ChangeNotifier {
  int widgetsSubscribed = 0;
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
  static Future<JsonObject> fetchUserById(ID id) async {
    try {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users/${id}'),
        headers: {"x-api-key": "reqres-free-v1"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return JsonObject.from(data['data']);
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
    return {};
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
    if (widgetsSubscribed == 0) {
      context.manager.register(this, {
        "first_name",
        "last_name",
        "email",
        "avatar",
      });
    }
    widgetsSubscribed += 1;
  }

  @override
  void unSubscribeToChanges(ShalomContext context) {
    if (widgetsSubscribed < 2) {
      context.manager.unRegister(this);
    }
    widgetsSubscribed -= 1;
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    for (final fieldName in changedFields) {
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
    notifyListeners();
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Framework Demo (Master-Detail)',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        dividerColor: Colors.white24,
        useMaterial3: true,
      ),
      // The home is now the new dashboard screen.
      home: const UserDashboardScreen(),
    );
  }
}

/// A screen that holds both the user list (sidebar) and the profile details.
class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late final ShalomContext _shalomContext;
  final Map<ID, UserNode> _userNodes = {};
  bool _isLoading = true;
  UserNode? _selectedUser; // Holds the currently selected user.

  @override
  void initState() {
    super.initState();
    _shalomContext = ShalomContext(manager: NodeManager());
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final userData = await ApiService.fetchUsers();
    if (!mounted) return;

    setState(() {
      for (final json in userData) {
        final node = UserNode.deserialize(json, _shalomContext);
        _userNodes[node.id] = node;
      }
      _isLoading = false;
      // Optionally, select the first user by default.
      if (_userNodes.isNotEmpty) {
        _selectedUser = _userNodes.values.first;
      }
    });
  }

  void _deleteUser(UserNode nodeToDelete) {
    setState(() {
      _userNodes.remove(nodeToDelete.id);
      // If the deleted user was the selected one, clear the selection.
      if (_selectedUser?.id == nodeToDelete.id) {
        _selectedUser = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // --- Sidebar (Master View) ---
                SizedBox(
                  width: 280,
                  child: ListView.builder(
                    itemCount: _userNodes.length,
                    itemBuilder: (context, index) {
                      final node = _userNodes.values.elementAt(index);
                      // Corrected NodeWidget instantiation
                      return NodeWidget<UserNode>(
                        node: node,
                        context: _shalomContext,
                        builder: (context, node) {
                          return ListTile(
                            selected: _selectedUser?.id == node.id,
                            selectedTileColor: Colors.teal.withOpacity(0.2),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(node.avatarUrl),
                            ),
                            title: Text(node.fullName),
                            subtitle: Text(node.email),
                            onTap: () {
                              setState(() {
                                _selectedUser = node;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const VerticalDivider(width: 1),

                // --- Main Content (Detail View) ---
                Expanded(
                  child: _selectedUser == null
                      ? const Center(
                          child: Text('Select a user from the list'),
                        )
                      // Corrected UserProfileDetail instantiation
                      : UserProfileDetail(
                          key: ValueKey(_selectedUser!.id),
                          id: _selectedUser!.id, // Use userNode instead of id
                          context: _shalomContext,
                          onDelete: () => _deleteUser(_selectedUser!),
                        ),
                ),
              ],
            ),
    );
  } 
}

class UserProfileDetail extends StatefulWidget {
  final ShalomContext context;
  final VoidCallback onDelete;
  final ID id;

  const UserProfileDetail({
    super.key,
    required this.id,
    required this.context,
    required this.onDelete,
  });

  @override
  State<UserProfileDetail> createState() => _UserProfileDetailState();
}


class _UserProfileDetailState extends State<UserProfileDetail> {
  late final UserNode userNode;
  bool _isLoading = true; // State to manage loading

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // Fetch data using the ID from the widget
    final userData = await ApiService.fetchUserById(widget.id);
    if (!mounted) return;

    setState(() {
      userNode = UserNode.deserialize(userData, widget.context);
      _isLoading = false; // Turn off loading indicator
    });
  }

  void _simulateUpdate() {
    final updatedData = userNode.toJson();
    final randomLastName = "Updated #${Random().nextInt(100)}";
    updatedData['last_name'] = randomLastName;

    print("Simulating update for ${userNode.id}: new last name '$randomLastName'");
    widget.context.manager.parseNodeData(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while data is being fetched
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Once loaded, build the profile UI
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NodeWidget<UserNode>(
            node: userNode,
            context: widget.context,
            builder: (_, node) => ProfileHeader(
              avatarUrl: node.avatarUrl,
              fullName: node.fullName,
            ),
          ),
          const SizedBox(height: 24),
          NodeWidget<UserNode>(
            node: userNode,
            context: widget.context,
            builder: (_, node) => ContactInfoCard(email: node.email),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.sync),
                label: const Text('Simulate Update'),
                onPressed: _simulateUpdate,
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete User'),
                onPressed: widget.onDelete,
              ),
            ],
          )
        ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
