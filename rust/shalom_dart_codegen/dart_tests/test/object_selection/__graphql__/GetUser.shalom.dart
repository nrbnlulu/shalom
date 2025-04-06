



// Then generate classes

/// GetUser class with selected fields from query

class RequestGetUser {
  /// Class fields
  
  
  final RequestGetUserUser? user;
  
  

  /// Constructor
  RequestGetUser({
    
    this.user,
    
  });

  /// Creates from JSON
  factory RequestGetUser.fromJson(Map<String, dynamic> json) => RequestGetUser(
    
    user: 
      json['user'] != null 
        ? RequestGetUserUser.fromJson(json['user'] as Map<String, dynamic>)
        : null
    ,
    
  );

  /// Updates from JSON
  RequestGetUser updateWithJson(Map<String, dynamic> data) {
    return RequestGetUser(
      
      user: 
        data.containsKey('user') 
          ? (data['user'] != null 
              ? RequestGetUserUser.fromJson(data['user'] as Map<String, dynamic>)
              : null)
          : this.user
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'user': 
      user?.toJson()
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetUser &&
          
          other.user == user &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    user,
    
  ]);
}






    
        
/// GetUserUser class with selected fields from query

class RequestGetUserUser {
  /// Class fields
  
  
  final String id;
  
  
  
  final String name;
  
  
  
  final String email;
  
  
  
  final int? age;
  
  

  /// Constructor
  RequestGetUserUser({
    
    required this.id,
    
    required this.name,
    
    required this.email,
    
    this.age,
    
  });

  /// Creates from JSON
  factory RequestGetUserUser.fromJson(Map<String, dynamic> json) => RequestGetUserUser(
    
    id: 
      json['id'] as String
    ,
    
    name: 
      json['name'] as String
    ,
    
    email: 
      json['email'] as String
    ,
    
    age: 
      json['age'] as int?
    ,
    
  );

  /// Updates from JSON
  RequestGetUserUser updateWithJson(Map<String, dynamic> data) {
    return RequestGetUserUser(
      
      id: 
        data.containsKey('id') 
          ? data['id'] as String
          : this.id
      ,
      
      name: 
        data.containsKey('name') 
          ? data['name'] as String
          : this.name
      ,
      
      email: 
        data.containsKey('email') 
          ? data['email'] as String
          : this.email
      ,
      
      age: 
        data.containsKey('age') 
          ? data['age'] as int?
          : this.age
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'id': 
      id
    ,
    
    'name': 
      name
    ,
    
    'email': 
      email
    ,
    
    'age': 
      age
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetUserUser &&
          
          other.id == id &&
          
          other.name == name &&
          
          other.email == email &&
          
          other.age == age &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    id,
    
    name,
    
    email,
    
    age,
    
  ]);
}

        
    

    
