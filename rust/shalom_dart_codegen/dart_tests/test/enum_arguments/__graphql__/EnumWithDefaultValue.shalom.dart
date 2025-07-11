





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumWithDefaultValueResponse {

    /// class members
    
            
            final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus;
        
    
    // keywordargs constructor
    EnumWithDefaultValueResponse({
    
        this.getOrderByStatus,
    
    });
    
    
        EnumWithDefaultValueResponse updateWithJson(JsonObject data) {
        
            
            final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus_value;
            if (data.containsKey('getOrderByStatus')) {
                final getOrderByStatus$raw = data["getOrderByStatus"];
                getOrderByStatus_value = 
    
        
            getOrderByStatus$raw == null ? null : EnumWithDefaultValue_getOrderByStatus.fromJson(getOrderByStatus$raw)
        
    
;
            } else {
                getOrderByStatus_value = getOrderByStatus;
            }
        
        return EnumWithDefaultValueResponse(
        
            
            getOrderByStatus: getOrderByStatus_value,
        
        );
        }
    
    static EnumWithDefaultValueResponse fromJson(JsonObject data) {
    
        
        final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus_value;
        final getOrderByStatus$raw = data["getOrderByStatus"];
        getOrderByStatus_value = 
    
        
            getOrderByStatus$raw == null ? null : EnumWithDefaultValue_getOrderByStatus.fromJson(getOrderByStatus$raw)
        
    
;
    
    return EnumWithDefaultValueResponse(
    
        
        getOrderByStatus: getOrderByStatus_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumWithDefaultValueResponse &&
    
        
    
        other.getOrderByStatus == getOrderByStatus
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getOrderByStatus.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'getOrderByStatus':
            
                
    
        
            this.getOrderByStatus?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumWithDefaultValue_getOrderByStatus  {
        
    /// class members
    
            
            final Status? status;
        
    
            
            final int quantity;
        
    
            
            final String name;
        
    
            
            final double price;
        
    
    // keywordargs constructor
    EnumWithDefaultValue_getOrderByStatus({
    
        this.status,
    required
        this.quantity,
    required
        this.name,
    required
        this.price,
    
    });
    
    
        EnumWithDefaultValue_getOrderByStatus updateWithJson(JsonObject data) {
        
            
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
        
        return EnumWithDefaultValue_getOrderByStatus(
        
            
            status: status_value,
        
            
            quantity: quantity_value,
        
            
            name: name_value,
        
            
            price: price_value,
        
        );
        }
    
    static EnumWithDefaultValue_getOrderByStatus fromJson(JsonObject data) {
    
        
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
    
    return EnumWithDefaultValue_getOrderByStatus(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumWithDefaultValue_getOrderByStatus &&
    
        
    
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


class RequestEnumWithDefaultValue extends Requestable {
    
    final EnumWithDefaultValueVariables variables;
    

    RequestEnumWithDefaultValue(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query EnumWithDefaultValue($status: Status = SENT) {
  getOrderByStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'EnumWithDefaultValue'
        );
    }
}


class EnumWithDefaultValueVariables {
    
    
        final Status? status;
    

    EnumWithDefaultValueVariables (
        
            {
            

    
        
            
            
                this.status = Status.SENT
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["status"] = 
    
        
            this.status?.name
        
    
;
    


        return data;
    }

    
EnumWithDefaultValueVariables updateWith(
    {
        
            
                Option<Status?> status = const None()
            
            
        
    }
) {
    
        final Status? status$next;
        
            switch (status) {

                case Some(value: final updateData):
                    status$next = updateData;
                case None():
                    status$next = this.status;
            }

        
    
    return EnumWithDefaultValueVariables(
        
            status: status$next
            
        
    );
}


}
