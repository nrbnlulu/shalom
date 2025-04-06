



// Then generate classes

/// GetStringOptional class with selected fields from query

class RequestGetStringOptional {
  /// Class fields
  
  
  final String? stringOptional;
  
  

  /// Constructor
  RequestGetStringOptional({
    
    this.stringOptional,
    
  });

  /// Creates from JSON
  factory RequestGetStringOptional.fromJson(Map<String, dynamic> json) => RequestGetStringOptional(
    
    stringOptional: 
      json['stringOptional'] as String?
    ,
    
  );

  /// Updates from JSON
  RequestGetStringOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetStringOptional(
      
      stringOptional: 
        data.containsKey('stringOptional') 
          ? data['stringOptional'] as String?
          : this.stringOptional
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'stringOptional': 
      stringOptional
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetStringOptional &&
          
          other.stringOptional == stringOptional &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    stringOptional,
    
  ]);
}






    
