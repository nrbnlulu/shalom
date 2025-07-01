














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumInputObjectRequiredResponse{

    /// class members
    
        
            final EnumInputObjectRequired_updateOrder? updateOrder;   
        
    
    // keywordargs constructor
    EnumInputObjectRequiredResponse({
    
        this.updateOrder,
    
    });
    static EnumInputObjectRequiredResponse fromJson(JsonObject data) {
    
        
            final EnumInputObjectRequired_updateOrder? updateOrder_value;
            
                final JsonObject? updateOrder$raw = data['updateOrder']; 
                if (updateOrder$raw != null) {
                    updateOrder_value = EnumInputObjectRequired_updateOrder.fromJson(updateOrder$raw);
                } else {
                    updateOrder_value = null;
                }
            
        
    
    return EnumInputObjectRequiredResponse(
    
        
        updateOrder: updateOrder_value,
    
    );
    }
    EnumInputObjectRequiredResponse updateWithJson(JsonObject data) {
    
        
        final EnumInputObjectRequired_updateOrder? updateOrder_value;
        if (data.containsKey('updateOrder')) {
            
                final JsonObject? updateOrder$raw = data['updateOrder'];
                if (updateOrder$raw != null) {
                    updateOrder_value = EnumInputObjectRequired_updateOrder.fromJson(updateOrder$raw);
                } else {
                    updateOrder_value = null;
                }
            
        } else {
            updateOrder_value = updateOrder;
        }

    
    
    return EnumInputObjectRequiredResponse(
    
        
        updateOrder: updateOrder_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectRequiredResponse &&
    
        other.updateOrder == updateOrder 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrder.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrder':
            
                updateOrder?.toJson()
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------


    class EnumInputObjectRequired_updateOrder  {
        
    /// class members
    
        
            final Status? status;
        
    
        
            final int quantity;
        
    
        
            final String name;
        
    
        
            final double price;
        
    
    // keywordargs constructor
    EnumInputObjectRequired_updateOrder({
    
        this.status,
    required
        this.quantity,
    required
        this.name,
    required
        this.price,
    
    });
    static EnumInputObjectRequired_updateOrder fromJson(JsonObject data) {
    
        
            
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
            

        
    
    return EnumInputObjectRequired_updateOrder(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    EnumInputObjectRequired_updateOrder updateWithJson(JsonObject data) {
    
        
            
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

        
    
    return EnumInputObjectRequired_updateOrder(
    
        
        status: status_value,
    
        
        quantity: quantity_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectRequired_updateOrder &&
    
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


class RequestEnumInputObjectRequired extends Requestable {
    
    final EnumInputObjectRequiredVariables variables;
    

    RequestEnumInputObjectRequired(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumInputObjectRequired($order: OrderUpdate!) {
  updateOrder(order: $order) {
    status
    quantity
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'EnumInputObjectRequired'
        );
    }
}


class EnumInputObjectRequiredVariables {
    
    
        final OrderUpdate order;
    

    EnumInputObjectRequiredVariables (
        
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

    
EnumInputObjectRequiredVariables updateWith(
    {
        
            
                OrderUpdate? order
            
            
        
    }
) {
    
        final OrderUpdate order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return EnumInputObjectRequiredVariables(
        
            order: order$next
            
        
    );
}


}


// ------------ Node DEFINITIONS -------------

class EnumInputObjectRequiredNode extends Node {
  EnumInputObjectRequiredResponse? _obj;
  EnumInputObjectRequiredNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = EnumInputObjectRequiredResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = EnumInputObjectRequiredResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
     if (data != null) {
        _obj = EnumInputObjectRequiredResponse.fromJson(data);
     }
  }
  
  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  EnumInputObjectRequiredResponse? get obj {
    return _obj;
  }
} 
// ------------ END Node DEFINITIONS -------------