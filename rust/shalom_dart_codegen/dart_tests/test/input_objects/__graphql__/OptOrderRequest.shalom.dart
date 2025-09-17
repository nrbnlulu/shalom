






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OptOrderRequestResponse{

    
    /// class members
    
        final OptOrderRequest_optOrderRequest? optOrderRequest;
    
    // keywordargs constructor
    OptOrderRequestResponse({
    
        this.optOrderRequest,
    
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
            final optOrderRequestNormalized$Key = "optOrderRequest";
            final optOrderRequest$cached = this$NormalizedRecord[optOrderRequestNormalized$Key];
            final optOrderRequest$raw = data["optOrderRequest"];
            if (optOrderRequest$raw != null){
                
                    OptOrderRequest_optOrderRequest.updateCachePrivate(
                        optOrderRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: optOrderRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("optOrderRequest") && optOrderRequest$cached != null){
                    this$NormalizedRecord[optOrderRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptOrderRequestResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final optOrderRequest$raw = data["optOrderRequest"];
            final OptOrderRequest_optOrderRequest? optOrderRequest$value = 
    
        
            optOrderRequest$raw == null ? null :
        
    
;
        return OptOrderRequestResponse(
            optOrderRequest: optOrderRequest$value,
            
        );
    }
    static OptOrderRequestResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "optOrderRequest",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "optOrderRequest")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptOrderRequestResponse &&
    
        
    
        other.optOrderRequest == optOrderRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        optOrderRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'optOrderRequest':
            
                
    
        
            this.optOrderRequest?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OptOrderRequest  {
        
    
    /// class members
    
        final OptOrderRequest_optOrderRequest? optOrderRequest;
    
    // keywordargs constructor
    OptOrderRequest({
    
        this.optOrderRequest,
    
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
            final optOrderRequestNormalized$Key = "optOrderRequest";
            final optOrderRequest$cached = this$NormalizedRecord[optOrderRequestNormalized$Key];
            final optOrderRequest$raw = data["optOrderRequest"];
            if (optOrderRequest$raw != null){
                
                    OptOrderRequest_optOrderRequest.updateCachePrivate(
                        optOrderRequest$raw as JsonObject,
                        ctx,
                        this$fieldName: optOrderRequestNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("optOrderRequest") && optOrderRequest$cached != null){
                    this$NormalizedRecord[optOrderRequestNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptOrderRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final optOrderRequest$raw = data["optOrderRequest"];
            final OptOrderRequest_optOrderRequest? optOrderRequest$value = 
    
        
            optOrderRequest$raw == null ? null :
        
    
;
        return OptOrderRequest(
            optOrderRequest: optOrderRequest$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptOrderRequest &&
    
        
    
        other.optOrderRequest == optOrderRequest
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        optOrderRequest.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'optOrderRequest':
            
                
    
        
            this.optOrderRequest?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OptOrderRequest_optOrderRequest  {
        
    
    /// class members
    
        final int? quantity;
    
        final String? name;
    
        final double? price;
    
    // keywordargs constructor
    OptOrderRequest_optOrderRequest({
    
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

    static OptOrderRequest_optOrderRequest fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return OptOrderRequest_optOrderRequest(
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptOrderRequest_optOrderRequest &&
    
        
    
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


class RequestOptOrderRequest extends Requestable {
    
    final OptOrderRequestVariables variables;
    

    RequestOptOrderRequest(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OptOrderRequest($order: Order) {
  optOrderRequest(order: $order) {
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OptOrderRequest'
        );
    }
}


class OptOrderRequestVariables {
    
    
        final Option<Order?> order;
    

    OptOrderRequestVariables (
        
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

    
OptOrderRequestVariables updateWith(
    {
        
            
                Option<Option<Order?>> order = const None()
            
            
        
    }
) {
    
        final Option<Order?> order$next;
        
            switch (order) {

                case Some(value: final updateData):
                    order$next = updateData;
                case None():
                    order$next = this.order;
            }

        
    
    return OptOrderRequestVariables(
        
            order: order$next
            
        
    );
}


}
