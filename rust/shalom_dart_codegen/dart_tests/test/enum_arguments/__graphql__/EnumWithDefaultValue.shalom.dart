






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class EnumWithDefaultValueResponse{

    
    /// class members
    
        final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus;
    
    // keywordargs constructor
    EnumWithDefaultValueResponse({
    
        this.getOrderByStatus,
    
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
            final getOrderByStatusNormalized$Key = "getOrderByStatus";
            final getOrderByStatus$cached = this$NormalizedRecord[getOrderByStatusNormalized$Key];
            final getOrderByStatus$raw = data["getOrderByStatus"];
            if (getOrderByStatus$raw != null){
                
                    EnumWithDefaultValue_getOrderByStatus.updateCachePrivate(
                        getOrderByStatus$raw as JsonObject,
                        ctx,
                        this$fieldName: getOrderByStatusNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getOrderByStatus") && getOrderByStatus$cached != null){
                    this$NormalizedRecord[getOrderByStatusNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumWithDefaultValueResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getOrderByStatus$raw = data["getOrderByStatus"];
            final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus$value = 
    
        
            getOrderByStatus$raw == null ? null :
        
    
;
        return EnumWithDefaultValueResponse(
            getOrderByStatus: getOrderByStatus$value,
            
        );
    }
    static EnumWithDefaultValueResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "getOrderByStatus",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "getOrderByStatus")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumWithDefaultValueResponse &&
    
        
    
        other.getOrderByStatus == getOrderByStatus
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getOrderByStatus.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getOrderByStatus':
            
                
    
        
            this.getOrderByStatus?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class EnumWithDefaultValue  {
        
    
    /// class members
    
        final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus;
    
    // keywordargs constructor
    EnumWithDefaultValue({
    
        this.getOrderByStatus,
    
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
            final getOrderByStatusNormalized$Key = "getOrderByStatus";
            final getOrderByStatus$cached = this$NormalizedRecord[getOrderByStatusNormalized$Key];
            final getOrderByStatus$raw = data["getOrderByStatus"];
            if (getOrderByStatus$raw != null){
                
                    EnumWithDefaultValue_getOrderByStatus.updateCachePrivate(
                        getOrderByStatus$raw as JsonObject,
                        ctx,
                        this$fieldName: getOrderByStatusNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getOrderByStatus") && getOrderByStatus$cached != null){
                    this$NormalizedRecord[getOrderByStatusNormalized$Key] = null;
                    
                }
            }

        
    }

    static EnumWithDefaultValue fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getOrderByStatus$raw = data["getOrderByStatus"];
            final EnumWithDefaultValue_getOrderByStatus? getOrderByStatus$value = 
    
        
            getOrderByStatus$raw == null ? null :
        
    
;
        return EnumWithDefaultValue(
            getOrderByStatus: getOrderByStatus$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumWithDefaultValue &&
    
        
    
        other.getOrderByStatus == getOrderByStatus
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getOrderByStatus.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getOrderByStatus':
            
                
    
        
            this.getOrderByStatus?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class EnumWithDefaultValue_getOrderByStatus  {
        
    
    /// class members
    
        final Status? status;
    
        final int quantity;
    
        final String name;
    
        final double price;
    
    // keywordargs constructor
    EnumWithDefaultValue_getOrderByStatus({
    
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

    static EnumWithDefaultValue_getOrderByStatus fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return EnumWithDefaultValue_getOrderByStatus(
            status: status$value,
            quantity: quantity$value,
            name: name$value,
            price: price$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is EnumWithDefaultValue_getOrderByStatus &&
    
        
    
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


class RequestEnumWithDefaultValue extends Requestable {
    
    final EnumWithDefaultValueVariables variables;
    

    RequestEnumWithDefaultValue(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query EnumWithDefaultValue($status: Status = SENT) {
  getOrderByStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'EnumWithDefaultValue'
        );
    }
}


class EnumWithDefaultValueVariables {
    
    
        final Status? status;
    

    EnumWithDefaultValueVariables (
        
            {
            

    
        
            
            
                this.status = Status.SENT
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["status"] = 
    
        
            this.status?.name
        
    
;
    


        return data;
    }

    
EnumWithDefaultValueVariables updateWith(
    {
        
            
                Option<Status?> status = const None()
            
            
        
    }
) {
    
        final Status? status$next;
        
            switch (status) {

                case Some(value: final updateData):
                    status$next = updateData;
                case None():
                    status$next = this.status;
            }

        
    
    return EnumWithDefaultValueVariables(
        
            status: status$next
            
        
    );
}


}
