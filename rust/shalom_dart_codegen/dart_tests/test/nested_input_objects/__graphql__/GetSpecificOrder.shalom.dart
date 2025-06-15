










import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetSpecificOrderResponse{

    /// class members
    
        
            final GetSpecificOrder_getSpecificOrder? getSpecificOrder;
        
    
    // keywordargs constructor
    GetSpecificOrderResponse({
    
        this.getSpecificOrder,
    
    });
    static GetSpecificOrderResponse fromJson(JsonObject data) {
    
        
            final GetSpecificOrder_getSpecificOrder? getSpecificOrder_value;
            
                final JsonObject? getSpecificOrder$raw = data['getSpecificOrder']; 
                if (getSpecificOrder$raw != null) {
                    getSpecificOrder_value = GetSpecificOrder_getSpecificOrder.fromJson(getSpecificOrder$raw);
                } else {
                    getSpecificOrder_value = null;
                }
            
        
    
    return GetSpecificOrderResponse(
    
        
        getSpecificOrder: getSpecificOrder_value,
    
    );
    }
    GetSpecificOrderResponse updateWithJson(JsonObject data) {
    
        
        final GetSpecificOrder_getSpecificOrder? getSpecificOrder_value;
        if (data.containsKey('getSpecificOrder')) {
            
                final JsonObject? getSpecificOrder$raw = data['getSpecificOrder']; 
                if (getSpecificOrder$raw != null) {
                    getSpecificOrder_value = GetSpecificOrder_getSpecificOrder.fromJson(getSpecificOrder$raw);
                } else {
                    getSpecificOrder_value = null;
                }
            
        } else {
            getSpecificOrder_value = getSpecificOrder;
        }
        
    
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
            
                getSpecificOrder?.toJson()
            
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
    static GetSpecificOrder_getSpecificOrder fromJson(JsonObject data) {
    
        
            final int? quantity_value = data['quantity'];
        
    
        
            final double? price_value = data['price'];
        
    
        
            final String? name_value = data['name'];
        
    
    return GetSpecificOrder_getSpecificOrder(
    
        
        quantity: quantity_value,
    
        
        price: price_value,
    
        
        name: name_value,
    
    );
    }
    GetSpecificOrder_getSpecificOrder updateWithJson(JsonObject data) {
    
        
            final int? quantity_value;
            if (data.containsKey('quantity')) {
            quantity_value = data['quantity'];
            } else {
            quantity_value = quantity;
            }
        
    
        
            final double? price_value;
            if (data.containsKey('price')) {
            price_value = data['price'];
            } else {
            price_value = price;
            }
        
    
        
            final String? name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
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
    
        other.quantity == quantity &&
    
        other.price == price &&
    
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
            
                quantity
            
        ,
    
        
        'price':
            
                price
            
        ,
    
        
        'name':
            
                name
            
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
            StringopName: 'GetSpecificOrder'
        );
    }
}


class GetSpecificOrderVariables {
    
        final String id;
    
        final SpecificOrder specificOrder;
    

    GetSpecificOrderVariables(
        
            {
            

    
        
            required this.id  
        ,
    
    
    
        
            required this.specificOrder  
        ,
    
      
 
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        
            data["id"] = id; 
        
    

    
    
        
            data["specificOrder"] = specificOrder.toJson();
        
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
    
        final String id_value;
         
                id_value = data['id'];
        
    

    
    
     
        final SpecificOrder specificOrder_value;
        
            specificOrder_value = SpecificOrder.fromJson(data['specificOrder']);   
        
    

    return GetSpecificOrderVariables (
        
           id: id_value,
        
           specificOrder: specificOrder_value,
        
    );

    }
}
