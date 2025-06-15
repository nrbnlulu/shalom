










import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class OrderRecursiveResponse{

    /// class members
    
        
            final OrderRecursive_orderRecursive? orderRecursive;
        
    
    // keywordargs constructor
    OrderRecursiveResponse({
    
        this.orderRecursive,
    
    });
    static OrderRecursiveResponse fromJson(JsonObject data) {
    
        
            final OrderRecursive_orderRecursive? orderRecursive_value;
            
                final JsonObject? orderRecursive$raw = data['orderRecursive']; 
                if (orderRecursive$raw != null) {
                    orderRecursive_value = OrderRecursive_orderRecursive.fromJson(orderRecursive$raw);
                } else {
                    orderRecursive_value = null;
                }
            
        
    
    return OrderRecursiveResponse(
    
        
        orderRecursive: orderRecursive_value,
    
    );
    }
    OrderRecursiveResponse updateWithJson(JsonObject data) {
    
        
        final OrderRecursive_orderRecursive? orderRecursive_value;
        if (data.containsKey('orderRecursive')) {
            
                final JsonObject? orderRecursive$raw = data['orderRecursive']; 
                if (orderRecursive$raw != null) {
                    orderRecursive_value = OrderRecursive_orderRecursive.fromJson(orderRecursive$raw);
                } else {
                    orderRecursive_value = null;
                }
            
        } else {
            orderRecursive_value = orderRecursive;
        }
        
    
    return OrderRecursiveResponse(
    
        
        orderRecursive: orderRecursive_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRecursiveResponse &&
    
        other.orderRecursive == orderRecursive 
    
    );
    }
    @override
    int get hashCode =>
    
        orderRecursive.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderRecursive':
            
                orderRecursive?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderRecursive_orderRecursive  {
        
    /// class members
    
        
            final int? quantity;
        
    
        
            final String? name;
        
    
        
            final double? price;
        
    
    // keywordargs constructor
    OrderRecursive_orderRecursive({
    
        this.quantity,
    
        this.name,
    
        this.price,
    
    });
    static OrderRecursive_orderRecursive fromJson(JsonObject data) {
    
        
            final int? quantity_value = data['quantity'];
        
    
        
            final String? name_value = data['name'];
        
    
        
            final double? price_value = data['price'];
        
    
    return OrderRecursive_orderRecursive(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    OrderRecursive_orderRecursive updateWithJson(JsonObject data) {
    
        
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
        
    
    return OrderRecursive_orderRecursive(
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRecursive_orderRecursive &&
    
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


class RequestOrderRecursive extends Requestable {
    
    final OrderRecursiveVariables variables;
    

    RequestOrderRecursive(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderRecursive($order: OrderRecursive) {
  orderRecursive(order: $order) {
    quantity
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'OrderRecursive'
        );
    }
}


class OrderRecursiveVariables {
    
        final Option<OrderRecursive?> order;
    

    OrderRecursiveVariables(
        
            {
            

    
         
            this.order = const None() 
        ,
    
      
 
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (order.isSome()) {
             
                data["order"] = order.some()?.toJson();   
            
        } 
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
     
        final Option<OrderRecursive?> order_value;
          
            final JsonObject? order$raw = data['order'];
            if (order$raw != null) {   
                
                    order_value = Some(OrderRecursive.fromJson(order$raw));   
                
            } else {
                
                    order_value = None();
                
            }
        
    

    return OrderRecursiveVariables (
        
           order: order_value,
        
    );

    }
}
