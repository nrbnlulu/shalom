





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumRequiredResponse {

    /// class members
    
            
            final EnumRequired_updateOrderStatus? updateOrderStatus;
        
    
    // keywordargs constructor
    EnumRequiredResponse({
    
        this.updateOrderStatus,
    
    });
    
    
        EnumRequiredResponse updateWithJson(JsonObject data) {
        
            
            final EnumRequired_updateOrderStatus? updateOrderStatus_value;
            if (data.containsKey('updateOrderStatus')) {
                final updateOrderStatus$raw = data["updateOrderStatus"];
                updateOrderStatus_value = 
    
        
            updateOrderStatus$raw == null ? null : EnumRequired_updateOrderStatus.fromJson(updateOrderStatus$raw)
        
    
;
            } else {
                updateOrderStatus_value = updateOrderStatus;
            }
        
        return EnumRequiredResponse(
        
            
            updateOrderStatus: updateOrderStatus_value,
        
        );
        }
    
    static EnumRequiredResponse fromJson(JsonObject data) {
    
        
        final EnumRequired_updateOrderStatus? updateOrderStatus_value;
        final updateOrderStatus$raw = data["updateOrderStatus"];
        updateOrderStatus_value = 
    
        
            updateOrderStatus$raw == null ? null : EnumRequired_updateOrderStatus.fromJson(updateOrderStatus$raw)
        
    
;
    
    return EnumRequiredResponse(
    
        
        updateOrderStatus: updateOrderStatus_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumRequiredResponse &&
    
        
    
        other.updateOrderStatus == updateOrderStatus
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderStatus.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'updateOrderStatus':
            
                
    
        
            this.updateOrderStatus?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumRequired_updateOrderStatus  {
        
    /// class members
    
            
            final Status? status;
        
    
            
            final int quantity;
        
    
            
            final String name;
        
    
            
            final double price;
        
    
    // keywordargs constructor
    EnumRequired_updateOrderStatus({
    
        this.status,
    required
        this.quantity,
    required
        this.name,
    required
        this.price,
    
    });
    
    
        EnumRequired_updateOrderStatus updateWithJson(JsonObject data) {
        
            
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
        
        return EnumRequired_updateOrderStatus(
        
            
            status: status_value,
        
            
            quantity: quantity_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
        );
        }
    
    static EnumRequired_updateOrderStatus fromJson(JsonObject data) {
    
        
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
    
    return EnumRequired_updateOrderStatus(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumRequired_updateOrderStatus &&
    
        
    
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


class RequestEnumRequired extends Requestable {
    
    final EnumRequiredVariables variables;
    

    RequestEnumRequired(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumRequired($status: Status!) {
  updateOrderStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'EnumRequired'
        );
    }
}


class EnumRequiredVariables {
    
    
        final Status status;
    

    EnumRequiredVariables (
        
            {
            

    
        
            required this.status
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["status"] = 
    
        
            this.status.name
        
    
;
    


        return data;
    }

    
EnumRequiredVariables updateWith(
    {
        
            
                Status? status
            
            
        
    }
) {
    
        final Status status$next;
        
            if (status != null) {
                status$next = status;
            } else {
                status$next = this.status;
            }
        
    
    return EnumRequiredVariables(
        
            status: status$next
            
        
    );
}


}
