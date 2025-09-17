






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OrderOptWithNullDefaultsRequestResponse{

    
    /// class members
    
        final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest;
    
    // keywordargs constructor
    OrderOptWithNullDefaultsRequestResponse({
    
        this.orderOptWithNullDefaultsRequest,
    
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
            final orderOptWithNullDefaultsRequestNormalized$Key = "orderOptWithNullDefaultsRequest";
            final orderOptWithNullDefaultsRequest$cached = this$NormalizedRecord[orderOptWithNullDefaultsRequestNormalized$Key];
            final orderOptWithNullDefaultsRequest$raw = data["orderOptWithNullDefaultsRequest"];
            if (orderOptWithNullDefaultsRequest$raw != null){
                
                    OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest.updateCachePrivate(
                        orderOptWithNullDefaultsRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderOptWithNullDefaultsRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderOptWithNullDefaultsRequest") && orderOptWithNullDefaultsRequest$cached != null){
                    this$NormalizedRecord[orderOptWithNullDefaultsRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderOptWithNullDefaultsRequestResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderOptWithNullDefaultsRequest$raw = data["orderOptWithNullDefaultsRequest"];
            final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest$value = 
    
        
            orderOptWithNullDefaultsRequest$raw == null ? null :
        
    
;
        return OrderOptWithNullDefaultsRequestResponse(
            orderOptWithNullDefaultsRequest: orderOptWithNullDefaultsRequest$value,
            
        );
    }
    static OrderOptWithNullDefaultsRequestResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "orderOptWithNullDefaultsRequest",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "orderOptWithNullDefaultsRequest")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithNullDefaultsRequestResponse &&
    
        
    
        other.orderOptWithNullDefaultsRequest == orderOptWithNullDefaultsRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptWithNullDefaultsRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptWithNullDefaultsRequest':
            
                
    
        
            this.orderOptWithNullDefaultsRequest?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderOptWithNullDefaultsRequest  {
        
    
    /// class members
    
        final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest;
    
    // keywordargs constructor
    OrderOptWithNullDefaultsRequest({
    
        this.orderOptWithNullDefaultsRequest,
    
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
            final orderOptWithNullDefaultsRequestNormalized$Key = "orderOptWithNullDefaultsRequest";
            final orderOptWithNullDefaultsRequest$cached = this$NormalizedRecord[orderOptWithNullDefaultsRequestNormalized$Key];
            final orderOptWithNullDefaultsRequest$raw = data["orderOptWithNullDefaultsRequest"];
            if (orderOptWithNullDefaultsRequest$raw != null){
                
                    OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest.updateCachePrivate(
                        orderOptWithNullDefaultsRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderOptWithNullDefaultsRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderOptWithNullDefaultsRequest") && orderOptWithNullDefaultsRequest$cached != null){
                    this$NormalizedRecord[orderOptWithNullDefaultsRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderOptWithNullDefaultsRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderOptWithNullDefaultsRequest$raw = data["orderOptWithNullDefaultsRequest"];
            final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest? orderOptWithNullDefaultsRequest$value = 
    
        
            orderOptWithNullDefaultsRequest$raw == null ? null :
        
    
;
        return OrderOptWithNullDefaultsRequest(
            orderOptWithNullDefaultsRequest: orderOptWithNullDefaultsRequest$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithNullDefaultsRequest &&
    
        
    
        other.orderOptWithNullDefaultsRequest == orderOptWithNullDefaultsRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptWithNullDefaultsRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptWithNullDefaultsRequest':
            
                
    
        
            this.orderOptWithNullDefaultsRequest?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest  {
        
    
    /// class members
    
        final int? quantity;
    
        final String? name;
    
        final double? price;
    
    // keywordargs constructor
    OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest({
    
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

    static OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest &&
    
        
    
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


class RequestOrderOptWithNullDefaultsRequest extends Requestable {
    
    final OrderOptWithNullDefaultsRequestVariables variables;
    

    RequestOrderOptWithNullDefaultsRequest(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderOptWithNullDefaultsRequest($order: OrderOptWithNullDefaults!) {
  orderOptWithNullDefaultsRequest(order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OrderOptWithNullDefaultsRequest'
        );
    }
}


class OrderOptWithNullDefaultsRequestVariables {
    
    
        final OrderOptWithNullDefaults order;
    

    OrderOptWithNullDefaultsRequestVariables (
        
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

    
OrderOptWithNullDefaultsRequestVariables updateWith(
    {
        
            
                OrderOptWithNullDefaults? order
            
            
        
    }
) {
    
        final OrderOptWithNullDefaults order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return OrderOptWithNullDefaultsRequestVariables(
        
            order: order$next
            
        
    );
}


}
