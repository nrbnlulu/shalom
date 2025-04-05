




// Generate enums first


// Then generate classes

/// GetString class with selected fields from query

class RequestGetString {
  /// Class fields
  
  
  final String string;
  
  

  /// Constructor
  RequestGetString({
    
    required this.string,
    
  });

  /// Creates from JSON
  factory RequestGetString.fromJson(Map<String, dynamic> json) => RequestGetString(
    
    string: 
      json['string'] as String
    ,
    
  );

  /// Updates from JSON
  RequestGetString updateWithJson(Map<String, dynamic> data) {
    return RequestGetString(
      
      string: 
        data.containsKey('string') 
          ? data['string'] as String
          : this.string
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'string': 
      string
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetString &&
          
          other.string == string &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    string,
    
  ]);
}






    
