






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumRequiredResponse{

    
    /// class members
    
        final EnumRequired_updateOrderStatus? updateOrderStatus;
    
    // keywordargs constructor
    EnumRequiredResponse({
    
        this.updateOrderStatus,
    
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
            final updateOrderStatusNormalized$Key = "updateOrderStatus";
            final updateOrderStatus$cached = this$NormalizedRecord[updateOrderStatusNormalized$Key];
            final updateOrderStatus$raw = data["updateOrderStatus"];
            if (updateOrderStatus$raw != null){
                
                    EnumRequired_updateOrderStatus.updateCachePrivate(
                        updateOrderStatus$raw as JsonObject,
                        ctx,
                        this$fieldName: updateOrderStatusNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateOrderStatus") && updateOrderStatus$cached != null){
                    this$NormalizedRecord[updateOrderStatusNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumRequiredResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateOrderStatus$raw = data["updateOrderStatus"];
            final EnumRequired_updateOrderStatus? updateOrderStatus$value = 
    
        
            updateOrderStatus$raw == null ? null :
        
    
;
        return EnumRequiredResponse(
            updateOrderStatus: updateOrderStatus$value,
            
        );
    }
    static EnumRequiredResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updateOrderStatus",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "updateOrderStatus")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumRequiredResponse &&
    
        
    
        other.updateOrderStatus == updateOrderStatus
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderStatus.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderStatus':
            
                
    
        
            this.updateOrderStatus?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumRequired  {
        
    
    /// class members
    
        final EnumRequired_updateOrderStatus? updateOrderStatus;
    
    // keywordargs constructor
    EnumRequired({
    
        this.updateOrderStatus,
    
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
            final updateOrderStatusNormalized$Key = "updateOrderStatus";
            final updateOrderStatus$cached = this$NormalizedRecord[updateOrderStatusNormalized$Key];
            final updateOrderStatus$raw = data["updateOrderStatus"];
            if (updateOrderStatus$raw != null){
                
                    EnumRequired_updateOrderStatus.updateCachePrivate(
                        updateOrderStatus$raw as JsonObject,
                        ctx,
                        this$fieldName: updateOrderStatusNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateOrderStatus") && updateOrderStatus$cached != null){
                    this$NormalizedRecord[updateOrderStatusNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumRequired fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateOrderStatus$raw = data["updateOrderStatus"];
            final EnumRequired_updateOrderStatus? updateOrderStatus$value = 
    
        
            updateOrderStatus$raw == null ? null :
        
    
;
        return EnumRequired(
            updateOrderStatus: updateOrderStatus$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumRequired &&
    
        
    
        other.updateOrderStatus == updateOrderStatus
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateOrderStatus.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateOrderStatus':
            
                
    
        
            this.updateOrderStatus?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class EnumRequired_updateOrderStatus  {
        
    
    /// class members
    
        final Status? status;
    
        final int quantity;
    
        final String name;
    
        final double price;
    
    // keywordargs constructor
    EnumRequired_updateOrderStatus({
    
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

    static EnumRequired_updateOrderStatus fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return EnumRequired_updateOrderStatus(
            status: status$value,
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumRequired_updateOrderStatus &&
    
        
    
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


class RequestEnumRequired extends Requestable {
    
    final EnumRequiredVariables variables;
    

    RequestEnumRequired(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation EnumRequired($status: Status!) {
  updateOrderStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'EnumRequired'
        );
    }
}


class EnumRequiredVariables {
    
    
        final Status status;
    

    EnumRequiredVariables (
        
            {
            

    
        
            required this.status
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["status"] = 
    
        
            this.status.name
        
    
;
    


        return data;
    }

    
EnumRequiredVariables updateWith(
    {
        
            
                Status? status
            
            
        
    }
) {
    
        final Status status$next;
        
            if (status != null) {
                status$next = status;
            } else {
                status$next = this.status;
            }
        
    
    return EnumRequiredVariables(
        
            status: status$next
            
        
    );
}


}
