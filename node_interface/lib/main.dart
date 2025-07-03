import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

typedef ID = String;
typedef JsonObject = Map<String, dynamic>;

abstract class Node extends ChangeNotifier {
  final ID id;
  Node({required this.id});
  void updateWithJson(JsonObject rawData, List<String> changedFields);
  JsonObject toJson();
  StreamSubscription<JsonObject> subscribeToChanges(ShalomContext context);
}


class NodeManager {
  Map<String, JsonObject> _rawStore = {};
  Map<String, StreamController<JsonObject>> _controllers = {};  

  void parseNodeData<T extends Node>(T node) {
    final nodeId = node.id;
    final controller = _controllers[nodeId];
    final nodeJson = node.toJson();
    _rawStore[nodeId] = nodeJson;
    if (controller != null) {
        controller.sink.add(nodeJson);  
    }
  }

  StreamSubscription<JsonObject> register<T extends Node>(T node, List<String> subscribedFields) {
    final nodeId = node.id;
    final StreamController<JsonObject> controller;
    final controllerFromMap = _controllers[nodeId];
    if (controllerFromMap != null) {
      controller = controllerFromMap;
    } else {
      controller = StreamController<JsonObject>.broadcast();
      _controllers[nodeId] = controller;
    }
    final stream = controller.stream;
    return stream.listen((data) => 
        node.updateWithJson(data["rawData"], data["changedFields"])
    );
  } 
}

class ShalomContext {
  final NodeManager manager;
  ShalomContext({required this.manager});
}

// someOp.dart
class SomeNode with ChangeNotifier implements Node {
  ID id;
  String myOwnField;
  String ect;
  SomeNode({required this.id, required this.myOwnField, required this.ect});

  static SomeNode deserialize(JsonObject data, ShalomContext context){
    final self = SomeNode.fromJson(data);
    context.manager.parseNodeData<SomeNode>(self);
    return self;
  }

  @override
  StreamSubscription<JsonObject> subscribeToChanges(ShalomContext context) {
    return context.manager.register<SomeNode>(this, ["myOwnField", "etc"]);
  }
  
  @override
  JsonObject toJson() {
    return {
      "myOwnField": myOwnField,
      "ect": ect,
      "id": id
    };
  } 
  
  @override
  void updateWithJson(JsonObject rawData, List<String> changedFields){
    for (final f_name in changedFields){
      switch (f_name){
        case 'myOwnField':
          myOwnField = rawData['myOwnField'];
          break;
        case 'ect':
          ect = rawData['ect'];
          break;
      }
    }
    notifyListeners();
  }

  static SomeNode fromJson(JsonObject data) {
    return SomeNode(id: data["id"], myOwnField: data["myOwnField"], ect: data["ect"]);
  }
}

class NodeWidget<T extends Node> extends StatefulWidget {
  final T node; 
  final Widget Function(BuildContext context, Node node) builder;
  final ShalomContext context;

  NodeWidget({
    super.key,
    required this.node,
    required this.builder, 
    required this.context
  }); 

  @override
  State<NodeWidget> createState() => _NodeWidgetState(); 
}

class _NodeWidgetState<T extends Node> extends State<NodeWidget<T>> {
    StreamSubscription<JsonObject>? _subscription;

    @override
    void initState() {
      super.initState();
      final node = widget.node; 
      _subscription = node.subscribeToChanges(widget.context);
    }

    @override
    void dispose() {
      _subscription?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return ListenableBuilder(listenable: widget.node,
      builder: (context, child) {
        return widget.builder(context, widget.node);
      });
    }
}


// ai generated code

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Initialize your state management system
  final NodeManager _manager = NodeManager();
  late final ShalomContext _shalomContext;
  late final SomeNode _node;

  @override
  void initState() {
    super.initState();
    _shalomContext = ShalomContext(manager: _manager);
    _node = SomeNode(
      id: "node_777",
      myOwnField: "Welcome!",
      ect: "Press the button to update.",
    );
    // Initialize the manager's store with the node's starting data
    _manager.parseNodeData(_node);
  }

  void _simulateServerUpdate() {
    // This simulates receiving new data from an external source
    final randomValue = Random().nextInt(1000);
    final updatedJson = {
      "id": "node_777", // Must match the ID of the node being displayed
      "myOwnField": "Data updated",
      "ect": "Your new random number is $randomValue",
    };

    // The manager processes the new data, which triggers the stream for the widget
    _manager.parseNodeData(SomeNode.fromJson(updatedJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reactive Node UI')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. Use your NodeWidget to display the reactive data
              NodeWidget<SomeNode>(
                node: _node,
                context: _shalomContext,
                builder: (context, node) {
                  // This builder automatically runs when the node changes
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${node.id}', style: const TextStyle(color: Colors.grey)),
                          const Divider(height: 20),
                          Text(
                            (node as SomeNode).myOwnField,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (node as SomeNode).ect,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.sync),
                label: const Text('Simulate Data Update'),
                onPressed: _simulateServerUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
