




// Generate enums first




enum RequestGetTaskStatus {
  
  COMPLETED,
  
  FAILED,
  
  PENDING,
  
  PROCESSING,
  ;
  
  static RequestGetTaskStatus fromString(String value) {
    return RequestGetTaskStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => throw ArgumentError('Unknown RequestGetTaskStatus: $value'),
    );
  }

  @override
  String toString() => name.toUpperCase();
}




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
          : this.task
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
      RequestGetTaskStatus.fromString(json['status'] as String)
    ,
    
  );

  /// Updates from JSON
  RequestGetTaskTask updateWithJson(Map<String, dynamic> data) {
    return RequestGetTaskTask(
      
      id: 
        data.containsKey('id') 
          ? data['id'] as String
          : this.id
      ,
      
      name: 
        data.containsKey('name') 
          ? data['name'] as String
          : this.name
      ,
      
      status: 
        data.containsKey('status')
          ? RequestGetTaskStatus.fromString(data['status'] as String)
          : this.status
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
      status.toString()
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

