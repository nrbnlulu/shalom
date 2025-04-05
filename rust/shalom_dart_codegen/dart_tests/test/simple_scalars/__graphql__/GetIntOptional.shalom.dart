




// Generate enums first


// Then generate classes

/// GetIntOptional class with selected fields from query

class RequestGetIntOptional {
  /// Class fields
  
  
  final int? intOptional;
  
  

  /// Constructor
  RequestGetIntOptional({
    
    this.intOptional,
    
  });

  /// Creates from JSON
  factory RequestGetIntOptional.fromJson(Map<String, dynamic> json) => RequestGetIntOptional(
    
    intOptional: 
      json['intOptional'] as int?
    ,
    
  );

  /// Updates from JSON
  RequestGetIntOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetIntOptional(
      
      intOptional: 
        data.containsKey('intOptional') 
          ? data['intOptional'] as int?
          : this.intOptional
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'intOptional': 
      intOptional
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetIntOptional &&
          
          other.intOptional == intOptional &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    intOptional,
    
  ]);
}


