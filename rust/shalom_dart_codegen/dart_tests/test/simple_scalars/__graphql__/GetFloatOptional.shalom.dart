




// Generate enums first


// Then generate classes

/// GetFloatOptional class with selected fields from query

class RequestGetFloatOptional {
  /// Class fields
  
  
  final double? floatOptional;
  
  

  /// Constructor
  RequestGetFloatOptional({
    
    this.floatOptional,
    
  });

  /// Creates from JSON
  factory RequestGetFloatOptional.fromJson(Map<String, dynamic> json) => RequestGetFloatOptional(
    
    floatOptional: 
      json['floatOptional'] as double?
    ,
    
  );

  /// Updates from JSON
  RequestGetFloatOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetFloatOptional(
      
      floatOptional: 
        data.containsKey('floatOptional') 
          ? data['floatOptional'] as double?
          : this.floatOptional
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'floatOptional': 
      floatOptional
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetFloatOptional &&
          
          other.floatOptional == floatOptional &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    floatOptional,
    
  ]);
}


