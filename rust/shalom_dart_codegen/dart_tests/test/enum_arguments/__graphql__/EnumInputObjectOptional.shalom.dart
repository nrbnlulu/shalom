













import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class EnumInputObjectOptionalResponse{

    /// class members
    
        
            final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt;
        
    
    // keywordargs constructor
    EnumInputObjectOptionalResponse({
    
        this.updateOrderWithStatusOpt,
    
    });
    static EnumInputObjectOptionalResponse fromJson(JsonObject data) {
    
        
            final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt_value;
            
                final JsonObject? updateOrderWithStatusOpt$raw = data['updateOrderWithStatusOpt']; 
                if (updateOrderWithStatusOpt$raw != null) {
                    updateOrderWithStatusOpt_value = EnumInputObjectOptional_updateOrderWithStatusOpt.fromJson(updateOrderWithStatusOpt$raw);
                } else {
                    updateOrderWithStatusOpt_value = null;
                }
            
        
    
    return EnumInputObjectOptionalResponse(
    
        
        updateOrderWithStatusOpt: updateOrderWithStatusOpt_value,
    
    );
    }
    EnumInputObjectOptionalResponse updateWithJson(JsonObject data) {
    
        
        final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt_value;
        if (data.containsKey('updateOrderWithStatusOpt')) {
            
                final JsonObject? updateOrderWithStatusOpt$raw = data['updateOrderWithStatusOpt']; 
                if (updateOrderWithStatusOpt$raw != null) {
                    updateOrderWithStatusOpt_value = EnumInputObjectOptional_updateOrderWithStatusOpt.fromJson(updateOrderWithStatusOpt$raw);
                } else {
                    updateOrderWithStatusOpt_value = null;
                }
            
        } else {
            updateOrderWithStatusOpt_value = updateOrderWithStatusOpt;
        }
        
    
    return EnumInputObjectOptionalResponse(
    
        
        updateOrderWithStatusOpt: updateOrderWithStatusOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectOptionalResponse &&
    
        other.updateOrderWithStatusOpt == updateOrderWithStatusOpt 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderWithStatusOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderWithStatusOpt':
            
                updateOrderWithStatusOpt?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumInputObjectOptional_updateOrderWithStatusOpt  {
        
    /// class members
    
        
            final Status? status;
        
    
        
            final int quantity;
        
    
        
            final String name;
        
    
        
            final double price;
        
    
    // keywordargs constructor
    EnumInputObjectOptional_updateOrderWithStatusOpt({
    
        this.status,
    required
        this.quantity,
    required
        this.name,
    required
        this.price,
    
    });
    static EnumInputObjectOptional_updateOrderWithStatusOpt fromJson(JsonObject data) {
    
        
            
            final Status? status_value;
            
                final String? status$raw = data['status']; 
                if (status$raw != null) {
                    status_value = Status.fromString(status$raw);
                } else {
                    status_value = null;
                }
            
        
    
        
            final int quantity_value = data['quantity'];
        
    
        
            final String name_value = data['name'];
        
    
        
            final double price_value = data['price'];
        
    
    return EnumInputObjectOptional_updateOrderWithStatusOpt(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    EnumInputObjectOptional_updateOrderWithStatusOpt updateWithJson(JsonObject data) {
    
        
            
            final Status? status_value;
            if (data.containsKey('status')) {
                
                    final String? status$raw = data['status']; 
                    if (status$raw != null) {
                        status_value = Status.fromString(status$raw);
                    } else {
                        status_value = null;
                    }
                
            } else {
                status_value = status;
            }
        
    
        
            final int quantity_value;
            if (data.containsKey('quantity')) {
            quantity_value = data['quantity'];
            } else {
            quantity_value = quantity;
            }
        
    
        
            final String name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            final double price_value;
            if (data.containsKey('price')) {
            price_value = data['price'];
            } else {
            price_value = price;
            }
        
    
    return EnumInputObjectOptional_updateOrderWithStatusOpt(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectOptional_updateOrderWithStatusOpt &&
    
        other.status == status &&
    
        other.quantity == quantity &&
    
        other.name == name &&
    
        other.price == price 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            status,
        
            
            quantity,
        
            
            name,
        
            
            price,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'status':
            
                status?.name  
            
        ,
    
        
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


class RequestEnumInputObjectOptional extends Requestable {
    
    final EnumInputObjectOptionalVariables variables;
    

    RequestEnumInputObjectOptional(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumInputObjectOptional($order: OrderUpdateStatusOpt!) {
  updateOrderWithStatusOpt(order: $order) {
    status
    quantity
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'EnumInputObjectOptional'
        );
    }
}


class EnumInputObjectOptionalVariables {
    
    
        final OrderUpdateStatusOpt order;
    

    EnumInputObjectOptionalVariables (
        
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
        

    
    
     
        final OrderUpdateStatusOpt order_value;
        
            order_value = OrderUpdateStatusOpt.fromJson(data['order']);   
        
    

    return EnumInputObjectOptionalVariables (
        
           order: order_value,
        
    );

    }

    EnumInputObjectOptionalVariables updateWith(JsonObject data) {
        

    
     
        final OrderUpdateStatusOpt order_value;
        if (data.containsKey('order')) {
            
                order_value = OrderUpdateStatusOpt.fromJson(data['order']);            
            
        } else {
            order_value = order;
        }
    

    return EnumInputObjectOptionalVariables (
        
           order: order_value,
        
    );


    }
}
