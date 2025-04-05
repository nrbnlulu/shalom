




// Generate enums first


// Then generate classes

/// GetBoolean class with selected fields from query

class RequestGetBoolean {
  /// Class fields
  
  
  final bool boolean;
  
  

  /// Constructor
  RequestGetBoolean({
    
    required this.boolean,
    
  });

  /// Creates from JSON
  factory RequestGetBoolean.fromJson(Map<String, dynamic> json) => RequestGetBoolean(
    
    boolean: 
      json['boolean'] as bool
    ,
    
  );

  /// Updates from JSON
  RequestGetBoolean updateWithJson(Map<String, dynamic> data) {
    return RequestGetBoolean(
      
      boolean: 
        data.containsKey('boolean') 
          ? data['boolean'] as bool
          : this.boolean
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'boolean': 
      boolean
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetBoolean &&
          
          other.boolean == boolean &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    boolean,
    
  ]);
}


