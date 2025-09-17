






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputScalarListRequiredResponse{

    
    /// class members
    
        final InputScalarListRequired_InputScalarListRequired? InputScalarListRequired;
    
    // keywordargs constructor
    InputScalarListRequiredResponse({
    
        this.InputScalarListRequired,
    
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
            final InputScalarListRequiredNormalized$Key = "InputScalarListRequired";
            final InputScalarListRequired$cached = this$NormalizedRecord[InputScalarListRequiredNormalized$Key];
            final InputScalarListRequired$raw = data["InputScalarListRequired"];
            if (InputScalarListRequired$raw != null){
                
                    InputScalarListRequired_InputScalarListRequired.updateCachePrivate(
                        InputScalarListRequired$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarListRequiredNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarListRequired") && InputScalarListRequired$cached != null){
                    this$NormalizedRecord[InputScalarListRequiredNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListRequiredResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarListRequired$raw = data["InputScalarListRequired"];
            final InputScalarListRequired_InputScalarListRequired? InputScalarListRequired$value = 
    
        
            InputScalarListRequired$raw == null ? null :
        
    
;
        return InputScalarListRequiredResponse(
            InputScalarListRequired: InputScalarListRequired$value,
            
        );
    }
    static InputScalarListRequiredResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputScalarListRequired",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputScalarListRequired")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListRequiredResponse &&
    
        
    
        other.InputScalarListRequired == InputScalarListRequired
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListRequired.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListRequired':
            
                
    
        
            this.InputScalarListRequired?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputScalarListRequired  {
        
    
    /// class members
    
        final InputScalarListRequired_InputScalarListRequired? InputScalarListRequired;
    
    // keywordargs constructor
    InputScalarListRequired({
    
        this.InputScalarListRequired,
    
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
            final InputScalarListRequiredNormalized$Key = "InputScalarListRequired";
            final InputScalarListRequired$cached = this$NormalizedRecord[InputScalarListRequiredNormalized$Key];
            final InputScalarListRequired$raw = data["InputScalarListRequired"];
            if (InputScalarListRequired$raw != null){
                
                    InputScalarListRequired_InputScalarListRequired.updateCachePrivate(
                        InputScalarListRequired$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarListRequiredNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarListRequired") && InputScalarListRequired$cached != null){
                    this$NormalizedRecord[InputScalarListRequiredNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListRequired fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarListRequired$raw = data["InputScalarListRequired"];
            final InputScalarListRequired_InputScalarListRequired? InputScalarListRequired$value = 
    
        
            InputScalarListRequired$raw == null ? null :
        
    
;
        return InputScalarListRequired(
            InputScalarListRequired: InputScalarListRequired$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListRequired &&
    
        
    
        other.InputScalarListRequired == InputScalarListRequired
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListRequired.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListRequired':
            
                
    
        
            this.InputScalarListRequired?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputScalarListRequired_InputScalarListRequired  {
        
    
    /// class members
    
        final bool success;
    
    // keywordargs constructor
    InputScalarListRequired_InputScalarListRequired({
    required
        this.success,
    
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
            final successNormalized$Key = "success";
            final success$cached = this$NormalizedRecord[successNormalized$Key];
            final success$raw = data["success"];
            if (success$raw != null){
                
                    if (success$cached != success$raw){
                        
                    }
                    this$NormalizedRecord[successNormalized$Key] = success$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("success") && success$cached != null){
                    this$NormalizedRecord[successNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListRequired_InputScalarListRequired fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        return InputScalarListRequired_InputScalarListRequired(
            success: success$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListRequired_InputScalarListRequired &&
    
        
    
        other.success == success
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        success.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'success':
            
                
    
        
            this.success
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputScalarListRequired extends Requestable {
    
    final InputScalarListRequiredVariables variables;
    

    RequestInputScalarListRequired(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputScalarListRequired($strings: [String!]!) {
  InputScalarListRequired(strings: $strings) {
    success
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputScalarListRequired'
        );
    }
}


class InputScalarListRequiredVariables {
    
    
        final List<String> strings;
    

    InputScalarListRequiredVariables (
        
            {
            

    
        
            required this.strings
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["strings"] = 
    
        
        
            this.strings.map((e) => 
    
        e
    
).toList()
        
    
;
    


        return data;
    }

    
InputScalarListRequiredVariables updateWith(
    {
        
            
                List<String>? strings
            
            
        
    }
) {
    
        final List<String> strings$next;
        
            if (strings != null) {
                strings$next = strings;
            } else {
                strings$next = this.strings;
            }
        
    
    return InputScalarListRequiredVariables(
        
            strings: strings$next
            
        
    );
}


}
