






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetIDResponse{

     
    /// class members
    
        final String id;
    
    // keywordargs constructor
    GetIDResponse({
    required
        this.id,
    
    });
    
    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        final this$normalizedID = data["id"] as RecordID?;
        if (this$normalizedID == null) {
                throw UnimplementedError("current we don't support nullable ids");
            }
            this$data[this$fieldName] = this$normalizedID;
            ctx.addDependantRecord(this$normalizedID);
            final JsonObject this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
                
        // TODO: handle arguments
            final idNormalized$Key = "id";
            final id$cached = this$NormalizedRecord[idNormalized$Key];
            final id$raw = data["id"];
            if (id$raw != null){
                
                    if (id$cached != id$raw){
                    ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
                    }
                    this$NormalizedRecord[idNormalized$Key] = id$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("id") && id$cached != null){
                    this$NormalizedRecord[idNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
                }
            }

        
    }
    
    static GetIDResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final id$raw = data["id"];
            final String id$value = 
    
        
            
                id$raw as String
            
        
    
; 
        return GetIDResponse(
            id: id$value,
            
        );
    }
    static GetIDResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "id",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "id")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIDResponse &&
    
        
    
        other.id == id
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        id.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetID  {
        
     
    /// class members
    
        final String id;
    
    // keywordargs constructor
    GetID({
    required
        this.id,
    
    });
    
    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        final this$normalizedID = data["id"] as RecordID?;
        if (this$normalizedID == null) {
                throw UnimplementedError("current we don't support nullable ids");
            }
            this$data[this$fieldName] = this$normalizedID;
            ctx.addDependantRecord(this$normalizedID);
            final JsonObject this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
                
        // TODO: handle arguments
            final idNormalized$Key = "id";
            final id$cached = this$NormalizedRecord[idNormalized$Key];
            final id$raw = data["id"];
            if (id$raw != null){
                
                    if (id$cached != id$raw){
                    ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
                    }
                    this$NormalizedRecord[idNormalized$Key] = id$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("id") && id$cached != null){
                    this$NormalizedRecord[idNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
                }
            }

        
    }
    
    static GetID fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final id$raw = data["id"];
            final String id$value = 
    
        
            
                id$raw as String
            
        
    
; 
        return GetID(
            id: id$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetID &&
    
        
    
        other.id == id
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        id.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetID extends Requestable {
    

    RequestGetID(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetID {
  id
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetID'
        );
    }
}

