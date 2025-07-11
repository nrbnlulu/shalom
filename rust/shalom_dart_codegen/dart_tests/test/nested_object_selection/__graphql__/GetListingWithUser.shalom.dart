





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListingWithUserResponse {

    /// class members
    
            
            final GetListingWithUser_listing listing;
        
    
    // keywordargs constructor
    GetListingWithUserResponse({
    required
        this.listing,
    
    });
    
    
        GetListingWithUserResponse updateWithJson(JsonObject data) {
        
            
            final GetListingWithUser_listing listing_value;
            if (data.containsKey('listing')) {
                final listing$raw = data["listing"];
                listing_value = 
    
        
            GetListingWithUser_listing.fromJson(listing$raw)
        
    
;
            } else {
                listing_value = listing;
            }
        
        return GetListingWithUserResponse(
        
            
            listing: listing_value,
        
        );
        }
    
    static GetListingWithUserResponse fromJson(JsonObject data) {
    
        
        final GetListingWithUser_listing listing_value;
        final listing$raw = data["listing"];
        listing_value = 
    
        
            GetListingWithUser_listing.fromJson(listing$raw)
        
    
;
    
    return GetListingWithUserResponse(
    
        
        listing: listing_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUserResponse &&
    
        
    
        other.listing == listing
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        listing.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'listing':
            
                
    
        
            this.listing.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetListingWithUser_listing  {
        
    /// class members
    
            
            final String id;
        
    
            
            final String name;
        
    
            
            final int? price;
        
    
            
            final GetListingWithUser_listing_user user;
        
    
    // keywordargs constructor
    GetListingWithUser_listing({
    required
        this.id,
    required
        this.name,
    
        this.price,
    required
        this.user,
    
    });
    
    
        GetListingWithUser_listing updateWithJson(JsonObject data) {
        
            
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
        
            
            final int? price_value;
            if (data.containsKey('price')) {
                final price$raw = data["price"];
                price_value = 
    
        
            
                price$raw as int?
            
        
    
;
            } else {
                price_value = price;
            }
        
            
            final GetListingWithUser_listing_user user_value;
            if (data.containsKey('user')) {
                final user$raw = data["user"];
                user_value = 
    
        
            GetListingWithUser_listing_user.fromJson(user$raw)
        
    
;
            } else {
                user_value = user;
            }
        
        return GetListingWithUser_listing(
        
            
            id: id_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
            
            user: user_value,
        
        );
        }
    
    static GetListingWithUser_listing fromJson(JsonObject data) {
    
        
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
    
        
        final int? price_value;
        final price$raw = data["price"];
        price_value = 
    
        
            
                price$raw as int?
            
        
    
;
    
        
        final GetListingWithUser_listing_user user_value;
        final user$raw = data["user"];
        user_value = 
    
        
            GetListingWithUser_listing_user.fromJson(user$raw)
        
    
;
    
    return GetListingWithUser_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUser_listing &&
    
        
    
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

    class GetListingWithUser_listing_user  {
        
    /// class members
    
            
            final String id;
        
    
            
            final String name;
        
    
            
            final String email;
        
    
            
            final int? age;
        
    
    // keywordargs constructor
    GetListingWithUser_listing_user({
    required
        this.id,
    required
        this.name,
    required
        this.email,
    
        this.age,
    
    });
    
    
        GetListingWithUser_listing_user updateWithJson(JsonObject data) {
        
            
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
        
        return GetListingWithUser_listing_user(
        
            
            id: id_value,
        
            
            name: name_value,
        
            
            email: email_value,
        
            
            age: age_value,
        
        );
        }
    
    static GetListingWithUser_listing_user fromJson(JsonObject data) {
    
        
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
    
    return GetListingWithUser_listing_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUser_listing_user &&
    
        
    
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


class RequestGetListingWithUser extends Requestable {
    

    RequestGetListingWithUser(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetListingWithUser {
  listing {
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
            opName: 'GetListingWithUser'
        );
    }
}

