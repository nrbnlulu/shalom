

// ignore_for_file: non_constant_identifier_names

class 
    RequestGetUser
{

    /// class memberes
    
        
        
            final GetUserUser? user;
        
    
    // keywordargs constructor
    
    RequestGetUser
({
    
        
        
        this.user,
    
    });
    static 
    RequestGetUser
 fromJson(Map<String , dynamic> data) {
    
        
        
            final GetUserUser? user_value;
            if (data['user'] != null) {
            
                
            
            user_value = GetUserUser.fromJson(data['user'] as Map<String , dynamic>);
            } else {
            
                user_value = null;
            
            }
        
    
    return 
    RequestGetUser
(
    
        
        user: user_value,
    
    );
    }
    
    RequestGetUser
 updateWithJson(Map<String , dynamic> data) {
    
        
        
            final GetUserUser? user_value;
            if (data.containsKey('user')) {
            final Map<String, dynamic>? user_raw = data['user'];
            if (user_raw != null) {
            
                
            
            user_value = GetUserUser.fromJson(user_raw);
            } else {
            
                user_value = null;
            
            }
            } else {
            user_value = user;
            }
        
    
    return 
    RequestGetUser
(
    
        
        user: user_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetUser
 &&
    
        
        other.user == user &&
    
    true);
    }
    @override
    int get hashCode =>
    
        user.hashCode;
    
    Map<String , dynamic> toJson() {
    return {
    
        
        'user':
        
            user?.toJson()
        
        ,
    
    };
    }

}


    
        
            
        
        class GetUserUser  {
        
    /// class memberes
    
        
        
            final String id;
        
    
        
        
            final String name;
        
    
        
        
            final String email;
        
    
        
        
            final int? age;
        
    
    // keywordargs constructor
    GetUserUser({
    
        
        required
        this.id,
    
        
        required
        this.name,
    
        
        required
        this.email,
    
        
        
        this.age,
    
    });
    static GetUserUser fromJson(Map<String , dynamic> data) {
    
        
        
            final String id_value;
            id_value = data['id'] as String;
        
    
        
        
            final String name_value;
            name_value = data['name'] as String;
        
    
        
        
            final String email_value;
            email_value = data['email'] as String;
        
    
        
        
            final int? age_value;
            age_value = data['age'] as int?;
        
    
    return GetUserUser(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    GetUserUser updateWithJson(Map<String , dynamic> data) {
    
        
        
            final String id_value;
            if (data.containsKey('id')) {
            id_value = data['id'] as String;
            } else {
            id_value = id;
            }
        
    
        
        
            final String name_value;
            if (data.containsKey('name')) {
            name_value = data['name'] as String;
            } else {
            name_value = name;
            }
        
    
        
        
            final String email_value;
            if (data.containsKey('email')) {
            email_value = data['email'] as String;
            } else {
            email_value = email;
            }
        
    
        
        
            final int? age_value;
            if (data.containsKey('age')) {
            age_value = data['age'] as int?;
            } else {
            age_value = age;
            }
        
    
    return GetUserUser(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetUserUser &&
    
        
        other.id == id &&
    
        
        other.name == name &&
    
        
        other.email == email &&
    
        
        other.age == age &&
    
    true);
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            email,
        
            
            age,
        
        ]);
    
    Map<String , dynamic> toJson() {
    return {
    
        
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
    }

        }
        
    

    
