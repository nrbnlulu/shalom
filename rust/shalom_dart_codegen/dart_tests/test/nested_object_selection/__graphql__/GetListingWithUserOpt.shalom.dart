














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListingWithUserOptResponse{

    /// class members
    
        
            final String listing_id;   
        
    
    // keywordargs constructor
    GetListingWithUserOptResponse({
    required
        this.listing,
    
    });
    static GetListingWithUserOptResponse fromJson(JsonObject data) {
    
        
            final GetListingWithUserOpt_listing listing_value;
            
                listing_value = GetListingWithUserOpt_listing.fromJson(data['listing']);            
            
        
    
    return GetListingWithUserOptResponse(
    
        
        listing: listing_value,
    
    );
    }
    GetListingWithUserOptResponse updateWithJson(JsonObject data) {
    
        
        final GetListingWithUserOpt_listing listing_value;
        if (data.containsKey('listing')) {
            
                listing_value = GetListingWithUserOpt_listing.fromJson(data['listing']);
            
        } else {
            listing_value = listing;
        }

    
    
    return GetListingWithUserOptResponse(
    
        
        listing: listing_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUserOptResponse &&
    
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


    class GetListingWithUserOpt_listing  {
        
    /// class members
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final int? price;
        
    
        
            final String userOpt_id;   
        
    
    // keywordargs constructor
    GetListingWithUserOpt_listing({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
        this.userOpt,
    
    });
    static GetListingWithUserOpt_listing fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
        
            final int? price_value;
            
                price_value = data['price'];
            

        
    
        
            final GetListingWithUserOpt_listing_userOpt? userOpt_value;
            
                final JsonObject? userOpt$raw = data['userOpt']; 
                if (userOpt$raw != null) {
                    userOpt_value = GetListingWithUserOpt_listing_userOpt.fromJson(userOpt$raw);
                } else {
                    userOpt_value = null;
                }
            
        
    
    return GetListingWithUserOpt_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        userOpt: userOpt_value,
    
    );
    }
    GetListingWithUserOpt_listing updateWithJson(JsonObject data) {
    
        
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

        
    
        
        final GetListingWithUserOpt_listing_userOpt? userOpt_value;
        if (data.containsKey('userOpt')) {
            
                final JsonObject? userOpt$raw = data['userOpt'];
                if (userOpt$raw != null) {
                    userOpt_value = GetListingWithUserOpt_listing_userOpt.fromJson(userOpt$raw);
                } else {
                    userOpt_value = null;
                }
            
        } else {
            userOpt_value = userOpt;
        }

    
    
    return GetListingWithUserOpt_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        userOpt: userOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUserOpt_listing &&
    
        other.id == id &&
    
        other.name == name &&
    
        other.price == price &&
    
        other.userOpt == userOpt 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            price,
        
            
            userOpt,
        
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
    
        
        'userOpt':
            
                userOpt?.toJson()
            
        ,
    
    };
    }

    }

    class GetListingWithUserOpt_listing_userOpt  {
        
    /// class members
    
        
            final String id;
        
    
        
            final String name;
        
    
    // keywordargs constructor
    GetListingWithUserOpt_listing_userOpt({
    required
        this.id,
    required
        this.name,
    
    });
    static GetListingWithUserOpt_listing_userOpt fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
    return GetListingWithUserOpt_listing_userOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
    );
    }
    GetListingWithUserOpt_listing_userOpt updateWithJson(JsonObject data) {
    
        
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

        
    
    return GetListingWithUserOpt_listing_userOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingWithUserOpt_listing_userOpt &&
    
        other.id == id &&
    
        other.name == name 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
                    id
                
            
        ,
    
        
        'name':
            
                
                    name
                
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetListingWithUserOpt extends Requestable {
    

    RequestGetListingWithUserOpt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetListingWithUserOpt {
  listing {
    id
    name
    price
    userOpt {
      id
      name
    }
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetListingWithUserOpt'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetListingWithUserOptNode extends Node {
  GetListingWithUserOptResponse? obj = null;
  GetListingWithUserOptNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetListingWithUserOptResponse.fromJson(raw);
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
     obj = GetListingWithUserOptResponse.fromJson(data);
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