




// Generate enums first


// Then generate classes

/// GetFloat class with selected fields from query

class RequestGetFloat {
  /// Class fields
  
  
  final double float;
  
  

  /// Constructor
  RequestGetFloat({
    
    required this.float,
    
  });

  /// Creates from JSON
  factory RequestGetFloat.fromJson(Map<String, dynamic> json) => RequestGetFloat(
    
    float: 
      json['float'] as double
    ,
    
  );

  /// Updates from JSON
  RequestGetFloat updateWithJson(Map<String, dynamic> data) {
    return RequestGetFloat(
      
      float: 
        data.containsKey('float') 
          ? data['float'] as double
          : this.float
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'float': 
      float
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetFloat &&
          
          other.float == float &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    float,
    
  ]);
}






    
