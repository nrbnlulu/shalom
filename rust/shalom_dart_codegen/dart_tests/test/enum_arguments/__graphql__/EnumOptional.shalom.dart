






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumOptionalResponse{

    
    /// class members
    
        final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt;
    
    // keywordargs constructor
    EnumOptionalResponse({
    
        this.updateOrderStatusOpt,
    
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
            final updateOrderStatusOptNormalized$Key = "updateOrderStatusOpt";
            final updateOrderStatusOpt$cached = this$NormalizedRecord[updateOrderStatusOptNormalized$Key];
            final updateOrderStatusOpt$raw = data["updateOrderStatusOpt"];
            if (updateOrderStatusOpt$raw != null){
                
                    EnumOptional_updateOrderStatusOpt.updateCachePrivate(
                        updateOrderStatusOpt$raw as JsonObject,
                        ctx,
                        this$fieldName: updateOrderStatusOptNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateOrderStatusOpt") && updateOrderStatusOpt$cached != null){
                    this$NormalizedRecord[updateOrderStatusOptNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateOrderStatusOpt$raw = data["updateOrderStatusOpt"];
            final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt$value = 
    
        
            updateOrderStatusOpt$raw == null ? null :
        
    
;
        return EnumOptionalResponse(
            updateOrderStatusOpt: updateOrderStatusOpt$value,
            
        );
    }
    static EnumOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updateOrderStatusOpt",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "updateOrderStatusOpt")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumOptionalResponse &&
    
        
    
        other.updateOrderStatusOpt == updateOrderStatusOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderStatusOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderStatusOpt':
            
                
    
        
            this.updateOrderStatusOpt?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumOptional  {
        
    
    /// class members
    
        final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt;
    
    // keywordargs constructor
    EnumOptional({
    
        this.updateOrderStatusOpt,
    
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
            final updateOrderStatusOptNormalized$Key = "updateOrderStatusOpt";
            final updateOrderStatusOpt$cached = this$NormalizedRecord[updateOrderStatusOptNormalized$Key];
            final updateOrderStatusOpt$raw = data["updateOrderStatusOpt"];
            if (updateOrderStatusOpt$raw != null){
                
                    EnumOptional_updateOrderStatusOpt.updateCachePrivate(
                        updateOrderStatusOpt$raw as JsonObject,
                        ctx,
                        this$fieldName: updateOrderStatusOptNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateOrderStatusOpt") && updateOrderStatusOpt$cached != null){
                    this$NormalizedRecord[updateOrderStatusOptNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateOrderStatusOpt$raw = data["updateOrderStatusOpt"];
            final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt$value = 
    
        
            updateOrderStatusOpt$raw == null ? null :
        
    
;
        return EnumOptional(
            updateOrderStatusOpt: updateOrderStatusOpt$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumOptional &&
    
        
    
        other.updateOrderStatusOpt == updateOrderStatusOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderStatusOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderStatusOpt':
            
                
    
        
            this.updateOrderStatusOpt?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class EnumOptional_updateOrderStatusOpt  {
        
    
    /// class members
    
        final Status? status;
    
        final int quantity;
    
        final String name;
    
        final double price;
    
    // keywordargs constructor
    EnumOptional_updateOrderStatusOpt({
    
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

    static EnumOptional_updateOrderStatusOpt fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return EnumOptional_updateOrderStatusOpt(
            status: status$value,
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumOptional_updateOrderStatusOpt &&
    
        
    
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


class RequestEnumOptional extends Requestable {
    
    final EnumOptionalVariables variables;
    

    RequestEnumOptional(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumOptional($status: Status) {
  updateOrderStatusOpt(status: $status) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'EnumOptional'
        );
    }
}


class EnumOptionalVariables {
    
    
        final Option<Status?> status;
    

    EnumOptionalVariables (
        
            {
            

    
        
            this.status = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (status.isSome()) {
            final value = this.status.some();
            data["status"] = 
    
        
            value?.name
        
    
;
        }
    


        return data;
    }

    
EnumOptionalVariables updateWith(
    {
        
            
                Option<Option<Status?>> status = const None()
            
            
        
    }
) {
    
        final Option<Status?> status$next;
        
            switch (status) {

                case Some(value: final updateData):
                    status$next = updateData;
                case None():
                    status$next = this.status;
            }

        
    
    return EnumOptionalVariables(
        
            status: status$next
            
        
    );
}


}
