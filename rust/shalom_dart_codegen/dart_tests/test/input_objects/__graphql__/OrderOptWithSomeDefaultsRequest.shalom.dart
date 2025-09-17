






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OrderOptWithSomeDefaultsRequestResponse{

    
    /// class members
    
        final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest? orderOptWithSomeDefaultsRequest;
    
    // keywordargs constructor
    OrderOptWithSomeDefaultsRequestResponse({
    
        this.orderOptWithSomeDefaultsRequest,
    
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
            final orderOptWithSomeDefaultsRequestNormalized$Key = "orderOptWithSomeDefaultsRequest";
            final orderOptWithSomeDefaultsRequest$cached = this$NormalizedRecord[orderOptWithSomeDefaultsRequestNormalized$Key];
            final orderOptWithSomeDefaultsRequest$raw = data["orderOptWithSomeDefaultsRequest"];
            if (orderOptWithSomeDefaultsRequest$raw != null){
                
                    OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest.updateCachePrivate(
                        orderOptWithSomeDefaultsRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderOptWithSomeDefaultsRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderOptWithSomeDefaultsRequest") && orderOptWithSomeDefaultsRequest$cached != null){
                    this$NormalizedRecord[orderOptWithSomeDefaultsRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderOptWithSomeDefaultsRequestResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderOptWithSomeDefaultsRequest$raw = data["orderOptWithSomeDefaultsRequest"];
            final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest? orderOptWithSomeDefaultsRequest$value = 
    
        
            orderOptWithSomeDefaultsRequest$raw == null ? null :
        
    
;
        return OrderOptWithSomeDefaultsRequestResponse(
            orderOptWithSomeDefaultsRequest: orderOptWithSomeDefaultsRequest$value,
            
        );
    }
    static OrderOptWithSomeDefaultsRequestResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "orderOptWithSomeDefaultsRequest",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "orderOptWithSomeDefaultsRequest")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithSomeDefaultsRequestResponse &&
    
        
    
        other.orderOptWithSomeDefaultsRequest == orderOptWithSomeDefaultsRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptWithSomeDefaultsRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptWithSomeDefaultsRequest':
            
                
    
        
            this.orderOptWithSomeDefaultsRequest?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderOptWithSomeDefaultsRequest  {
        
    
    /// class members
    
        final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest? orderOptWithSomeDefaultsRequest;
    
    // keywordargs constructor
    OrderOptWithSomeDefaultsRequest({
    
        this.orderOptWithSomeDefaultsRequest,
    
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
            final orderOptWithSomeDefaultsRequestNormalized$Key = "orderOptWithSomeDefaultsRequest";
            final orderOptWithSomeDefaultsRequest$cached = this$NormalizedRecord[orderOptWithSomeDefaultsRequestNormalized$Key];
            final orderOptWithSomeDefaultsRequest$raw = data["orderOptWithSomeDefaultsRequest"];
            if (orderOptWithSomeDefaultsRequest$raw != null){
                
                    OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest.updateCachePrivate(
                        orderOptWithSomeDefaultsRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderOptWithSomeDefaultsRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderOptWithSomeDefaultsRequest") && orderOptWithSomeDefaultsRequest$cached != null){
                    this$NormalizedRecord[orderOptWithSomeDefaultsRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderOptWithSomeDefaultsRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderOptWithSomeDefaultsRequest$raw = data["orderOptWithSomeDefaultsRequest"];
            final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest? orderOptWithSomeDefaultsRequest$value = 
    
        
            orderOptWithSomeDefaultsRequest$raw == null ? null :
        
    
;
        return OrderOptWithSomeDefaultsRequest(
            orderOptWithSomeDefaultsRequest: orderOptWithSomeDefaultsRequest$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithSomeDefaultsRequest &&
    
        
    
        other.orderOptWithSomeDefaultsRequest == orderOptWithSomeDefaultsRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptWithSomeDefaultsRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptWithSomeDefaultsRequest':
            
                
    
        
            this.orderOptWithSomeDefaultsRequest?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest  {
        
    
    /// class members
    
        final int? quantity;
    
        final String? name;
    
        final double? price;
    
    // keywordargs constructor
    OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest({
    
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

    static OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest &&
    
        
    
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


class RequestOrderOptWithSomeDefaultsRequest extends Requestable {
    
    final OrderOptWithSomeDefaultsRequestVariables variables;
    

    RequestOrderOptWithSomeDefaultsRequest(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderOptWithSomeDefaultsRequest($order: OrderOptWithSomeDefaults!) {
  orderOptWithSomeDefaultsRequest(order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OrderOptWithSomeDefaultsRequest'
        );
    }
}


class OrderOptWithSomeDefaultsRequestVariables {
    
    
        final OrderOptWithSomeDefaults order;
    

    OrderOptWithSomeDefaultsRequestVariables (
        
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

    
OrderOptWithSomeDefaultsRequestVariables updateWith(
    {
        
            
                OrderOptWithSomeDefaults? order
            
            
        
    }
) {
    
        final OrderOptWithSomeDefaults order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return OrderOptWithSomeDefaultsRequestVariables(
        
            order: order$next
            
        
    );
}


}
