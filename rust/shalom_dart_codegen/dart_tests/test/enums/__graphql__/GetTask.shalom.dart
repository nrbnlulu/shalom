






// Then generate classes


/// GetTask class with selected fields from query

class RequestGetTask {
  /// Class fields
  
  
  final RequestGetTaskTask? task;
  
  

  /// Constructor
  RequestGetTask({
    
    this.task,
    
  });

  /// Creates from JSON
  factory RequestGetTask.fromJson(Map<String, dynamic> json) => RequestGetTask(
    
    task: 
      json['task'] != null 
        ? RequestGetTaskTask.fromJson(json['task'] as Map<String, dynamic>)
        : null
    ,
    
  );

  /// Updates from JSON
  RequestGetTask updateWithJson(Map<String, dynamic> data) {
    return RequestGetTask(
      
      task: 
        data.containsKey('task') 
          ? (data['task'] != null 
              ? RequestGetTaskTask.fromJson(data['task'] as Map<String, dynamic>)
              : null)
          : task
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'task': 
      task?.toJson()
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetTask &&
          
          other.task == task &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    task,
    
  ]);
}




/// GetTaskTask class with selected fields from query

class RequestGetTaskTask {
  /// Class fields
  
  
  final String id;
  
  
  
  final String name;
  
  
  
  final RequestGetTaskStatus status;
  
  

  /// Constructor
  RequestGetTaskTask({
    
    required this.id,
    
    required this.name,
    
    required this.status,
    
  });

  /// Creates from JSON
  factory RequestGetTaskTask.fromJson(Map<String, dynamic> json) => RequestGetTaskTask(
    
    id: 
      json['id'] as String
    ,
    
    name: 
      json['name'] as String
    ,
    
    status: 
      RequestGetTaskStatus.fromJson(json['status'] as String)
    ,
    
  );

  /// Updates from JSON
  RequestGetTaskTask updateWithJson(Map<String, dynamic> data) {
    return RequestGetTaskTask(
      
      id: 
        data.containsKey('id') 
          ? data['id'] as String
          : id
      ,
      
      name: 
        data.containsKey('name') 
          ? data['name'] as String
          : name
      ,
      
      status: 
        data.containsKey('status')
          ? RequestGetTaskStatus.fromJson(data['status'] as String)
          : RequestGetTaskstatus
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'id': 
      id
    ,
    
    'name': 
      name
    ,
    
    'status': 
      status.toJson()
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetTaskTask &&
          
          other.id == id &&
          
          other.name == name &&
          
          other.status == status &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    id,
    
    name,
    
    status,
    
  ]);
}



// Generate enums first



/// Status enum type

enum RequestStatus {
  
  COMPLETED('COMPLETED'),
  
  FAILED('FAILED'),
  
  PENDING('PENDING'),
  
  PROCESSING('PROCESSING'),
  

  final String value;
  const RequestStatus(this.value);

  factory RequestStatus.fromJson(String json) => 
    values.firstWhere((e) => e.value == json, orElse: () => throw ArgumentError('Unknown RequestStatus value: $json'));

  String toJson() => value;

  static List<RequestStatus> get values => [
    
    COMPLETED,
    
    FAILED,
    
    PENDING,
    
    PROCESSING,
    
  ];
}



