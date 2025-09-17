






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListEnumInsideInputObjectResponse{

    
    /// class members
    
        final String? InputListEnumInsideInputObject;
    
    // keywordargs constructor
    InputListEnumInsideInputObjectResponse({
    
        this.InputListEnumInsideInputObject,
    
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
        final RecordID? this$normalizedID_temp = data["InputListEnumInsideInputObject"] as RecordID?;
            if (this$normalizedID_temp == null) {
                
                    this$normalizedID = this$fieldName;
                    this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
                
            } else {
                this$normalizedID = this$normalizedID_temp as String;
                this$data[this$fieldName] = this$normalizedID;
                ctx.addDependantRecord(this$normalizedID);
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                }
        // TODO: handle arguments
            final InputListEnumInsideInputObjectNormalized$Key = "InputListEnumInsideInputObject";
            final InputListEnumInsideInputObject$cached = this$NormalizedRecord[InputListEnumInsideInputObjectNormalized$Key];
            final InputListEnumInsideInputObject$raw = data["InputListEnumInsideInputObject"];
            if (InputListEnumInsideInputObject$raw != null){
                
                    if (InputListEnumInsideInputObject$cached != InputListEnumInsideInputObject$raw){
                        
                            ctx.addChangedRecord(this$normalizedID, InputListEnumInsideInputObjectNormalized$Key);
                        
                    }
                    this$NormalizedRecord[InputListEnumInsideInputObjectNormalized$Key] = InputListEnumInsideInputObject$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumInsideInputObject") && InputListEnumInsideInputObject$cached != null){
                    this$NormalizedRecord[InputListEnumInsideInputObjectNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, InputListEnumInsideInputObjectNormalized$Key);
                    
                }
            }

        
    }

    static InputListEnumInsideInputObjectResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumInsideInputObject$raw = data["InputListEnumInsideInputObject"];
            final String? InputListEnumInsideInputObject$value = 
    
        
            
                InputListEnumInsideInputObject$raw as String?
            
        
    
;
        return InputListEnumInsideInputObjectResponse(
            InputListEnumInsideInputObject: InputListEnumInsideInputObject$value,
            
        );
    }
    static InputListEnumInsideInputObjectResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListEnumInsideInputObject",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputListEnumInsideInputObject")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumInsideInputObjectResponse &&
    
        
    
        other.InputListEnumInsideInputObject == InputListEnumInsideInputObject
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumInsideInputObject.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumInsideInputObject':
            
                
    
        
            this.InputListEnumInsideInputObject
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListEnumInsideInputObject  {
        
    
    /// class members
    
        final String? InputListEnumInsideInputObject;
    
    // keywordargs constructor
    InputListEnumInsideInputObject({
    
        this.InputListEnumInsideInputObject,
    
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
        final RecordID? this$normalizedID_temp = data["InputListEnumInsideInputObject"] as RecordID?;
            if (this$normalizedID_temp == null) {
                
                    this$normalizedID = this$fieldName;
                    this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
                
            } else {
                this$normalizedID = this$normalizedID_temp as String;
                this$data[this$fieldName] = this$normalizedID;
                ctx.addDependantRecord(this$normalizedID);
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                }
        // TODO: handle arguments
            final InputListEnumInsideInputObjectNormalized$Key = "InputListEnumInsideInputObject";
            final InputListEnumInsideInputObject$cached = this$NormalizedRecord[InputListEnumInsideInputObjectNormalized$Key];
            final InputListEnumInsideInputObject$raw = data["InputListEnumInsideInputObject"];
            if (InputListEnumInsideInputObject$raw != null){
                
                    if (InputListEnumInsideInputObject$cached != InputListEnumInsideInputObject$raw){
                        
                            ctx.addChangedRecord(this$normalizedID, InputListEnumInsideInputObjectNormalized$Key);
                        
                    }
                    this$NormalizedRecord[InputListEnumInsideInputObjectNormalized$Key] = InputListEnumInsideInputObject$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumInsideInputObject") && InputListEnumInsideInputObject$cached != null){
                    this$NormalizedRecord[InputListEnumInsideInputObjectNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, InputListEnumInsideInputObjectNormalized$Key);
                    
                }
            }

        
    }

    static InputListEnumInsideInputObject fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumInsideInputObject$raw = data["InputListEnumInsideInputObject"];
            final String? InputListEnumInsideInputObject$value = 
    
        
            
                InputListEnumInsideInputObject$raw as String?
            
        
    
;
        return InputListEnumInsideInputObject(
            InputListEnumInsideInputObject: InputListEnumInsideInputObject$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumInsideInputObject &&
    
        
    
        other.InputListEnumInsideInputObject == InputListEnumInsideInputObject
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumInsideInputObject.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumInsideInputObject':
            
                
    
        
            this.InputListEnumInsideInputObject
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputListEnumInsideInputObject extends Requestable {
    
    final InputListEnumInsideInputObjectVariables variables;
    

    RequestInputListEnumInsideInputObject(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListEnumInsideInputObject($input: ObjectWithListOfInput!) {
  InputListEnumInsideInputObject(input: $input)
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListEnumInsideInputObject'
        );
    }
}


class InputListEnumInsideInputObjectVariables {
    
    
        final ObjectWithListOfInput input;
    

    InputListEnumInsideInputObjectVariables (
        
            {
            

    
        
            required this.input
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["input"] = 
    
        
            this.input.toJson()
        
    
;
    


        return data;
    }

    
InputListEnumInsideInputObjectVariables updateWith(
    {
        
            
                ObjectWithListOfInput? input
            
            
        
    }
) {
    
        final ObjectWithListOfInput input$next;
        
            if (input != null) {
                input$next = input;
            } else {
                input$next = this.input;
            }
        
    
    return InputListEnumInsideInputObjectVariables(
        
            input: input$next
            
        
    );
}


}
