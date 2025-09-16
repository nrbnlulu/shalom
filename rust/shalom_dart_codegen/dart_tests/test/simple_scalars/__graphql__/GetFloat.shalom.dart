






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetFloatResponse{

     
    /// class members
    
        final double float;
    
    // keywordargs constructor
    GetFloatResponse({
    required
        this.float,
    
    });
    
    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        
            final this$normalizedID = this$fieldName;
        final JsonObject this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
                
        // TODO: handle arguments
            final floatNormalized$Key = "float";
            final float$cached = this$NormalizedRecord[floatNormalized$Key];
            final float$raw = data["float"];
            if (float$raw != null){
                
                    if (float$cached != float$raw){
                    ctx.addChangedRecord(this$normalizedID, floatNormalized$Key);
                    }
                    this$NormalizedRecord[floatNormalized$Key] = float$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("float") && float$cached != null){
                    this$NormalizedRecord[floatNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, floatNormalized$Key);
                }
            }

        
    }
    
    static GetFloatResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final float$raw = data["float"];
            final double float$value = 
    
        
            
                float$raw as double
            
        
    
; 
        return GetFloatResponse(
            float: float$value,
            
        );
    }
    static GetFloatResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "float",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "float")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetFloatResponse &&
    
        
    
        other.float == float
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        float.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'float':
            
                
    
        
            this.float
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetFloat  {
        
     
    /// class members
    
        final double float;
    
    // keywordargs constructor
    GetFloat({
    required
        this.float,
    
    });
    
    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        
            final this$normalizedID = this$fieldName;
        final JsonObject this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
                
        // TODO: handle arguments
            final floatNormalized$Key = "float";
            final float$cached = this$NormalizedRecord[floatNormalized$Key];
            final float$raw = data["float"];
            if (float$raw != null){
                
                    if (float$cached != float$raw){
                    ctx.addChangedRecord(this$normalizedID, floatNormalized$Key);
                    }
                    this$NormalizedRecord[floatNormalized$Key] = float$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("float") && float$cached != null){
                    this$NormalizedRecord[floatNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, floatNormalized$Key);
                }
            }

        
    }
    
    static GetFloat fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final float$raw = data["float"];
            final double float$value = 
    
        
            
                float$raw as double
            
        
    
; 
        return GetFloat(
            float: float$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetFloat &&
    
        
    
        other.float == float
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        float.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'float':
            
                
    
        
            this.float
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetFloat extends Requestable {
    

    RequestGetFloat(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetFloat {
  float
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetFloat'
        );
    }
}

