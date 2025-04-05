




// Generate enums first


// Then generate classes

/// GetBooleanOptional class with selected fields from query

class RequestGetBooleanOptional {
  /// Class fields
  
  
  final bool? booleanOptional;
  
  

  /// Constructor
  RequestGetBooleanOptional({
    
    this.booleanOptional,
    
  });

  /// Creates from JSON
  factory RequestGetBooleanOptional.fromJson(Map<String, dynamic> json) => RequestGetBooleanOptional(
    
    booleanOptional: 
      json['booleanOptional'] as bool?
    ,
    
  );

  /// Updates from JSON
  RequestGetBooleanOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetBooleanOptional(
      
      booleanOptional: 
        data.containsKey('booleanOptional') 
          ? data['booleanOptional'] as bool?
          : this.booleanOptional
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'booleanOptional': 
      booleanOptional
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetBooleanOptional &&
          
          other.booleanOptional == booleanOptional &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    booleanOptional,
    
  ]);
}






    
