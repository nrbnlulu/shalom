




// Generate enums first


// Then generate classes

/// GetID class with selected fields from query

class RequestGetID {
  /// Class fields
  
  
  final String id;
  
  

  /// Constructor
  RequestGetID({
    
    required this.id,
    
  });

  /// Creates from JSON
  factory RequestGetID.fromJson(Map<String, dynamic> json) => RequestGetID(
    
    id: 
      json['id'] as String
    ,
    
  );

  /// Updates from JSON
  RequestGetID updateWithJson(Map<String, dynamic> data) {
    return RequestGetID(
      
      id: 
        data.containsKey('id') 
          ? data['id'] as String
          : this.id
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'id': 
      id
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetID &&
          
          other.id == id &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    id,
    
  ]);
}


