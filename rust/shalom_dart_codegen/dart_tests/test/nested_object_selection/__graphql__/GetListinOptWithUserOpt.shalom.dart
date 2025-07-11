





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListinOptWithUserOptResponse {

    /// class members
    
            
            final GetListinOptWithUserOpt_listingOpt? listingOpt;
        
    
    // keywordargs constructor
    GetListinOptWithUserOptResponse({
    
        this.listingOpt,
    
    });
    static GetListinOptWithUserOptResponse fromJson(JsonObject data) {
    
        
        final GetListinOptWithUserOpt_listingOpt? listingOpt_value;
        final listingOpt$raw = data["listingOpt"];
        listingOpt_value = 
    
        
            listingOpt$raw == null ? null : GetListinOptWithUserOpt_listingOpt.fromJson(listingOpt$raw)
        
    
;
    
    return GetListinOptWithUserOptResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    
    
        GetListinOptWithUserOptResponse updateWithJson(JsonObject data) {
        
            
            final GetListinOptWithUserOpt_listingOpt? listingOpt_value;
            if (data.containsKey('listingOpt')) {
                final listingOpt$raw = data["listingOpt"];
                listingOpt_value = 
    
        
            listingOpt$raw == null ? null : GetListinOptWithUserOpt_listingOpt.fromJson(listingOpt$raw)
        
    
;
            } else {
                listingOpt_value = listingOpt;
            }
        
        return GetListinOptWithUserOptResponse(
        
            
            listingOpt: listingOpt_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListinOptWithUserOptResponse &&
    
        
    
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


    class GetListinOptWithUserOpt_listingOpt  {
        
    /// class members
    
            
            final String id;
        
    
            
            final String name;
        
    
            
            final int? price;
        
    
            
            final GetListinOptWithUserOpt_listingOpt_userOpt? userOpt;
        
    
    // keywordargs constructor
    GetListinOptWithUserOpt_listingOpt({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
        this.userOpt,
    
    });
    static GetListinOptWithUserOpt_listingOpt fromJson(JsonObject data) {
    
        
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
    
        
        final GetListinOptWithUserOpt_listingOpt_userOpt? userOpt_value;
        final userOpt$raw = data["userOpt"];
        userOpt_value = 
    
        
            userOpt$raw == null ? null : GetListinOptWithUserOpt_listingOpt_userOpt.fromJson(userOpt$raw)
        
    
;
    
    return GetListinOptWithUserOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        userOpt: userOpt_value,
    
    );
    }
    
    
        GetListinOptWithUserOpt_listingOpt updateWithJson(JsonObject data) {
        
            
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
        
            
            final GetListinOptWithUserOpt_listingOpt_userOpt? userOpt_value;
            if (data.containsKey('userOpt')) {
                final userOpt$raw = data["userOpt"];
                userOpt_value = 
    
        
            userOpt$raw == null ? null : GetListinOptWithUserOpt_listingOpt_userOpt.fromJson(userOpt$raw)
        
    
;
            } else {
                userOpt_value = userOpt;
            }
        
        return GetListinOptWithUserOpt_listingOpt(
        
            
            id: id_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
            
            userOpt: userOpt_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListinOptWithUserOpt_listingOpt &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.price == price
    
 &&
    
        
    
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
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'price':
            
                
    
        
            this.price
        
    

            
        ,
    
        
        'userOpt':
            
                
    
        
            this.userOpt?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class GetListinOptWithUserOpt_listingOpt_userOpt  {
        
    /// class members
    
            
            final String id;
        
    
            
            final String name;
        
    
    // keywordargs constructor
    GetListinOptWithUserOpt_listingOpt_userOpt({
    required
        this.id,
    required
        this.name,
    
    });
    static GetListinOptWithUserOpt_listingOpt_userOpt fromJson(JsonObject data) {
    
        
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
    
    return GetListinOptWithUserOpt_listingOpt_userOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
    );
    }
    
    
        GetListinOptWithUserOpt_listingOpt_userOpt updateWithJson(JsonObject data) {
        
            
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
        
        return GetListinOptWithUserOpt_listingOpt_userOpt(
        
            
            id: id_value,
        
            
            name: name_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListinOptWithUserOpt_listingOpt_userOpt &&
    
        
    
        other.id == id
    
 &&
    
        
    
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
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetListinOptWithUserOpt extends Requestable {
    

    RequestGetListinOptWithUserOpt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetListinOptWithUserOpt {
  listingOpt {
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
            opName: 'GetListinOptWithUserOpt'
        );
    }
}

