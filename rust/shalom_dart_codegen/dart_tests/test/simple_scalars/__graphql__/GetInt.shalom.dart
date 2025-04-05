




// Generate enums first


// Then generate classes

/// GetInt class with selected fields from query

class RequestGetInt {
  /// Class fields
  
  
  final int intField;
  
  

  /// Constructor
  RequestGetInt({
    
    required this.intField,
    
  });

  /// Creates from JSON
  factory RequestGetInt.fromJson(Map<String, dynamic> json) => RequestGetInt(
    
    intField: 
      json['intField'] as int
    ,
    
  );

  /// Updates from JSON
  RequestGetInt updateWithJson(Map<String, dynamic> data) {
    return RequestGetInt(
      
      intField: 
        data.containsKey('intField') 
          ? data['intField'] as int
          : this.intField
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'intField': 
      intField
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetInt &&
          
          other.intField == intField &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    intField,
    
  ]);
}


