






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OrderRecursiveResponse{

    
    /// class members
    
        final OrderRecursive_orderRecursive? orderRecursive;
    
    // keywordargs constructor
    OrderRecursiveResponse({
    
        this.orderRecursive,
    
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
            final orderRecursiveNormalized$Key = "orderRecursive";
            final orderRecursive$cached = this$NormalizedRecord[orderRecursiveNormalized$Key];
            final orderRecursive$raw = data["orderRecursive"];
            if (orderRecursive$raw != null){
                
                    OrderRecursive_orderRecursive.updateCachePrivate(
                        orderRecursive$raw as JsonObject,
                        ctx,
                        this$fieldName: orderRecursiveNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderRecursive") && orderRecursive$cached != null){
                    this$NormalizedRecord[orderRecursiveNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderRecursiveResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderRecursive$raw = data["orderRecursive"];
            final OrderRecursive_orderRecursive? orderRecursive$value = 
    
        
            orderRecursive$raw == null ? null :
        
    
;
        return OrderRecursiveResponse(
            orderRecursive: orderRecursive$value,
            
        );
    }
    static OrderRecursiveResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "orderRecursive",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "orderRecursive")
            );
            return fromJsonImpl(data, ctx);
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
            
                
    
        
            this.orderRecursive?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderRecursive  {
        
    
    /// class members
    
        final OrderRecursive_orderRecursive? orderRecursive;
    
    // keywordargs constructor
    OrderRecursive({
    
        this.orderRecursive,
    
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
            final orderRecursiveNormalized$Key = "orderRecursive";
            final orderRecursive$cached = this$NormalizedRecord[orderRecursiveNormalized$Key];
            final orderRecursive$raw = data["orderRecursive"];
            if (orderRecursive$raw != null){
                
                    OrderRecursive_orderRecursive.updateCachePrivate(
                        orderRecursive$raw as JsonObject,
                        ctx,
                        this$fieldName: orderRecursiveNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderRecursive") && orderRecursive$cached != null){
                    this$NormalizedRecord[orderRecursiveNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderRecursive fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderRecursive$raw = data["orderRecursive"];
            final OrderRecursive_orderRecursive? orderRecursive$value = 
    
        
            orderRecursive$raw == null ? null :
        
    
;
        return OrderRecursive(
            orderRecursive: orderRecursive$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRecursive &&
    
        
    
        other.orderRecursive == orderRecursive
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderRecursive.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderRecursive':
            
                
    
        
            this.orderRecursive?.toJson()
        
    

            
        ,
    
    };
    }

    }

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

    static OrderRecursive_orderRecursive fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return OrderRecursive_orderRecursive(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRecursive_orderRecursive &&
    
        
    
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
            opName: 'OrderRecursive'
        );
    }
}


class OrderRecursiveVariables {
    
    
        final Option<OrderRecursive?> order;
    

    OrderRecursiveVariables (
        
            {
            

    
        
            this.order = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (order.isSome()) {
            final value = this.order.some();
            data["order"] = 
    
        
            value?.toJson()
        
    
;
        }
    


        return data;
    }

    
OrderRecursiveVariables updateWith(
    {
        
            
                Option<Option<OrderRecursive?>> order = const None()
            
            
        
    }
) {
    
        final Option<OrderRecursive?> order$next;
        
            switch (order) {

                case Some(value: final updateData):
                    order$next = updateData;
                case None():
                    order$next = this.order;
            }

        
    
    return OrderRecursiveVariables(
        
            order: order$next
            
        
    );
}


}
