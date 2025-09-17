






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OrderOptRequestResponse{

    
    /// class members
    
        final OrderOptRequest_orderOptRequest? orderOptRequest;
    
    // keywordargs constructor
    OrderOptRequestResponse({
    
        this.orderOptRequest,
    
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
            final orderOptRequestNormalized$Key = "orderOptRequest";
            final orderOptRequest$cached = this$NormalizedRecord[orderOptRequestNormalized$Key];
            final orderOptRequest$raw = data["orderOptRequest"];
            if (orderOptRequest$raw != null){
                
                    OrderOptRequest_orderOptRequest.updateCachePrivate(
                        orderOptRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderOptRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderOptRequest") && orderOptRequest$cached != null){
                    this$NormalizedRecord[orderOptRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderOptRequestResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderOptRequest$raw = data["orderOptRequest"];
            final OrderOptRequest_orderOptRequest? orderOptRequest$value = 
    
        
            orderOptRequest$raw == null ? null :
        
    
;
        return OrderOptRequestResponse(
            orderOptRequest: orderOptRequest$value,
            
        );
    }
    static OrderOptRequestResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "orderOptRequest",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "orderOptRequest")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptRequestResponse &&
    
        
    
        other.orderOptRequest == orderOptRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptRequest':
            
                
    
        
            this.orderOptRequest?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OrderOptRequest  {
        
    
    /// class members
    
        final OrderOptRequest_orderOptRequest? orderOptRequest;
    
    // keywordargs constructor
    OrderOptRequest({
    
        this.orderOptRequest,
    
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
            final orderOptRequestNormalized$Key = "orderOptRequest";
            final orderOptRequest$cached = this$NormalizedRecord[orderOptRequestNormalized$Key];
            final orderOptRequest$raw = data["orderOptRequest"];
            if (orderOptRequest$raw != null){
                
                    OrderOptRequest_orderOptRequest.updateCachePrivate(
                        orderOptRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: orderOptRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("orderOptRequest") && orderOptRequest$cached != null){
                    this$NormalizedRecord[orderOptRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OrderOptRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final orderOptRequest$raw = data["orderOptRequest"];
            final OrderOptRequest_orderOptRequest? orderOptRequest$value = 
    
        
            orderOptRequest$raw == null ? null :
        
    
;
        return OrderOptRequest(
            orderOptRequest: orderOptRequest$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptRequest &&
    
        
    
        other.orderOptRequest == orderOptRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        orderOptRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'orderOptRequest':
            
                
    
        
            this.orderOptRequest?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OrderOptRequest_orderOptRequest  {
        
    
    /// class members
    
        final int? quantity;
    
        final String? name;
    
        final double? price;
    
    // keywordargs constructor
    OrderOptRequest_orderOptRequest({
    
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

    static OrderOptRequest_orderOptRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return OrderOptRequest_orderOptRequest(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OrderOptRequest_orderOptRequest &&
    
        
    
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


class RequestOrderOptRequest extends Requestable {
    
    final OrderOptRequestVariables variables;
    

    RequestOrderOptRequest(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OrderOptRequest($order: OrderOpt!) {
  orderOptRequest(order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OrderOptRequest'
        );
    }
}


class OrderOptRequestVariables {
    
    
        final OrderOpt order;
    

    OrderOptRequestVariables (
        
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

    
OrderOptRequestVariables updateWith(
    {
        
            
                OrderOpt? order
            
            
        
    }
) {
    
        final OrderOpt order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return OrderOptRequestVariables(
        
            order: order$next
            
        
    );
}


}
