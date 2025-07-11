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
