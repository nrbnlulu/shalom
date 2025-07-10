





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetUserResponse {

    /// class members
    
        final GetUser_user? user;
    
    // keywordargs constructor
    GetUserResponse({
    
        this.user,
    
    });
    static GetUserResponse fromJson(JsonObject data) {
    
        
        final GetUser_user? user_value;
        final user$raw = data["user"];
        user_value = 
    
        
            user$raw == null ? null : GetUser_user.fromJson(user$raw)
        
    
;
    
    return GetUserResponse(
    
        
        user: user_value,
    
    );
    }
    GetUserResponse updateWithJson(JsonObject data) {
    
        
        final GetUser_user? user_value;
        if (data.containsKey('user')) {
            final user$raw = data["user"];
            user_value = 
    
        
            user$raw == null ? null : GetUser_user.fromJson(user$raw)
        
    
;
        } else {
            user_value = user;
        }
    
    return GetUserResponse(
    
        
        user: user_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetUserResponse &&
    
        
    
        other.user == user
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        user.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'user':
            
                
    
        
            this.user?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetUser_user  extends Node  {
        
    /// class members
    
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
    
        
        final String id_value;
        final id$raw = data["id"];
        id_value = 
    
        
            
                id$raw as String
            
        
    
;
    
        
        final String name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String
            
        
    
;
    
        
        final String email_value;
        final email$raw = data["email"];
        email_value = 
    
        
            
                email$raw as String
            
        
    
;
    
        
        final int? age_value;
        final age$raw = data["age"];
        age_value = 
    
        
            
                age$raw as int?
            
        
    
;
    
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
            final id$raw = data["id"];
            id_value = 
    
        
            
                id$raw as String
            
        
    
;
        } else {
            id_value = id;
        }
    
        
        final String name_value;
        if (data.containsKey('name')) {
            final name$raw = data["name"];
            name_value = 
    
        
            
                name$raw as String
            
        
    
;
        } else {
            name_value = name;
        }
    
        
        final String email_value;
        if (data.containsKey('email')) {
            final email$raw = data["email"];
            email_value = 
    
        
            
                email$raw as String
            
        
    
;
        } else {
            email_value = email;
        }
    
        
        final int? age_value;
        if (data.containsKey('age')) {
            final age$raw = data["age"];
            age_value = 
    
        
            
                age$raw as int?
            
        
    
;
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
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.email == email
    
 &&
    
        
    
        other.age == age
    
 
    
    );
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
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'email':
            
                
    
        
            this.email
        
    

            
        ,
    
        
        'age':
            
                
    
        
            this.age
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetUser extends Requestable {
    

    RequestGetUser(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetUser {
  user {
    id
    name
    email
    age
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetUser'
        );
    }
}

