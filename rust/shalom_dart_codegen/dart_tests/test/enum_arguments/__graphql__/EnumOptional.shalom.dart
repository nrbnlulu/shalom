





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumOptionalResponse {

    /// class members
    
            
            final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt;
        
    
    // keywordargs constructor
    EnumOptionalResponse({
    
        this.updateOrderStatusOpt,
    
    });
    
    
        EnumOptionalResponse updateWithJson(JsonObject data) {
        
            
            final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt_value;
            if (data.containsKey('updateOrderStatusOpt')) {
                final updateOrderStatusOpt$raw = data["updateOrderStatusOpt"];
                updateOrderStatusOpt_value = 
    
        
            updateOrderStatusOpt$raw == null ? null : EnumOptional_updateOrderStatusOpt.fromJson(updateOrderStatusOpt$raw)
        
    
;
            } else {
                updateOrderStatusOpt_value = updateOrderStatusOpt;
            }
        
        return EnumOptionalResponse(
        
            
            updateOrderStatusOpt: updateOrderStatusOpt_value,
        
        );
        }
    
    static EnumOptionalResponse fromJson(JsonObject data) {
    
        
        final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt_value;
        final updateOrderStatusOpt$raw = data["updateOrderStatusOpt"];
        updateOrderStatusOpt_value = 
    
        
            updateOrderStatusOpt$raw == null ? null : EnumOptional_updateOrderStatusOpt.fromJson(updateOrderStatusOpt$raw)
        
    
;
    
    return EnumOptionalResponse(
    
        
        updateOrderStatusOpt: updateOrderStatusOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumOptionalResponse &&
    
        
    
        other.updateOrderStatusOpt == updateOrderStatusOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderStatusOpt.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'updateOrderStatusOpt':
            
                
    
        
            this.updateOrderStatusOpt?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumOptional_updateOrderStatusOpt  {
        
    /// class members
    
            
            final Status? status;
        
    
            
            final int quantity;
        
    
            
            final String name;
        
    
            
            final double price;
        
    
    // keywordargs constructor
    EnumOptional_updateOrderStatusOpt({
    
        this.status,
    required
        this.quantity,
    required
        this.name,
    required
        this.price,
    
    });
    
    
        EnumOptional_updateOrderStatusOpt updateWithJson(JsonObject data) {
        
            
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
        
        return EnumOptional_updateOrderStatusOpt(
        
            
            status: status_value,
        
            
            quantity: quantity_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
        );
        }
    
    static EnumOptional_updateOrderStatusOpt fromJson(JsonObject data) {
    
        
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
    
    return EnumOptional_updateOrderStatusOpt(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumOptional_updateOrderStatusOpt &&
    
        
    
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


class RequestEnumOptional extends Requestable {
    
    final EnumOptionalVariables variables;
    

    RequestEnumOptional(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumOptional($status: Status) {
  updateOrderStatusOpt(status: $status) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'EnumOptional'
        );
    }
}


class EnumOptionalVariables {
    
    
        final Option<Status?> status;
    

    EnumOptionalVariables (
        
            {
            

    
        
            this.status = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (status.isSome()) {
            final value = this.status.some();
            data["status"] = 
    
        
            value?.name
        
    
;
        }
    


        return data;
    }

    
EnumOptionalVariables updateWith(
    {
        
            
                Option<Option<Status?>> status = const None()
            
            
        
    }
) {
    
        final Option<Status?> status$next;
        
            switch (status) {

                case Some(value: final updateData):
                    status$next = updateData;
                case None():
                    status$next = this.status;
            }

        
    
    return EnumOptionalVariables(
        
            status: status$next
            
        
    );
}


}
