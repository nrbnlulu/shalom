






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListEnumRequiredResponse{

    
    /// class members
    
        final String? InputListEnumRequired;
    
    // keywordargs constructor
    InputListEnumRequiredResponse({
    
        this.InputListEnumRequired,
    
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
            final InputListEnumRequiredNormalized$Key = "InputListEnumRequired";
            final InputListEnumRequired$cached = this$NormalizedRecord[InputListEnumRequiredNormalized$Key];
            final InputListEnumRequired$raw = data["InputListEnumRequired"];
            if (InputListEnumRequired$raw != null){
                
                    if (InputListEnumRequired$cached != InputListEnumRequired$raw){
                        
                    }
                    this$NormalizedRecord[InputListEnumRequiredNormalized$Key] = InputListEnumRequired$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumRequired") && InputListEnumRequired$cached != null){
                    this$NormalizedRecord[InputListEnumRequiredNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListEnumRequiredResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumRequired$raw = data["InputListEnumRequired"];
            final String? InputListEnumRequired$value = 
    
        
            
                InputListEnumRequired$raw as String?
            
        
    
;
        return InputListEnumRequiredResponse(
            InputListEnumRequired: InputListEnumRequired$value,
            
        );
    }
    static InputListEnumRequiredResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListEnumRequired",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputListEnumRequired")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumRequiredResponse &&
    
        
    
        other.InputListEnumRequired == InputListEnumRequired
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumRequired.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumRequired':
            
                
    
        
            this.InputListEnumRequired
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListEnumRequired  {
        
    
    /// class members
    
        final String? InputListEnumRequired;
    
    // keywordargs constructor
    InputListEnumRequired({
    
        this.InputListEnumRequired,
    
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
            final InputListEnumRequiredNormalized$Key = "InputListEnumRequired";
            final InputListEnumRequired$cached = this$NormalizedRecord[InputListEnumRequiredNormalized$Key];
            final InputListEnumRequired$raw = data["InputListEnumRequired"];
            if (InputListEnumRequired$raw != null){
                
                    if (InputListEnumRequired$cached != InputListEnumRequired$raw){
                        
                    }
                    this$NormalizedRecord[InputListEnumRequiredNormalized$Key] = InputListEnumRequired$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumRequired") && InputListEnumRequired$cached != null){
                    this$NormalizedRecord[InputListEnumRequiredNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListEnumRequired fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumRequired$raw = data["InputListEnumRequired"];
            final String? InputListEnumRequired$value = 
    
        
            
                InputListEnumRequired$raw as String?
            
        
    
;
        return InputListEnumRequired(
            InputListEnumRequired: InputListEnumRequired$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumRequired &&
    
        
    
        other.InputListEnumRequired == InputListEnumRequired
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumRequired.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumRequired':
            
                
    
        
            this.InputListEnumRequired
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputListEnumRequired extends Requestable {
    
    final InputListEnumRequiredVariables variables;
    

    RequestInputListEnumRequired(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListEnumRequired($foo: [Gender!]!) {
  InputListEnumRequired(foo: $foo)
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListEnumRequired'
        );
    }
}


class InputListEnumRequiredVariables {
    
    
        final List<Gender> foo;
    

    InputListEnumRequiredVariables (
        
            {
            

    
        
            required this.foo
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["foo"] = 
    
        
        
            this.foo.map((e) => 
    
        
            e.name
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputListEnumRequiredVariables updateWith(
    {
        
            
                List<Gender>? foo
            
            
        
    }
) {
    
        final List<Gender> foo$next;
        
            if (foo != null) {
                foo$next = foo;
            } else {
                foo$next = this.foo;
            }
        
    
    return InputListEnumRequiredVariables(
        
            foo: foo$next
            
        
    );
}


}
