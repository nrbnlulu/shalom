














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListingWithUserResponse{

    /// class members
    
        
            final String listing_id;   
        
    
    // keywordargs constructor
    GetListingWithUserResponse({
    required
        this.listing,
    
    });
    static GetListingWithUserResponse fromJson(JsonObject data) {
    
        
            final GetListingWithUser_listing listing_value;
            
                listing_value = GetListingWithUser_listing.fromJson(data['listing']);            
            
        
    
    return GetListingWithUserResponse(
    
        
        listing: listing_value,
    
    );
    }
    GetListingWithUserResponse updateWithJson(JsonObject data) {
    
        
        final GetListingWithUser_listing listing_value;
        if (data.containsKey('listing')) {
            
                listing_value = GetListingWithUser_listing.fromJson(data['listing']);
            
        } else {
            listing_value = listing;
        }

    
    
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
            
                listing.toJson()
            
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
        
    
        
            final String user_id;   
        
    
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
    static GetListingWithUser_listing fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
        
            final int? price_value;
            
                price_value = data['price'];
            

        
    
        
            final GetListingWithUser_listing_user user_value;
            
                user_value = GetListingWithUser_listing_user.fromJson(data['user']);            
            
        
    
    return GetListingWithUser_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
    );
    }
    GetListingWithUser_listing updateWithJson(JsonObject data) {
    
        
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

        
    
        
    final int? price_value;
    if (data.containsKey('price')) {
        
            price_value = data['price'];
        
    } else {
        price_value = price;
    }

        
    
        
        final GetListingWithUser_listing_user user_value;
        if (data.containsKey('user')) {
            
                user_value = GetListingWithUser_listing_user.fromJson(data['user']);
            
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
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUser_listing &&
    
        other.id == id &&
    
        other.name == name &&
    
        other.price == price &&
    
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
            
                
                    id
                
            
        ,
    
        
        'name':
            
                
                    name
                
            
        ,
    
        
        'price':
            
                
                    price
                
            
        ,
    
        
        'user':
            
                user.toJson()
            
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
    static GetListingWithUser_listing_user fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
        
            final String email_value;
            
                email_value = data['email'];
            

        
    
        
            final int? age_value;
            
                age_value = data['age'];
            

        
    
    return GetListingWithUser_listing_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    GetListingWithUser_listing_user updateWithJson(JsonObject data) {
    
        
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
    
        other.id == id &&
    
        other.name == name &&
    
        other.email == email &&
    
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
            StringopName: 'GetListingWithUser'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetListingWithUserNode extends Node {
  GetListingWithUserResponse? obj = null;
  GetListingWithUserNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetListingWithUserResponse.fromJson(raw);
      manager.addOrUpdateNode(this);
     } else {
      throw Exception("must subscribe to node through manager");
     }
  }

  @override
  void updateWithJson(JsonObject newData) {
    final newObj = obj?.updateWithJson(newData);
    if (newObj != null) {
      obj = newObj;
      notifyListeners();
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }

  @override
  void convertToObjAndSet(JsonObject data) {
     obj = GetListingWithUserResponse.fromJson(data);
  }
  
  @override
  JsonObject data() {
    final data = obj?.toJson();
    if (data != null) {
        return data;
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }
} 
// ------------ END Node DEFINITIONS -------------