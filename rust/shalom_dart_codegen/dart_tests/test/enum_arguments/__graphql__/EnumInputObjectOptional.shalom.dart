





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumInputObjectOptionalResponse {

    /// class members
    
            
            final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt;
        
    
    // keywordargs constructor
    EnumInputObjectOptionalResponse({
    
        this.updateOrderWithStatusOpt,
    
    });
    
    
        EnumInputObjectOptionalResponse updateWithJson(JsonObject data) {
        
            
            final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt_value;
            if (data.containsKey('updateOrderWithStatusOpt')) {
                final updateOrderWithStatusOpt$raw = data["updateOrderWithStatusOpt"];
                updateOrderWithStatusOpt_value = 
    
        
            updateOrderWithStatusOpt$raw == null ? null : EnumInputObjectOptional_updateOrderWithStatusOpt.fromJson(updateOrderWithStatusOpt$raw)
        
    
;
            } else {
                updateOrderWithStatusOpt_value = updateOrderWithStatusOpt;
            }
        
        return EnumInputObjectOptionalResponse(
        
            
            updateOrderWithStatusOpt: updateOrderWithStatusOpt_value,
        
        );
        }
    
    static EnumInputObjectOptionalResponse fromJson(JsonObject data) {
    
        
        final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt_value;
        final updateOrderWithStatusOpt$raw = data["updateOrderWithStatusOpt"];
        updateOrderWithStatusOpt_value = 
    
        
            updateOrderWithStatusOpt$raw == null ? null : EnumInputObjectOptional_updateOrderWithStatusOpt.fromJson(updateOrderWithStatusOpt$raw)
        
    
;
    
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
            
                
    
        
            this.updateOrderWithStatusOpt?.toJson()
        
    

            
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
    
    
        EnumInputObjectOptional_updateOrderWithStatusOpt updateWithJson(JsonObject data) {
        
            
            final Status? status_value;
            if (data.containsKey('status')) {
                final status$raw = data["status"];
                status_value = 
    
        
        
            status$raw == null ? null : Status.fromString(status$raw)
        
    
;
            } else {
                status_value = status;
            }
        
            
            final int quantity_value;
            if (data.containsKey('quantity')) {
                final quantity$raw = data["quantity"];
                quantity_value = 
    
        
            
                quantity$raw as int
            
        
    
;
            } else {
                quantity_value = quantity;
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
        
            
            final double price_value;
            if (data.containsKey('price')) {
                final price$raw = data["price"];
                price_value = 
    
        
            
                price$raw as double
            
        
    
;
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
    
    static EnumInputObjectOptional_updateOrderWithStatusOpt fromJson(JsonObject data) {
    
        
        final Status? status_value;
        final status$raw = data["status"];
        status_value = 
    
        
        
            status$raw == null ? null : Status.fromString(status$raw)
        
    
;
    
        
        final int quantity_value;
        final quantity$raw = data["quantity"];
        quantity_value = 
    
        
            
                quantity$raw as int
            
        
    
;
    
        
        final String name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String
            
        
    
;
    
        
        final double price_value;
        final price$raw = data["price"];
        price_value = 
    
        
            
                price$raw as double
            
        
    
;
    
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
    
        
    
        other.status == status
    
 &&
    
        
    
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
        
            
            status,
        
            
            quantity,
        
            
            name,
        
            
            price,
        
        ]);
    
     
    JsonObject toJson() {
    return {
    
        
        'status':
            
                
    
        
            this.status?.name
        
    

            
        ,
    
        
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
            opName: 'EnumInputObjectOptional'
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
        

    
    
        data["order"] = 
    
        
            this.order.toJson()
        
    
;
    


        return data;
    }

    
EnumInputObjectOptionalVariables updateWith(
    {
        
            
                OrderUpdateStatusOpt? order
            
            
        
    }
) {
    
        final OrderUpdateStatusOpt order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return EnumInputObjectOptionalVariables(
        
            order: order$next
            
        
    );
}


}
