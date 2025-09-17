






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetOrderResponse{

    
    /// class members
    
        final GetOrder_getOrder? getOrder;
    
    // keywordargs constructor
    GetOrderResponse({
    
        this.getOrder,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final getOrderNormalized$Key = "getOrder";
            final getOrder$cached = this$NormalizedRecord[getOrderNormalized$Key];
            final getOrder$raw = data["getOrder"];
            if (getOrder$raw != null){
                
                    GetOrder_getOrder.updateCachePrivate(
                        getOrder$raw as JsonObject,
                        ctx,
                        this$fieldName: getOrderNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getOrder") && getOrder$cached != null){
                    this$NormalizedRecord[getOrderNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetOrderResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getOrder$raw = data["getOrder"];
            final GetOrder_getOrder? getOrder$value = 
    
        
            getOrder$raw == null ? null :
        
    
;
        return GetOrderResponse(
            getOrder: getOrder$value,
            
        );
    }
    static GetOrderResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "getOrder",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "getOrder")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetOrderResponse &&
    
        
    
        other.getOrder == getOrder
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getOrder.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getOrder':
            
                
    
        
            this.getOrder?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetOrder  {
        
    
    /// class members
    
        final GetOrder_getOrder? getOrder;
    
    // keywordargs constructor
    GetOrder({
    
        this.getOrder,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final getOrderNormalized$Key = "getOrder";
            final getOrder$cached = this$NormalizedRecord[getOrderNormalized$Key];
            final getOrder$raw = data["getOrder"];
            if (getOrder$raw != null){
                
                    GetOrder_getOrder.updateCachePrivate(
                        getOrder$raw as JsonObject,
                        ctx,
                        this$fieldName: getOrderNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getOrder") && getOrder$cached != null){
                    this$NormalizedRecord[getOrderNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetOrder fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getOrder$raw = data["getOrder"];
            final GetOrder_getOrder? getOrder$value = 
    
        
            getOrder$raw == null ? null :
        
    
;
        return GetOrder(
            getOrder: getOrder$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetOrder &&
    
        
    
        other.getOrder == getOrder
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getOrder.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getOrder':
            
                
    
        
            this.getOrder?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class GetOrder_getOrder  {
        
    
    /// class members
    
        final int? quantity;
    
        final String? name;
    
        final double? price;
    
    // keywordargs constructor
    GetOrder_getOrder({
    
        this.quantity,
    
        this.name,
    
        this.price,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final quantityNormalized$Key = "quantity";
            final quantity$cached = this$NormalizedRecord[quantityNormalized$Key];
            final quantity$raw = data["quantity"];
            if (quantity$raw != null){
                
                    if (quantity$cached != quantity$raw){
                        
                    }
                    this$NormalizedRecord[quantityNormalized$Key] = quantity$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("quantity") && quantity$cached != null){
                    this$NormalizedRecord[quantityNormalized$Key] = null;
                    
                }
            }

        // TODO: handle arguments
            final nameNormalized$Key = "name";
            final name$cached = this$NormalizedRecord[nameNormalized$Key];
            final name$raw = data["name"];
            if (name$raw != null){
                
                    if (name$cached != name$raw){
                        
                    }
                    this$NormalizedRecord[nameNormalized$Key] = name$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("name") && name$cached != null){
                    this$NormalizedRecord[nameNormalized$Key] = null;
                    
                }
            }

        // TODO: handle arguments
            final priceNormalized$Key = "price";
            final price$cached = this$NormalizedRecord[priceNormalized$Key];
            final price$raw = data["price"];
            if (price$raw != null){
                
                    if (price$cached != price$raw){
                        
                    }
                    this$NormalizedRecord[priceNormalized$Key] = price$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("price") && price$cached != null){
                    this$NormalizedRecord[priceNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetOrder_getOrder fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final quantity$raw = data["quantity"];
            final int? quantity$value = 
    
        
            
                quantity$raw as int?
            
        
    
;
        
            final name$raw = data["name"];
            final String? name$value = 
    
        
            
                name$raw as String?
            
        
    
;
        
            final price$raw = data["price"];
            final double? price$value = 
    
        
            
                price$raw as double?
            
        
    
;
        return GetOrder_getOrder(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetOrder_getOrder &&
    
        
    
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
        
            
            quantity,
        
            
            name,
        
            
            price,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
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


class RequestGetOrder extends Requestable {
    
    final GetOrderVariables variables;
    

    RequestGetOrder(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query GetOrder($id: ID!, $order: Order) {
  getOrder(id: $id, order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetOrder'
        );
    }
}


class GetOrderVariables {
    
    
        final String id;
    
        final Option<Order?> order;
    

    GetOrderVariables (
        
            {
            

    
        
            required this.id
        ,
    
    
    
        
            this.order = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    

    
    
        if (order.isSome()) {
            final value = this.order.some();
            data["order"] = 
    
        
            value?.toJson()
        
    
;
        }
    


        return data;
    }

    
GetOrderVariables updateWith(
    {
        
            
                String? id
            
            ,
        
            
                Option<Option<Order?>> order = const None()
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
        final Option<Order?> order$next;
        
            switch (order) {

                case Some(value: final updateData):
                    order$next = updateData;
                case None():
                    order$next = this.order;
            }

        
    
    return GetOrderVariables(
        
            id: id$next
            ,
        
            order: order$next
            
        
    );
}


}
