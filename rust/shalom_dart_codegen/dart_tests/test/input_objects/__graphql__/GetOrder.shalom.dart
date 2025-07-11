





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetOrderResponse {

    /// class members
    
            
            final GetOrder_getOrder? getOrder;
        
    
    // keywordargs constructor
    GetOrderResponse({
    
        this.getOrder,
    
    });
    static GetOrderResponse fromJson(JsonObject data) {
    
        
        final GetOrder_getOrder? getOrder_value;
        final getOrder$raw = data["getOrder"];
        getOrder_value = 
    
        
            getOrder$raw == null ? null : GetOrder_getOrder.fromJson(getOrder$raw)
        
    
;
    
    return GetOrderResponse(
    
        
        getOrder: getOrder_value,
    
    );
    }
    
    
        GetOrderResponse updateWithJson(JsonObject data) {
        
            
            final GetOrder_getOrder? getOrder_value;
            if (data.containsKey('getOrder')) {
                final getOrder$raw = data["getOrder"];
                getOrder_value = 
    
        
            getOrder$raw == null ? null : GetOrder_getOrder.fromJson(getOrder$raw)
        
    
;
            } else {
                getOrder_value = getOrder;
            }
        
        return GetOrderResponse(
        
            
            getOrder: getOrder_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetOrderResponse &&
    
        
    
        other.getOrder == getOrder
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getOrder.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'getOrder':
            
                
    
        
            this.getOrder?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetOrder_getOrder  {
        
    /// class members
    
            
            final int? quantity;
        
    
            
            final String? name;
        
    
            
            final double? price;
        
    
    // keywordargs constructor
    GetOrder_getOrder({
    
        this.quantity,
    
        this.name,
    
        this.price,
    
    });
    static GetOrder_getOrder fromJson(JsonObject data) {
    
        
        final int? quantity_value;
        final quantity$raw = data["quantity"];
        quantity_value = 
    
        
            
                quantity$raw as int?
            
        
    
;
    
        
        final String? name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String?
            
        
    
;
    
        
        final double? price_value;
        final price$raw = data["price"];
        price_value = 
    
        
            
                price$raw as double?
            
        
    
;
    
    return GetOrder_getOrder(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    
    
        GetOrder_getOrder updateWithJson(JsonObject data) {
        
            
            final int? quantity_value;
            if (data.containsKey('quantity')) {
                final quantity$raw = data["quantity"];
                quantity_value = 
    
        
            
                quantity$raw as int?
            
        
    
;
            } else {
                quantity_value = quantity;
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
        
            
            final double? price_value;
            if (data.containsKey('price')) {
                final price$raw = data["price"];
                price_value = 
    
        
            
                price$raw as double?
            
        
    
;
            } else {
                price_value = price;
            }
        
        return GetOrder_getOrder(
        
            
            quantity: quantity_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetOrder_getOrder &&
    
        
    
        other.quantity == quantity
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.price == price
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            quantity,
        
            
            name,
        
            
            price,
        
        ]);
    
     
    JsonObject toJson() {
    return {
    
        
        'quantity':
            
                
    
        
            this.quantity
        
    

            
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


class RequestGetOrder extends Requestable {
    
    final GetOrderVariables variables;
    

    RequestGetOrder(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query GetOrder($id: ID!, $order: Order) {
  getOrder(id: $id, order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetOrder'
        );
    }
}


class GetOrderVariables {
    
    
        final String id;
    
        final Option<Order?> order;
    

    GetOrderVariables (
        
            {
            

    
        
            required this.id
        ,
    
    
    
        
            this.order = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    

    
    
        if (order.isSome()) {
            final value = this.order.some();
            data["order"] = 
    
        
            value?.toJson()
        
    
;
        }
    


        return data;
    }

    
GetOrderVariables updateWith(
    {
        
            
                String? id
            
            ,
        
            
                Option<Option<Order?>> order = const None()
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
        final Option<Order?> order$next;
        
            switch (order) {

                case Some(value: final updateData):
                    order$next = updateData;
                case None():
                    order$next = this.order;
            }

        
    
    return GetOrderVariables(
        
            id: id$next
            ,
        
            order: order$next
            
        
    );
}


}
