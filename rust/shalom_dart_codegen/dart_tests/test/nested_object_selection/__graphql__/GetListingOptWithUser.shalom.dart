
























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListingOptWithUserResponse{

    /// class members
    
        final GetListingOptWithUser_listingOpt? listingOpt;
    
    // keywordargs constructor
    GetListingOptWithUserResponse({
    
        this.listingOpt,
    
    });
    static GetListingOptWithUserResponse fromJson(JsonObject data) {
    
        
        final GetListingOptWithUser_listingOpt? listingOpt_value;
        
            listingOpt_value = 
    
        
            data["listingOpt"] == null ? null : GetListingOptWithUser_listingOpt.fromJson(data["listingOpt"])
        
    
;
        
    
    return GetListingOptWithUserResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    GetListingOptWithUserResponse updateWithJson(JsonObject data) {
    
        
        final GetListingOptWithUser_listingOpt? listingOpt_value;
        if (data.containsKey('listingOpt')) {
            
                listingOpt_value = 
    
        
            data["listingOpt"] == null ? null : GetListingOptWithUser_listingOpt.fromJson(data["listingOpt"])
        
    
;
            
        } else {
            listingOpt_value = listingOpt;
        }
    
    return GetListingOptWithUserResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOptWithUserResponse &&
    
        
    
        other.listingOpt == listingOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        listingOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'listingOpt':
            
                
    
        
            this.listingOpt?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetListingOptWithUser_listingOpt  {
        
    /// class members
    
        final String id;
    
        final String name;
    
        final int? price;
    
        final GetListingOptWithUser_listingOpt_user user;
    
    // keywordargs constructor
    GetListingOptWithUser_listingOpt({
    required
        this.id,
    required
        this.name,
    
        this.price,
    required
        this.user,
    
    });
    static GetListingOptWithUser_listingOpt fromJson(JsonObject data) {
    
        
        final String id_value;
        
            id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
        
    
        
        final String name_value;
        
            name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
        
    
        
        final int? price_value;
        
            price_value = 
    
        
            
                data["price"] as 
    int
?
            
        
    
;
        
    
        
        final GetListingOptWithUser_listingOpt_user user_value;
        
            user_value = 
    
        
            GetListingOptWithUser_listingOpt_user.fromJson(data["user"])
        
    
;
        
    
    return GetListingOptWithUser_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
    );
    }
    GetListingOptWithUser_listingOpt updateWithJson(JsonObject data) {
    
        
        final String id_value;
        if (data.containsKey('id')) {
            
                id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
            
        } else {
            id_value = id;
        }
    
        
        final String name_value;
        if (data.containsKey('name')) {
            
                name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
            
        } else {
            name_value = name;
        }
    
        
        final int? price_value;
        if (data.containsKey('price')) {
            
                price_value = 
    
        
            
                data["price"] as 
    int
?
            
        
    
;
            
        } else {
            price_value = price;
        }
    
        
        final GetListingOptWithUser_listingOpt_user user_value;
        if (data.containsKey('user')) {
            
                user_value = 
    
        
            GetListingOptWithUser_listingOpt_user.fromJson(data["user"])
        
    
;
            
        } else {
            user_value = user;
        }
    
    return GetListingOptWithUser_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOptWithUser_listingOpt &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.price == price
    
 &&
    
        
    
        other.user == user
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            price,
        
            
            user,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'price':
            
                
    
        
            this.price
        
    

            
        ,
    
        
        'user':
            
                
    
        
            this.user.toJson()
        
    

            
        ,
    
    };
    }

    }

    class GetListingOptWithUser_listingOpt_user  {
        
    /// class members
    
        final String id;
    
        final String name;
    
        final String email;
    
        final int? age;
    
    // keywordargs constructor
    GetListingOptWithUser_listingOpt_user({
    required
        this.id,
    required
        this.name,
    required
        this.email,
    
        this.age,
    
    });
    static GetListingOptWithUser_listingOpt_user fromJson(JsonObject data) {
    
        
        final String id_value;
        
            id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
        
    
        
        final String name_value;
        
            name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
        
    
        
        final String email_value;
        
            email_value = 
    
        
            
                data["email"] as 
    String

            
        
    
;
        
    
        
        final int? age_value;
        
            age_value = 
    
        
            
                data["age"] as 
    int
?
            
        
    
;
        
    
    return GetListingOptWithUser_listingOpt_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    GetListingOptWithUser_listingOpt_user updateWithJson(JsonObject data) {
    
        
        final String id_value;
        if (data.containsKey('id')) {
            
                id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
            
        } else {
            id_value = id;
        }
    
        
        final String name_value;
        if (data.containsKey('name')) {
            
                name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
            
        } else {
            name_value = name;
        }
    
        
        final String email_value;
        if (data.containsKey('email')) {
            
                email_value = 
    
        
            
                data["email"] as 
    String

            
        
    
;
            
        } else {
            email_value = email;
        }
    
        
        final int? age_value;
        if (data.containsKey('age')) {
            
                age_value = 
    
        
            
                data["age"] as 
    int
?
            
        
    
;
            
        } else {
            age_value = age;
        }
    
    return GetListingOptWithUser_listingOpt_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOptWithUser_listingOpt_user &&
    
        
    
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


class RequestGetListingOptWithUser extends Requestable {
    

    RequestGetListingOptWithUser(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetListingOptWithUser {
  listingOpt {
    id
    name
    price
    user {
      id
      name
      email
      age
    }
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            StringopName: 'GetListingOptWithUser'
        );
    }
}

