






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetBooleanOptionalResponse{

     
    /// class members
    
        final bool? booleanOptional;
    
    // keywordargs constructor
    GetBooleanOptionalResponse({
    
        this.booleanOptional,
    
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
            final booleanOptionalNormalized$Key = "booleanOptional";
            final booleanOptional$cached = this$NormalizedRecord[booleanOptionalNormalized$Key];
            final booleanOptional$raw = data["booleanOptional"];
            if (booleanOptional$raw != null){
                
                    if (booleanOptional$cached != booleanOptional$raw){
                    ctx.addChangedRecord(this$normalizedID, booleanOptionalNormalized$Key);
                    }
                    this$NormalizedRecord[booleanOptionalNormalized$Key] = booleanOptional$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("booleanOptional") && booleanOptional$cached != null){
                    this$NormalizedRecord[booleanOptionalNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, booleanOptionalNormalized$Key);
                }
            }

        
    }
    
    static GetBooleanOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final booleanOptional$raw = data["booleanOptional"];
            final bool? booleanOptional$value = 
    
        
            
                booleanOptional$raw as bool?
            
        
    
; 
        return GetBooleanOptionalResponse(
            booleanOptional: booleanOptional$value,
            
        );
    }
    static GetBooleanOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "booleanOptional",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "booleanOptional")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanOptionalResponse &&
    
        
    
        other.booleanOptional == booleanOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        booleanOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'booleanOptional':
            
                
    
        
            this.booleanOptional
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetBooleanOptional  {
        
     
    /// class members
    
        final bool? booleanOptional;
    
    // keywordargs constructor
    GetBooleanOptional({
    
        this.booleanOptional,
    
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
            final booleanOptionalNormalized$Key = "booleanOptional";
            final booleanOptional$cached = this$NormalizedRecord[booleanOptionalNormalized$Key];
            final booleanOptional$raw = data["booleanOptional"];
            if (booleanOptional$raw != null){
                
                    if (booleanOptional$cached != booleanOptional$raw){
                    ctx.addChangedRecord(this$normalizedID, booleanOptionalNormalized$Key);
                    }
                    this$NormalizedRecord[booleanOptionalNormalized$Key] = booleanOptional$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("booleanOptional") && booleanOptional$cached != null){
                    this$NormalizedRecord[booleanOptionalNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, booleanOptionalNormalized$Key);
                }
            }

        
    }
    
    static GetBooleanOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final booleanOptional$raw = data["booleanOptional"];
            final bool? booleanOptional$value = 
    
        
            
                booleanOptional$raw as bool?
            
        
    
; 
        return GetBooleanOptional(
            booleanOptional: booleanOptional$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanOptional &&
    
        
    
        other.booleanOptional == booleanOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        booleanOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'booleanOptional':
            
                
    
        
            this.booleanOptional
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetBooleanOptional extends Requestable {
    

    RequestGetBooleanOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetBooleanOptional {
  booleanOptional
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetBooleanOptional'
        );
    }
}

