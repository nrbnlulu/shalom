





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListingResponse {

    /// class members
    
            
            final GetListing_listing listing;
        
    
    // keywordargs constructor
    GetListingResponse({
    required
        this.listing,
    
    });
    
    
        GetListingResponse updateWithJson(JsonObject data) {
        
            
            final GetListing_listing listing_value;
            if (data.containsKey('listing')) {
                final listing$raw = data["listing"];
                listing_value = 
    
        
            GetListing_listing.fromJson(listing$raw)
        
    
;
            } else {
                listing_value = listing;
            }
        
        return GetListingResponse(
        
            
            listing: listing_value,
        
        );
        }
    
    static GetListingResponse fromJson(JsonObject data) {
    
        
        final GetListing_listing listing_value;
        final listing$raw = data["listing"];
        listing_value = 
    
        
            GetListing_listing.fromJson(listing$raw)
        
    
;
    
    return GetListingResponse(
    
        
        listing: listing_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingResponse &&
    
        
    
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


    class GetListing_listing  {
        
    /// class members
    
            
            final String id;
        
    
            
            final String name;
        
    
            
            final int? price;
        
    
    // keywordargs constructor
    GetListing_listing({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
    });
    
    
        GetListing_listing updateWithJson(JsonObject data) {
        
            
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
        
        return GetListing_listing(
        
            
            id: id_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
        );
        }
    
    static GetListing_listing fromJson(JsonObject data) {
    
        
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
    
    return GetListing_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListing_listing &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.price == price
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            price,
        
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
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetListing extends Requestable {
    

    RequestGetListing(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetListing {
  listing {
    id
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetListing'
        );
    }
}

