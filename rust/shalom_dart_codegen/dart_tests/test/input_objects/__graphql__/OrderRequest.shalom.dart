




import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class OrderRequestResponse{

    /// class members
    
        
            final OrderRequest_orderRequest? orderRequest;
        
    
    // keywordargs constructor
    OrderRequestResponse({
    
        this.orderRequest,
    
    });
    static OrderRequestResponse fromJson(JsonObject data) {
    
        
            final OrderRequest_orderRequest? orderRequest_value;
            
                final JsonObject? orderRequest$raw = data['orderRequest']; 
                if (orderRequest$raw != null) {
                    orderRequest_value = OrderRequest_orderRequest.fromJson(orderRequest$raw);
                } else {
                    orderRequest_value = null;
                }
            
        
    
    return OrderRequestResponse(
    
        
        orderRequest: orderRequest_value,
    
    );
    }
    OrderRequestResponse updateWithJson(JsonObject data) {
    
        
        final OrderRequest_orderRequest? orderRequest_value;
        if (data.containsKey('orderRequest')) {
            
                final JsonObject? orderRequest$raw = data['orderRequest']; 
                if (orderRequest$raw != null) {
                    orderRequest_value = OrderRequest_orderRequest.fromJson(orderRequest$raw);
                } else {
                    orderRequest_value = null;
                }
            
        } else {
            orderRequest_value = orderRequest;
        }
        
    
    return OrderRequestResponse(
    
        
        orderRequest: orderRequest_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRequestResponse &&
    
        other.orderRequest == orderRequest 
    
    );
    }
    @override
    int get hashCode =>
    
        orderRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderRequest':
            
                orderRequest?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderRequest_orderRequest  {
        
    /// class members
    
        
            final int? quantity;
        
    
        
            final String? name;
        
    
        
            final double? price;
        
    
    // keywordargs constructor
    OrderRequest_orderRequest({
    
        this.quantity,
    
        this.name,
    
        this.price,
    
    });
    static OrderRequest_orderRequest fromJson(JsonObject data) {
    
        
            final int? quantity_value = data['quantity'];
        
    
        
            final String? name_value = data['name'];
        
    
        
            final double? price_value = data['price'];
        
    
    return OrderRequest_orderRequest(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    OrderRequest_orderRequest updateWithJson(JsonObject data) {
    
        
            final int? quantity_value;
            if (data.containsKey('quantity')) {
            quantity_value = data['quantity'];
            } else {
            quantity_value = quantity;
            }
        
    
        
            final String? name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            final double? price_value;
            if (data.containsKey('price')) {
            price_value = data['price'];
            } else {
            price_value = price;
            }
        
    
    return OrderRequest_orderRequest(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRequest_orderRequest &&
    
        other.quantity == quantity &&
    
        other.name == name &&
    
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
            
                quantity
            
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


class RequestOrderRequest extends Requestable {
    
    final OrderRequestVariables variables;
    

    RequestOrderRequest(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderRequest($order: Order!) {
  orderRequest(order: $order) {
    quantity
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'OrderRequest'
        );
    }
}


class OrderRequestVariables {
    
        final Order order;
    

    OrderRequestVariables(
        
            {
            

    
        
            required this.order  
        ,
    
      
 
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        
            data["order"] = order.toJson();
        
    

    
        return data;
    } 
}
