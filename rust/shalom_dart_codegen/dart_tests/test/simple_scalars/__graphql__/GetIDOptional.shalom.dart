




// Generate enums first


// Then generate classes

/// GetIDOptional class with selected fields from query

class RequestGetIDOptional {
  /// Class fields
  
  
  final String? idOptional;
  
  

  /// Constructor
  RequestGetIDOptional({
    
    this.idOptional,
    
  });

  /// Creates from JSON
  factory RequestGetIDOptional.fromJson(Map<String, dynamic> json) => RequestGetIDOptional(
    
    idOptional: 
      json['idOptional'] as String?
    ,
    
  );

  /// Updates from JSON
  RequestGetIDOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetIDOptional(
      
      idOptional: 
        data.containsKey('idOptional') 
          ? data['idOptional'] as String?
          : this.idOptional
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'idOptional': 
      idOptional
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetIDOptional &&
          
          other.idOptional == idOptional &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    idOptional,
    
  ]);
}


