






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetStringOptionalResponse{

    
    /// class members
    
        final String? stringOptional;
    
    // keywordargs constructor
    GetStringOptionalResponse({
    
        this.stringOptional,
    
    });

    static void normalize$inCache(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject parent$record
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
        // TODO: handle arguments
            final stringOptionalNormalized$Key = "stringOptional";
            final stringOptional$cached = this$NormalizedRecord[stringOptionalNormalized$Key];
            final stringOptional$raw = data["stringOptional"];
            if (stringOptional$raw != null){
                
                    if (stringOptional$cached != stringOptional$raw){
                        
                    }
                    this$NormalizedRecord[stringOptionalNormalized$Key] = stringOptional$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("stringOptional") && stringOptional$cached != null){
                    this$NormalizedRecord[stringOptionalNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetStringOptionalResponse fromJsonImpl(NormalizedRecordData data, ShalomCtx ctx) {
        
            final stringOptional$raw = data["stringOptional"];
            final String? stringOptional$value = 
    
        
            
                stringOptional$raw as String?
            
        
    
;
        return GetStringOptionalResponse(
            stringOptional: stringOptional$value,
            
        );
    }
    static GetStringOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            final normalizedRecord = getOrCreateObject(
                updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"),
                "stringOptional"
            );
            normalize$inCache(
                data,
                updateCtx,
                this$fieldName: "stringOptional",
                parent$record: normalizedRecord,
               
                );
            return fromJsonImpl(normalizedRecord, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetStringOptionalResponse &&
    
        
    
        other.stringOptional == stringOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        stringOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'stringOptional':
            
                
    
        
            this.stringOptional
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetStringOptional  {
        
    
    /// class members
    
        final String? stringOptional;
    
    // keywordargs constructor
    GetStringOptional({
    
        this.stringOptional,
    
    });

    static void normalize$inCache(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject parent$record
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
        // TODO: handle arguments
            final stringOptionalNormalized$Key = "stringOptional";
            final stringOptional$cached = this$NormalizedRecord[stringOptionalNormalized$Key];
            final stringOptional$raw = data["stringOptional"];
            if (stringOptional$raw != null){
                
                    if (stringOptional$cached != stringOptional$raw){
                        
                    }
                    this$NormalizedRecord[stringOptionalNormalized$Key] = stringOptional$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("stringOptional") && stringOptional$cached != null){
                    this$NormalizedRecord[stringOptionalNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetStringOptional fromJsonImpl(NormalizedRecordData data, ShalomCtx ctx) {
        
            final stringOptional$raw = data["stringOptional"];
            final String? stringOptional$value = 
    
        
            
                stringOptional$raw as String?
            
        
    
;
        return GetStringOptional(
            stringOptional: stringOptional$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetStringOptional &&
    
        
    
        other.stringOptional == stringOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        stringOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'stringOptional':
            
                
    
        
            this.stringOptional
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetStringOptional extends Requestable {
    

    RequestGetStringOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetStringOptional {
  stringOptional
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetStringOptional'
        );
    }
}

