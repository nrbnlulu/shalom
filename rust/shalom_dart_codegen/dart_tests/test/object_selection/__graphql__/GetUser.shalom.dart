typedef JsonObject = Map<String, dynamic>;


// ignore_for_file: non_constant_identifier_names

class 
    RequestGetUser
{

    /// class memberes
    
        
            final GetUser_user? user;
        
    
    // keywordargs constructor
    
    RequestGetUser
({
    
        this.user,
    
    });
    static 
    RequestGetUser
 fromJson(JsonObject data) {
    
        
            final GetUser_user? user_value;
            
                final JsonObject? user$raw = data['user']; 
                if (user$raw != null) {
                    user_value = GetUser_user.fromJson(user$raw);
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
 updateWithJson(JsonObject data) {
    
        
        final GetUser_user? user_value;
        if (data.containsKey('user')) {
            
                final JsonObject? user$raw = data['user']; 
                if (user$raw != null) {
                    user_value = GetUser_user.fromJson(user$raw);
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
    
    JsonObject toJson() {
    return {
    
        
        'user':
            
                user?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetUser_user  {
        
    /// class memberes
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final String email;
        
    
        
            final int? age;
        
    
    // keywordargs constructor
    GetUser_user({
    required
        this.id,
    required
        this.name,
    required
        this.email,
    
        this.age,
    
    });
    static GetUser_user fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final String name_value = data['name'];
        
    
        
            final String email_value = data['email'];
        
    
        
            final int? age_value = data['age'];
        
    
    return GetUser_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    GetUser_user updateWithJson(JsonObject data) {
    
        
            final String id_value;
            if (data.containsKey('id')) {
            id_value = data['id'];
            } else {
            id_value = id;
            }
        
    
        
            final String name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            final String email_value;
            if (data.containsKey('email')) {
            email_value = data['email'];
            } else {
            email_value = email;
            }
        
    
        
            final int? age_value;
            if (data.containsKey('age')) {
            age_value = data['age'];
            } else {
            age_value = age;
            }
        
    
    return GetUser_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetUser_user &&
    
        
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
    
    JsonObject toJson() {
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


// ------------ END OBJECT DEFINITIONS -------------