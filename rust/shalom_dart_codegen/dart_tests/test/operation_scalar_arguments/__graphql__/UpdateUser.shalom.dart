
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class UpdateUserResponse{

    /// class members
    
        
            final UpdateUser_updateUser? updateUser;
        
    
    // keywordargs constructor
    UpdateUserResponse({
    
        this.updateUser,
    
    });
    static UpdateUserResponse fromJson(JsonObject data) {
    
        
            final UpdateUser_updateUser? updateUser_value;
            
                final JsonObject? updateUser$raw = data['updateUser']; 
                if (updateUser$raw != null) {
                    updateUser_value = UpdateUser_updateUser.fromJson(updateUser$raw);
                } else {
                    updateUser_value = null;
                }
            
        
    
    return UpdateUserResponse(
    
        
        updateUser: updateUser_value,
    
    );
    }
    UpdateUserResponse updateWithJson(JsonObject data) {
    
        
        final UpdateUser_updateUser? updateUser_value;
        if (data.containsKey('updateUser')) {
            
                final JsonObject? updateUser$raw = data['updateUser']; 
                if (updateUser$raw != null) {
                    updateUser_value = UpdateUser_updateUser.fromJson(updateUser$raw);
                } else {
                    updateUser_value = null;
                }
            
        } else {
            updateUser_value = updateUser;
        }
        
    
    return UpdateUserResponse(
    
        
        updateUser: updateUser_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdateUserResponse &&
    
        other.updateUser == updateUser 
    
    );
    }
    @override
    int get hashCode =>
    
        updateUser.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateUser':
            
                updateUser?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class UpdateUser_updateUser  {
        
    /// class members
    
        
            final String? email;
        
    
        
            final String? name;
        
    
        
            final String? phone;
        
    
    // keywordargs constructor
    UpdateUser_updateUser({
    
        this.email,
    
        this.name,
    
        this.phone,
    
    });
    static UpdateUser_updateUser fromJson(JsonObject data) {
    
        
            final String? email_value = data['email'];
        
    
        
            final String? name_value = data['name'];
        
    
        
            final String? phone_value = data['phone'];
        
    
    return UpdateUser_updateUser(
    
        
        email: email_value,
    
        
        name: name_value,
    
        
        phone: phone_value,
    
    );
    }
    UpdateUser_updateUser updateWithJson(JsonObject data) {
    
        
            final String? email_value;
            if (data.containsKey('email')) {
            email_value = data['email'];
            } else {
            email_value = email;
            }
        
    
        
            final String? name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            final String? phone_value;
            if (data.containsKey('phone')) {
            phone_value = data['phone'];
            } else {
            phone_value = phone;
            }
        
    
    return UpdateUser_updateUser(
    
        
        email: email_value,
    
        
        name: name_value,
    
        
        phone: phone_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdateUser_updateUser &&
    
        other.email == email &&
    
        other.name == name &&
    
        other.phone == phone 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            email,
        
            
            name,
        
            
            phone,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'email':
            
                email
            
        ,
    
        
        'name':
            
                name
            
        ,
    
        
        'phone':
            
                phone
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestUpdateUser extends Requestable {
    
    final UpdateUserVariables variables;
    

    RequestUpdateUser(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation UpdateUser($phone: String) {
  updateUser(phone: $phone) {
    email
    name
    phone
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'UpdateUser'
        );
    }
}


class UpdateUserVariables {
    
        final Option<String?> phone;
    

    UpdateUserVariables(
        
            {
            
                
                    this.phone  = const None() ,
                
              
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        
             
               if (phone.isSome()) {
                  data["phone"] = phone.some();
               } 
           
        
        return data;
    } 
}
