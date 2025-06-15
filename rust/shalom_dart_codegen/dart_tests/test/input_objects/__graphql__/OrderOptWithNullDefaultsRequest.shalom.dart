










import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class OrderOptWithNullDefaultsRequestResponse{

    /// class members
    
        
            final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest;
        
    
    // keywordargs constructor
    OrderOptWithNullDefaultsRequestResponse({
    
        this.orderOptWithNullDefaultsRequest,
    
    });
    static OrderOptWithNullDefaultsRequestResponse fromJson(JsonObject data) {
    
        
            final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest_value;
            
                final JsonObject? orderOptWithNullDefaultsRequest$raw = data['orderOptWithNullDefaultsRequest']; 
                if (orderOptWithNullDefaultsRequest$raw != null) {
                    orderOptWithNullDefaultsRequest_value = OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest.fromJson(orderOptWithNullDefaultsRequest$raw);
                } else {
                    orderOptWithNullDefaultsRequest_value = null;
                }
            
        
    
    return OrderOptWithNullDefaultsRequestResponse(
    
        
        orderOptWithNullDefaultsRequest: orderOptWithNullDefaultsRequest_value,
    
    );
    }
    OrderOptWithNullDefaultsRequestResponse updateWithJson(JsonObject data) {
    
        
        final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest_value;
        if (data.containsKey('orderOptWithNullDefaultsRequest')) {
            
                final JsonObject? orderOptWithNullDefaultsRequest$raw = data['orderOptWithNullDefaultsRequest']; 
                if (orderOptWithNullDefaultsRequest$raw != null) {
                    orderOptWithNullDefaultsRequest_value = OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest.fromJson(orderOptWithNullDefaultsRequest$raw);
                } else {
                    orderOptWithNullDefaultsRequest_value = null;
                }
            
        } else {
            orderOptWithNullDefaultsRequest_value = orderOptWithNullDefaultsRequest;
        }
        
    
    return OrderOptWithNullDefaultsRequestResponse(
    
        
        orderOptWithNullDefaultsRequest: orderOptWithNullDefaultsRequest_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithNullDefaultsRequestResponse &&
    
        other.orderOptWithNullDefaultsRequest == orderOptWithNullDefaultsRequest 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptWithNullDefaultsRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptWithNullDefaultsRequest':
            
                orderOptWithNullDefaultsRequest?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest  {
        
    /// class members
    
        
            final int? quantity;
        
    
        
            final String? name;
        
    
        
            final double? price;
        
    
    // keywordargs constructor
    OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest({
    
        this.quantity,
    
        this.name,
    
        this.price,
    
    });
    static OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest fromJson(JsonObject data) {
    
        
            final int? quantity_value = data['quantity'];
        
    
        
            final String? name_value = data['name'];
        
    
        
            final double? price_value = data['price'];
        
    
    return OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest updateWithJson(JsonObject data) {
    
        
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
        
    
    return OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest &&
    
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


class RequestOrderOptWithNullDefaultsRequest extends Requestable {
    
    final OrderOptWithNullDefaultsRequestVariables variables;
    

    RequestOrderOptWithNullDefaultsRequest(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderOptWithNullDefaultsRequest($order: OrderOptWithNullDefaults!) {
  orderOptWithNullDefaultsRequest(order: $order) {
    quantity
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'OrderOptWithNullDefaultsRequest'
        );
    }
}


class OrderOptWithNullDefaultsRequestVariables {
    
        final OrderOptWithNullDefaults order;
    

    OrderOptWithNullDefaultsRequestVariables(
        
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
        

    
    
     
        final OrderOptWithNullDefaults order_value;
        
            order_value = OrderOptWithNullDefaults.fromJson(data['order']);   
        
    

    return OrderOptWithNullDefaultsRequestVariables (
        
           order: order_value,
        
    );

    }
}
