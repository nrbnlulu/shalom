






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumInputObjectOptionalResponse{

    
    /// class members
    
        final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt;
    
    // keywordargs constructor
    EnumInputObjectOptionalResponse({
    
        this.updateOrderWithStatusOpt,
    
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
            final updateOrderWithStatusOptNormalized$Key = "updateOrderWithStatusOpt";
            final updateOrderWithStatusOpt$cached = this$NormalizedRecord[updateOrderWithStatusOptNormalized$Key];
            final updateOrderWithStatusOpt$raw = data["updateOrderWithStatusOpt"];
            if (updateOrderWithStatusOpt$raw != null){
                
                    EnumInputObjectOptional_updateOrderWithStatusOpt.updateCachePrivate(
                        updateOrderWithStatusOpt$raw as JsonObject,
                        ctx,
                        this$fieldName: updateOrderWithStatusOptNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateOrderWithStatusOpt") && updateOrderWithStatusOpt$cached != null){
                    this$NormalizedRecord[updateOrderWithStatusOptNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumInputObjectOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateOrderWithStatusOpt$raw = data["updateOrderWithStatusOpt"];
            final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt$value = 
    
        
            updateOrderWithStatusOpt$raw == null ? null :
        
    
;
        return EnumInputObjectOptionalResponse(
            updateOrderWithStatusOpt: updateOrderWithStatusOpt$value,
            
        );
    }
    static EnumInputObjectOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updateOrderWithStatusOpt",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "updateOrderWithStatusOpt")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectOptionalResponse &&
    
        
    
        other.updateOrderWithStatusOpt == updateOrderWithStatusOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderWithStatusOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderWithStatusOpt':
            
                
    
        
            this.updateOrderWithStatusOpt?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumInputObjectOptional  {
        
    
    /// class members
    
        final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt;
    
    // keywordargs constructor
    EnumInputObjectOptional({
    
        this.updateOrderWithStatusOpt,
    
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
            final updateOrderWithStatusOptNormalized$Key = "updateOrderWithStatusOpt";
            final updateOrderWithStatusOpt$cached = this$NormalizedRecord[updateOrderWithStatusOptNormalized$Key];
            final updateOrderWithStatusOpt$raw = data["updateOrderWithStatusOpt"];
            if (updateOrderWithStatusOpt$raw != null){
                
                    EnumInputObjectOptional_updateOrderWithStatusOpt.updateCachePrivate(
                        updateOrderWithStatusOpt$raw as JsonObject,
                        ctx,
                        this$fieldName: updateOrderWithStatusOptNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateOrderWithStatusOpt") && updateOrderWithStatusOpt$cached != null){
                    this$NormalizedRecord[updateOrderWithStatusOptNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumInputObjectOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateOrderWithStatusOpt$raw = data["updateOrderWithStatusOpt"];
            final EnumInputObjectOptional_updateOrderWithStatusOpt? updateOrderWithStatusOpt$value = 
    
        
            updateOrderWithStatusOpt$raw == null ? null :
        
    
;
        return EnumInputObjectOptional(
            updateOrderWithStatusOpt: updateOrderWithStatusOpt$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectOptional &&
    
        
    
        other.updateOrderWithStatusOpt == updateOrderWithStatusOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderWithStatusOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderWithStatusOpt':
            
                
    
        
            this.updateOrderWithStatusOpt?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class EnumInputObjectOptional_updateOrderWithStatusOpt  {
        
    
    /// class members
    
        final Status? status;
    
        final int quantity;
    
        final String name;
    
        final double price;
    
    // keywordargs constructor
    EnumInputObjectOptional_updateOrderWithStatusOpt({
    
        this.status,
    required
        this.quantity,
    required
        this.name,
    required
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
            final statusNormalized$Key = "status";
            final status$cached = this$NormalizedRecord[statusNormalized$Key];
            final status$raw = data["status"];
            if (status$raw != null){
                
                    if (status$cached != status$raw){
                        
                    }
                    this$NormalizedRecord[statusNormalized$Key] = status$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("status") && status$cached != null){
                    this$NormalizedRecord[statusNormalized$Key] = null;
                    
                }
            }

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

    static EnumInputObjectOptional_updateOrderWithStatusOpt fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final status$raw = data["status"];
            final Status? status$value = 
    
        
        
            status$raw == null ? null : Status.fromString(status$raw)
        
    
;
        
            final quantity$raw = data["quantity"];
            final int quantity$value = 
    
        
            
                quantity$raw as int
            
        
    
;
        
            final name$raw = data["name"];
            final String name$value = 
    
        
            
                name$raw as String
            
        
    
;
        
            final price$raw = data["price"];
            final double price$value = 
    
        
            
                price$raw as double
            
        
    
;
        return EnumInputObjectOptional_updateOrderWithStatusOpt(
            status: status$value,
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumInputObjectOptional_updateOrderWithStatusOpt &&
    
        
    
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


class RequestEnumInputObjectOptional extends Requestable {
    
    final EnumInputObjectOptionalVariables variables;
    

    RequestEnumInputObjectOptional(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumInputObjectOptional($order: OrderUpdateStatusOpt!) {
  updateOrderWithStatusOpt(order: $order) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'EnumInputObjectOptional'
        );
    }
}


class EnumInputObjectOptionalVariables {
    
    
        final OrderUpdateStatusOpt order;
    

    EnumInputObjectOptionalVariables (
        
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

    
EnumInputObjectOptionalVariables updateWith(
    {
        
            
                OrderUpdateStatusOpt? order
            
            
        
    }
) {
    
        final OrderUpdateStatusOpt order$next;
        
            if (order != null) {
                order$next = order;
            } else {
                order$next = this.order;
            }
        
    
    return EnumInputObjectOptionalVariables(
        
            order: order$next
            
        
    );
}


}
