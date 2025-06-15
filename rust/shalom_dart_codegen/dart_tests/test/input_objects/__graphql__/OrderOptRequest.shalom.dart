










import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class OrderOptRequestResponse{

    /// class members
    
        
            final OrderOptRequest_orderOptRequest? orderOptRequest;
        
    
    // keywordargs constructor
    OrderOptRequestResponse({
    
        this.orderOptRequest,
    
    });
    static OrderOptRequestResponse fromJson(JsonObject data) {
    
        
            final OrderOptRequest_orderOptRequest? orderOptRequest_value;
            
                final JsonObject? orderOptRequest$raw = data['orderOptRequest']; 
                if (orderOptRequest$raw != null) {
                    orderOptRequest_value = OrderOptRequest_orderOptRequest.fromJson(orderOptRequest$raw);
                } else {
                    orderOptRequest_value = null;
                }
            
        
    
    return OrderOptRequestResponse(
    
        
        orderOptRequest: orderOptRequest_value,
    
    );
    }
    OrderOptRequestResponse updateWithJson(JsonObject data) {
    
        
        final OrderOptRequest_orderOptRequest? orderOptRequest_value;
        if (data.containsKey('orderOptRequest')) {
            
                final JsonObject? orderOptRequest$raw = data['orderOptRequest']; 
                if (orderOptRequest$raw != null) {
                    orderOptRequest_value = OrderOptRequest_orderOptRequest.fromJson(orderOptRequest$raw);
                } else {
                    orderOptRequest_value = null;
                }
            
        } else {
            orderOptRequest_value = orderOptRequest;
        }
        
    
    return OrderOptRequestResponse(
    
        
        orderOptRequest: orderOptRequest_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptRequestResponse &&
    
        other.orderOptRequest == orderOptRequest 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptRequest':
            
                orderOptRequest?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderOptRequest_orderOptRequest  {
        
    /// class members
    
        
            final int? quantity;
        
    
        
            final String? name;
        
    
        
            final double? price;
        
    
    // keywordargs constructor
    OrderOptRequest_orderOptRequest({
    
        this.quantity,
    
        this.name,
    
        this.price,
    
    });
    static OrderOptRequest_orderOptRequest fromJson(JsonObject data) {
    
        
            final int? quantity_value = data['quantity'];
        
    
        
            final String? name_value = data['name'];
        
    
        
            final double? price_value = data['price'];
        
    
    return OrderOptRequest_orderOptRequest(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    OrderOptRequest_orderOptRequest updateWithJson(JsonObject data) {
    
        
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
        
    
    return OrderOptRequest_orderOptRequest(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptRequest_orderOptRequest &&
    
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


class RequestOrderOptRequest extends Requestable {
    
    final OrderOptRequestVariables variables;
    

    RequestOrderOptRequest(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderOptRequest($order: OrderOpt!) {
  orderOptRequest(order: $order) {
    quantity
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'OrderOptRequest'
        );
    }
}


class OrderOptRequestVariables {
    
        final OrderOpt order;
    

    OrderOptRequestVariables(
        
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

    static fromJson(JsonObject data) {
        

    
    
     
        final OrderOpt order_value;
        
            order_value = OrderOpt.fromJson(data['order']);   
        
    

    return OrderOptRequestVariables (
        
           order: order_value,
        
    );

    }
}
