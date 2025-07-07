
























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OptionalWithNullDefaultResponse{

    /// class members
    
        final OptionalWithNullDefault_updateUser? updateUser;
    
    // keywordargs constructor
    OptionalWithNullDefaultResponse({
    
        this.updateUser,
    
    });
    static OptionalWithNullDefaultResponse fromJson(JsonObject data) {
    
        
        final OptionalWithNullDefault_updateUser? updateUser_value;
        
            updateUser_value = 
    
        
            data["updateUser"] == null ? null : OptionalWithNullDefault_updateUser.fromJson(data["updateUser"])
        
    
;
        
    
    return OptionalWithNullDefaultResponse(
    
        
        updateUser: updateUser_value,
    
    );
    }
    OptionalWithNullDefaultResponse updateWithJson(JsonObject data) {
    
        
        final OptionalWithNullDefault_updateUser? updateUser_value;
        if (data.containsKey('updateUser')) {
            
                updateUser_value = 
    
        
            data["updateUser"] == null ? null : OptionalWithNullDefault_updateUser.fromJson(data["updateUser"])
        
    
;
            
        } else {
            updateUser_value = updateUser;
        }
    
    return OptionalWithNullDefaultResponse(
    
        
        updateUser: updateUser_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithNullDefaultResponse &&
    
        
    
        other.updateUser == updateUser
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateUser.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateUser':
            
                
    
        
            this.updateUser?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OptionalWithNullDefault_updateUser  {
        
    /// class members
    
        final String? email;
    
        final String? name;
    
        final String? phone;
    
    // keywordargs constructor
    OptionalWithNullDefault_updateUser({
    
        this.email,
    
        this.name,
    
        this.phone,
    
    });
    static OptionalWithNullDefault_updateUser fromJson(JsonObject data) {
    
        
        final String? email_value;
        
            email_value = 
    
        
            
                data["email"] as 
    String
?
            
        
    
;
        
    
        
        final String? name_value;
        
            name_value = 
    
        
            
                data["name"] as 
    String
?
            
        
    
;
        
    
        
        final String? phone_value;
        
            phone_value = 
    
        
            
                data["phone"] as 
    String
?
            
        
    
;
        
    
    return OptionalWithNullDefault_updateUser(
    
        
        email: email_value,
    
        
        name: name_value,
    
        
        phone: phone_value,
    
    );
    }
    OptionalWithNullDefault_updateUser updateWithJson(JsonObject data) {
    
        
        final String? email_value;
        if (data.containsKey('email')) {
            
                email_value = 
    
        
            
                data["email"] as 
    String
?
            
        
    
;
            
        } else {
            email_value = email;
        }
    
        
        final String? name_value;
        if (data.containsKey('name')) {
            
                name_value = 
    
        
            
                data["name"] as 
    String
?
            
        
    
;
            
        } else {
            name_value = name;
        }
    
        
        final String? phone_value;
        if (data.containsKey('phone')) {
            
                phone_value = 
    
        
            
                data["phone"] as 
    String
?
            
        
    
;
            
        } else {
            phone_value = phone;
        }
    
    return OptionalWithNullDefault_updateUser(
    
        
        email: email_value,
    
        
        name: name_value,
    
        
        phone: phone_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithNullDefault_updateUser &&
    
        
    
        other.email == email
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
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
            
                
    
        
            this.email
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'phone':
            
                
    
        
            this.phone
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestOptionalWithNullDefault extends Requestable {
    
    final OptionalWithNullDefaultVariables variables;
    

    RequestOptionalWithNullDefault(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OptionalWithNullDefault($phone: String = null) {
  updateUser(phone: $phone) {
    email
    name
    phone
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            StringopName: 'OptionalWithNullDefault'
        );
    }
}


class OptionalWithNullDefaultVariables {
    
    
        final String? phone;
    

    OptionalWithNullDefaultVariables (
        
            {
            

    
        
            
            
                this.phone
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["phone"] = 
    
        this.phone
    
;
    


        return data;
    }

    
OptionalWithNullDefaultVariables updateWith(
    {
        
            
                Option<String?> phone = const None()
            
            
        
    }
) {
    
        final String? phone$next;
        
            switch (phone) {

                case Some(value: final updateData):
                    phone$next = updateData;
                case None():
                    phone$next = this.phone;
            }

        
    
    return OptionalWithNullDefaultVariables(
        
            phone: phone$next
            
        
    );
}


}
