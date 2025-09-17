






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OrderRequestResponse{

    
    /// class members
    
        final OrderRequest_orderRequest? orderRequest;
    
    // keywordargs constructor
    OrderRequestResponse({
    
        this.orderRequest,
    
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
            final orderRequestNormalized$Key = "orderRequest";
            final orderRequest$cached = this$NormalizedRecord[orderRequestNormalized$Key];
            final orderRequest$raw = data["orderRequest"];
            if (orderRequest$raw != null){
                
                    OrderRequest_orderRequest.updateCachePrivate(
                        orderRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderRequest") && orderRequest$cached != null){
                    this$NormalizedRecord[orderRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderRequestResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderRequest$raw = data["orderRequest"];
            final OrderRequest_orderRequest? orderRequest$value = 
    
        
            orderRequest$raw == null ? null :
        
    
;
        return OrderRequestResponse(
            orderRequest: orderRequest$value,
            
        );
    }
    static OrderRequestResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "orderRequest",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "orderRequest")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRequestResponse &&
    
        
    
        other.orderRequest == orderRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderRequest':
            
                
    
        
            this.orderRequest?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderRequest  {
        
    
    /// class members
    
        final OrderRequest_orderRequest? orderRequest;
    
    // keywordargs constructor
    OrderRequest({
    
        this.orderRequest,
    
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
            final orderRequestNormalized$Key = "orderRequest";
            final orderRequest$cached = this$NormalizedRecord[orderRequestNormalized$Key];
            final orderRequest$raw = data["orderRequest"];
            if (orderRequest$raw != null){
                
                    OrderRequest_orderRequest.updateCachePrivate(
                        orderRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderRequest") && orderRequest$cached != null){
                    this$NormalizedRecord[orderRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderRequest$raw = data["orderRequest"];
            final OrderRequest_orderRequest? orderRequest$value = 
    
        
            orderRequest$raw == null ? null :
        
    
;
        return OrderRequest(
            orderRequest: orderRequest$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRequest &&
    
        
    
        other.orderRequest == orderRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderRequest':
            
                
    
        
            this.orderRequest?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OrderRequest_orderRequest  {
        
    
    /// class members
    
        final int? quantity;
    
        final String? name;
    
        final double? price;
    
    // keywordargs constructor
    OrderRequest_orderRequest({
    
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

    static OrderRequest_orderRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return OrderRequest_orderRequest(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderRequest_orderRequest &&
    
        
    
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


class RequestOrderRequest extends Requestable {
    
    final OrderRequestVariables variables;
    

    RequestOrderRequest(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderRequest($order: Order!) {
  orderRequest(order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OrderRequest'
        );
    }
}


class OrderRequestVariables {
    
    
        final Order order;
    

    OrderRequestVariables (
        
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

    
OrderRequestVariables updateWith(
    {
        
            
                Order? order
            
            
        
    }
) {
    
        final Order order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return OrderRequestVariables(
        
            order: order$next
            
        
    );
}


}
