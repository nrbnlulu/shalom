





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetSpecificOrderResponse {

    /// class members
    
            
            final GetSpecificOrder_getSpecificOrder? getSpecificOrder;
        
    
    // keywordargs constructor
    GetSpecificOrderResponse({
    
        this.getSpecificOrder,
    
    });
    
    
        GetSpecificOrderResponse updateWithJson(JsonObject data) {
        
            
            final GetSpecificOrder_getSpecificOrder? getSpecificOrder_value;
            if (data.containsKey('getSpecificOrder')) {
                final getSpecificOrder$raw = data["getSpecificOrder"];
                getSpecificOrder_value = 
    
        
            getSpecificOrder$raw == null ? null : GetSpecificOrder_getSpecificOrder.fromJson(getSpecificOrder$raw)
        
    
;
            } else {
                getSpecificOrder_value = getSpecificOrder;
            }
        
        return GetSpecificOrderResponse(
        
            
            getSpecificOrder: getSpecificOrder_value,
        
        );
        }
    
    static GetSpecificOrderResponse fromJson(JsonObject data) {
    
        
        final GetSpecificOrder_getSpecificOrder? getSpecificOrder_value;
        final getSpecificOrder$raw = data["getSpecificOrder"];
        getSpecificOrder_value = 
    
        
            getSpecificOrder$raw == null ? null : GetSpecificOrder_getSpecificOrder.fromJson(getSpecificOrder$raw)
        
    
;
    
    return GetSpecificOrderResponse(
    
        
        getSpecificOrder: getSpecificOrder_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSpecificOrderResponse &&
    
        
    
        other.getSpecificOrder == getSpecificOrder
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getSpecificOrder.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'getSpecificOrder':
            
                
    
        
            this.getSpecificOrder?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetSpecificOrder_getSpecificOrder  {
        
    /// class members
    
            
            final int? quantity;
        
    
            
            final double? price;
        
    
            
            final String? name;
        
    
    // keywordargs constructor
    GetSpecificOrder_getSpecificOrder({
    
        this.quantity,
    
        this.price,
    
        this.name,
    
    });
    
    
        GetSpecificOrder_getSpecificOrder updateWithJson(JsonObject data) {
        
            
            final int? quantity_value;
            if (data.containsKey('quantity')) {
                final quantity$raw = data["quantity"];
                quantity_value = 
    
        
            
                quantity$raw as int?
            
        
    
;
            } else {
                quantity_value = quantity;
            }
        
            
            final double? price_value;
            if (data.containsKey('price')) {
                final price$raw = data["price"];
                price_value = 
    
        
            
                price$raw as double?
            
        
    
;
            } else {
                price_value = price;
            }
        
            
            final String? name_value;
            if (data.containsKey('name')) {
                final name$raw = data["name"];
                name_value = 
    
        
            
                name$raw as String?
            
        
    
;
            } else {
                name_value = name;
            }
        
        return GetSpecificOrder_getSpecificOrder(
        
            
            quantity: quantity_value,
        
            
            price: price_value,
        
            
            name: name_value,
        
        );
        }
    
    static GetSpecificOrder_getSpecificOrder fromJson(JsonObject data) {
    
        
        final int? quantity_value;
        final quantity$raw = data["quantity"];
        quantity_value = 
    
        
            
                quantity$raw as int?
            
        
    
;
    
        
        final double? price_value;
        final price$raw = data["price"];
        price_value = 
    
        
            
                price$raw as double?
            
        
    
;
    
        
        final String? name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String?
            
        
    
;
    
    return GetSpecificOrder_getSpecificOrder(
    
        
        quantity: quantity_value,
    
        
        price: price_value,
    
        
        name: name_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSpecificOrder_getSpecificOrder &&
    
        
    
        other.quantity == quantity
    
 &&
    
        
    
        other.price == price
    
 &&
    
        
    
        other.name == name
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            quantity,
        
            
            price,
        
            
            name,
        
        ]);
    
     
    JsonObject toJson() {
    return {
    
        
        'quantity':
            
                
    
        
            this.quantity
        
    

            
        ,
    
        
        'price':
            
                
    
        
            this.price
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetSpecificOrder extends Requestable {
    
    final GetSpecificOrderVariables variables;
    

    RequestGetSpecificOrder(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query GetSpecificOrder($id: ID!, $specificOrder: SpecificOrder!) {
  getSpecificOrder(id: $id, specificOrder: $specificOrder) {
    quantity
    price
    name
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetSpecificOrder'
        );
    }
}


class GetSpecificOrderVariables {
    
    
        final String id;
    
        final SpecificOrder specificOrder;
    

    GetSpecificOrderVariables (
        
            {
            

    
        
            required this.id
        ,
    
    
    
        
            required this.specificOrder
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    

    
    
        data["specificOrder"] = 
    
        
            this.specificOrder.toJson()
        
    
;
    


        return data;
    }

    
GetSpecificOrderVariables updateWith(
    {
        
            
                String? id
            
            ,
        
            
                SpecificOrder? specificOrder
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
        final SpecificOrder specificOrder$next;
        
            if (specificOrder != null) {
                specificOrder$next = specificOrder;
            } else {
                specificOrder$next = this.specificOrder;
            }
        
    
    return GetSpecificOrderVariables(
        
            id: id$next
            ,
        
            specificOrder: specificOrder$next
            
        
    );
}


}
