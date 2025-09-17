






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetIntResponse{

    
    /// class members
    
        final int intField;
    
    // keywordargs constructor
    GetIntResponse({
    required
        this.intField,
    
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
            final intFieldNormalized$Key = "intField";
            final intField$cached = this$NormalizedRecord[intFieldNormalized$Key];
            final intField$raw = data["intField"];
            if (intField$raw != null){
                
                    if (intField$cached != intField$raw){
                        
                    }
                    this$NormalizedRecord[intFieldNormalized$Key] = intField$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("intField") && intField$cached != null){
                    this$NormalizedRecord[intFieldNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetIntResponse fromJsonImpl(NormalizedRecordData data, ShalomCtx ctx) {
        
            final intField$raw = data["intField"];
            final int intField$value = 
    
        
            
                intField$raw as int
            
        
    
;
        return GetIntResponse(
            intField: intField$value,
            
        );
    }
    static GetIntResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            final normalizedRecord = getOrCreateObject(
                updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"),
                "intField"
            );
            normalize$inCache(
                data,
                updateCtx,
                this$fieldName: "intField",
                parent$record: normalizedRecord,
               
                );
            return fromJsonImpl(normalizedRecord, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIntResponse &&
    
        
    
        other.intField == intField
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        intField.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intField':
            
                
    
        
            this.intField
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetInt  {
        
    
    /// class members
    
        final int intField;
    
    // keywordargs constructor
    GetInt({
    required
        this.intField,
    
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
            final intFieldNormalized$Key = "intField";
            final intField$cached = this$NormalizedRecord[intFieldNormalized$Key];
            final intField$raw = data["intField"];
            if (intField$raw != null){
                
                    if (intField$cached != intField$raw){
                        
                    }
                    this$NormalizedRecord[intFieldNormalized$Key] = intField$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("intField") && intField$cached != null){
                    this$NormalizedRecord[intFieldNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetInt fromJsonImpl(NormalizedRecordData data, ShalomCtx ctx) {
        
            final intField$raw = data["intField"];
            final int intField$value = 
    
        
            
                intField$raw as int
            
        
    
;
        return GetInt(
            intField: intField$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetInt &&
    
        
    
        other.intField == intField
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        intField.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intField':
            
                
    
        
            this.intField
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetInt extends Requestable {
    

    RequestGetInt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetInt {
  intField
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetInt'
        );
    }
}

