






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetIntOptionalResponse{

     
    /// class members
    
        final int? intOptional;
    
    // keywordargs constructor
    GetIntOptionalResponse({
    
        this.intOptional,
    
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
            final intOptionalNormalized$Key = "intOptional";
            final intOptional$cached = this$NormalizedRecord[intOptionalNormalized$Key];
            final intOptional$raw = data["intOptional"];
            if (intOptional$raw != null){
                
                    if (intOptional$cached != intOptional$raw){
                    ctx.addChangedRecord(this$normalizedID, intOptionalNormalized$Key);
                    }
                    this$NormalizedRecord[intOptionalNormalized$Key] = intOptional$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("intOptional") && intOptional$cached != null){
                    this$NormalizedRecord[intOptionalNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, intOptionalNormalized$Key);
                }
            }

        
    }
    
    static GetIntOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final intOptional$raw = data["intOptional"];
            final int? intOptional$value = 
    
        
            
                intOptional$raw as int?
            
        
    
; 
        return GetIntOptionalResponse(
            intOptional: intOptional$value,
            
        );
    }
    static GetIntOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "intOptional",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "intOptional")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIntOptionalResponse &&
    
        
    
        other.intOptional == intOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        intOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intOptional':
            
                
    
        
            this.intOptional
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetIntOptional  {
        
     
    /// class members
    
        final int? intOptional;
    
    // keywordargs constructor
    GetIntOptional({
    
        this.intOptional,
    
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
            final intOptionalNormalized$Key = "intOptional";
            final intOptional$cached = this$NormalizedRecord[intOptionalNormalized$Key];
            final intOptional$raw = data["intOptional"];
            if (intOptional$raw != null){
                
                    if (intOptional$cached != intOptional$raw){
                    ctx.addChangedRecord(this$normalizedID, intOptionalNormalized$Key);
                    }
                    this$NormalizedRecord[intOptionalNormalized$Key] = intOptional$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("intOptional") && intOptional$cached != null){
                    this$NormalizedRecord[intOptionalNormalized$Key] = null;
                    ctx.addChangedRecord(this$normalizedID, intOptionalNormalized$Key);
                }
            }

        
    }
    
    static GetIntOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final intOptional$raw = data["intOptional"];
            final int? intOptional$value = 
    
        
            
                intOptional$raw as int?
            
        
    
; 
        return GetIntOptional(
            intOptional: intOptional$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIntOptional &&
    
        
    
        other.intOptional == intOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        intOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intOptional':
            
                
    
        
            this.intOptional
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetIntOptional extends Requestable {
    

    RequestGetIntOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetIntOptional {
  intOptional
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetIntOptional'
        );
    }
}

