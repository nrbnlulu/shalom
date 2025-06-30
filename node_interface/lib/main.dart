import 'package:flutter/material.dart';

typedef ID = String; 
typedef JsonObject = Map<String, dynamic>;


class Node extends ChangeNotifier {
  ID id;
  JsonObject data;
  Node({required this.id, required this.data});
  
  void updateWithJson(JsonObject newData) {
      notifyListeners();
  }
}





// ------------------------------------------------------------------
// 2. FLUTTER UI (Using a Singleton)
// ------------------------------------------------------------------

/// A single, globally accessible instance of the NodeManager.
/// This is the core of the singleton pattern.
final nodeManager = NodeManager();

/// The root of the application.
void main() {
  runApp(const NodeExampleApp());
}

/// The main App Widget.
class NodeExampleApp extends StatefulWidget {
  const NodeExampleApp({super.key});

  @override
  State<NodeExampleApp> createState() => _NodeExampleAppState();
}

class _NodeExampleAppState extends State<NodeExampleApp> {
  @override
  void initState() {
    super.initState();
    // Populate the global manager with some initial data.
    nodeManager.processData('node-1', {'name': 'Alice', 'score': 100});
    nodeManager.processData('node-2', {'name': 'Bob', 'score': 200});
  }

  @override
  Widget build(BuildContext context) {
    // The NodeProvider is no longer needed here.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

/// The main screen of the application.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We access the global `nodeManager` instance directly.
    return Scaffold(
      appBar: AppBar(
        title: const Text('NodeManager (Singleton)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Subscribed Widgets:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            NodeWidget(nodeId: 'node-1', subscribedFields: const ['name', 'score']),
            const SizedBox(height: 12),
            NodeWidget(nodeId: 'node-2', subscribedFields: const ['name']),
            const SizedBox(height: 12),
            NodeWidget(nodeId: 'node-2', subscribedFields: const ['score']),
            const Spacer(),
            const Text("Actions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final currentData = nodeManager._rawStore['node-1'] ?? {};
                nodeManager.processData('node-1', {'name': 'Alice', 'score': (currentData['score'] ?? 100) + 10});
              },
              child: const Text("Update Node 1 Score"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                nodeManager.processData('node-2', {'name': 'Robert', 'score': 200});
              },
              child: const Text("Update Node 2 Name"),
            ),
             const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                nodeManager.processData('node-2', {'name': 'Bob', 'score': 300});
              },
              child: const Text("Update Node 2 Score"),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays data for a single node.
class NodeWidget extends StatefulWidget {
  final ID nodeId;
  final List<String> subscribedFields;

  const NodeWidget({
    super.key,
    required this.nodeId,
    required this.subscribedFields,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  late Node _node;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    // Since we don't need context to find the manager, we can subscribe in initState.
    // We access the global `nodeManager` instance directly.
    _node = nodeManager.subscribeToNode(
      widget.nodeId,
    );
    _isSubscribed = true;
  }
  
  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder listens to the notifier and rebuilds only this widget
    // when notifyListeners() is called.
    return AnimatedBuilder(
      animation: _node,
      builder: (context, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Widget for Node ID: '${_node.id}'",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                 Text(
                  "Subscribed to fields: ${widget.subscribedFields}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Divider(height: 20),
                Text("Name: ${_node.data['name'] ?? 'N/A'}"),
                Text("Score: ${_node.data['score'] ?? 'N/A'}"),
              ],
            ),
          ),
        );
      },
    );
  }
}