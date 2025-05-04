
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetListingOptResponse{

    /// class members
    
        
            final GetListingOpt_listingOpt? listingOpt;
        
    
    // keywordargs constructor
    GetListingOptResponse({
    
        this.listingOpt,
    
    });
    static GetListingOptResponse fromJson(JsonObject data) {
    
        
            final GetListingOpt_listingOpt? listingOpt_value;
            
                final JsonObject? listingOpt$raw = data['listingOpt']; 
                if (listingOpt$raw != null) {
                    listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
                } else {
                    listingOpt_value = null;
                }
            
        
    
    return GetListingOptResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    GetListingOptResponse updateWithJson(JsonObject data) {
    
        
        final GetListingOpt_listingOpt? listingOpt_value;
        if (data.containsKey('listingOpt')) {
            
                final JsonObject? listingOpt$raw = data['listingOpt']; 
                if (listingOpt$raw != null) {
                    listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
                } else {
                    listingOpt_value = null;
                }
            
        } else {
            listingOpt_value = listingOpt;
        }
        
    
    return GetListingOptResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOptResponse &&
    
        other.listingOpt == listingOpt 
    
    );
    }
    @override
    int get hashCode =>
    
        listingOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'listingOpt':
            
                listingOpt?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetListingOpt_listingOpt  {
        
    /// class members
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final int? price;
        
    
    // keywordargs constructor
    GetListingOpt_listingOpt({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
    });
    static GetListingOpt_listingOpt fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final String name_value = data['name'];
        
    
        
            final int? price_value = data['price'];
        
    
    return GetListingOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    GetListingOpt_listingOpt updateWithJson(JsonObject data) {
    
        
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
        
    
    return GetListingOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOpt_listingOpt &&
    
        other.id == id &&
    
        other.name == name &&
    
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
            
                id
            
        ,
    
        
        'name':
            
                name
            
        ,
    
        
        'price':
            
                price
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------

class RequestGetListingOpt extends Requestable {
    final GetListingOptResponse operation;
    final GetListingOptVariables variables;

    RequestGetListingOpt({
        required this.operation,  
        required this.variables,
    });

    String selectionsJsonToQuery(JsonObject selection) {
        List<String> selectionItems = [];
        for (var entry in selection.entries) {
            if (entry.value is JsonObject) {
                String subSelections = selectionsJsonToQuery(entry.value);
                selectionItems.add("${entry.key} $subSelections");
            } else {
                selectionItems.add(entry.key);   
            }
        } 
        String selectionItemsString = selectionItems.join(" ");
        return "{$selectionItemsString}";
    }  

    String queryString() {
        String selectionString = this.selectionsJsonToQuery(operation.toJson()); 
        String variablesString = variables.toTypes().entries.map((entry) => '\$${entry.key}: ${entry.value}').join(", "); 
        String queryString = "query GetListingOpt($variablesString) $selectionString";
        return queryString;
    } 

    Request toRequest() {
        return Request(
            query: this.queryString(), 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: 'GetListingOpt'
        );
    }
}


class GetListingOptVariables {
    

    GetListingOptVariables(
        
    );

    JsonObject toTypes() {
        return {
              
        };
    }  

    JsonObject toJson() {
        return {
              
        };
    } 
}
