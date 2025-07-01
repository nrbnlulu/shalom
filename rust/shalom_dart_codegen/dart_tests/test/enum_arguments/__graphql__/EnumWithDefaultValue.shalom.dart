














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumWithDefaultValueResponse{

    /// class members
    
        
            final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus;   
        
    
    // keywordargs constructor
    EnumWithDefaultValueResponse({
    
        this.getOrderByStatus,
    
    });
    static EnumWithDefaultValueResponse fromJson(JsonObject data) {
    
        
            final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus_value;
            
                final JsonObject? getOrderByStatus$raw = data['getOrderByStatus']; 
                if (getOrderByStatus$raw != null) {
                    getOrderByStatus_value = EnumWithDefaultValue_getOrderByStatus.fromJson(getOrderByStatus$raw);
                } else {
                    getOrderByStatus_value = null;
                }
            
        
    
    return EnumWithDefaultValueResponse(
    
        
        getOrderByStatus: getOrderByStatus_value,
    
    );
    }
    EnumWithDefaultValueResponse updateWithJson(JsonObject data) {
    
        
        final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus_value;
        if (data.containsKey('getOrderByStatus')) {
            
                final JsonObject? getOrderByStatus$raw = data['getOrderByStatus'];
                if (getOrderByStatus$raw != null) {
                    getOrderByStatus_value = EnumWithDefaultValue_getOrderByStatus.fromJson(getOrderByStatus$raw);
                } else {
                    getOrderByStatus_value = null;
                }
            
        } else {
            getOrderByStatus_value = getOrderByStatus;
        }

    
    
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
            
                getOrderByStatus?.toJson()
            
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
    static EnumWithDefaultValue_getOrderByStatus fromJson(JsonObject data) {
    
        
            
            final Status? status_value;
            
                final String? status$raw = data['status'];
                if (status$raw != null) {
                    status_value = Status.fromString(status$raw);
                } else {
                    status_value = null;
                }
            
        
    
        
            final int quantity_value;
            
                quantity_value = data['quantity'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
        
            final double price_value;
            
                price_value = data['price'];
            

        
    
    return EnumWithDefaultValue_getOrderByStatus(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    EnumWithDefaultValue_getOrderByStatus updateWithJson(JsonObject data) {
    
        
            
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
            StringopName: 'EnumWithDefaultValue'
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
        

    

    
        
            
                data["status"] = status?.name;
            
        
    

    
        return data;
    } 

    
EnumWithDefaultValueVariables updateWith(
    {
        
            
                Option<Status?> status = const None()
            
            
        
    }
) {
    
        final Status? status$next;
        
            switch (status) {

                case Some(value: final data):
                    status$next = data;
                case None():
                    status$next = this.status;
            }
        
    
    return EnumWithDefaultValueVariables(
        
            status: status$next
            
        
    );
}


}


// ------------ Node DEFINITIONS -------------

class EnumWithDefaultValueNode extends Node {
  EnumWithDefaultValueResponse? _obj;
  EnumWithDefaultValueNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = EnumWithDefaultValueResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = EnumWithDefaultValueResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
     if (data != null) {
        _obj = EnumWithDefaultValueResponse.fromJson(data);
     }
  }
  
  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  EnumWithDefaultValueResponse? get obj {
    return _obj;
  }
} 
// ------------ END Node DEFINITIONS -------------