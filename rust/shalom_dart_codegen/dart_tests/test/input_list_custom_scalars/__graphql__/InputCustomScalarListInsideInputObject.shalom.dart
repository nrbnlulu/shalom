






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListInsideInputObjectResponse{

    
    /// class members
    
        final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject? InputCustomScalarListInsideInputObject;
    
    // keywordargs constructor
    InputCustomScalarListInsideInputObjectResponse({
    
        this.InputCustomScalarListInsideInputObject,
    
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
        final RecordID? this$normalizedID_temp = data["InputCustomScalarListInsideInputObject"] as RecordID?;
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
            final InputCustomScalarListInsideInputObjectNormalized$Key = "InputCustomScalarListInsideInputObject";
            final InputCustomScalarListInsideInputObject$cached = this$NormalizedRecord[InputCustomScalarListInsideInputObjectNormalized$Key];
            final InputCustomScalarListInsideInputObject$raw = data["InputCustomScalarListInsideInputObject"];
            if (InputCustomScalarListInsideInputObject$raw != null){
                
                    InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject.updateCachePrivate(
                        InputCustomScalarListInsideInputObject$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListInsideInputObjectNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListInsideInputObject") && InputCustomScalarListInsideInputObject$cached != null){
                    this$NormalizedRecord[InputCustomScalarListInsideInputObjectNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, InputCustomScalarListInsideInputObjectNormalized$Key);
                    
                }
            }

        
    }

    static InputCustomScalarListInsideInputObjectResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListInsideInputObject$raw = data["InputCustomScalarListInsideInputObject"];
            final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject? InputCustomScalarListInsideInputObject$value = 
    
        
            InputCustomScalarListInsideInputObject$raw == null ? null :
        
    
;
        return InputCustomScalarListInsideInputObjectResponse(
            InputCustomScalarListInsideInputObject: InputCustomScalarListInsideInputObject$value,
            
        );
    }
    static InputCustomScalarListInsideInputObjectResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputCustomScalarListInsideInputObject",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputCustomScalarListInsideInputObject")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListInsideInputObjectResponse &&
    
        
    
        other.InputCustomScalarListInsideInputObject == InputCustomScalarListInsideInputObject
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListInsideInputObject.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListInsideInputObject':
            
                
    
        
            this.InputCustomScalarListInsideInputObject?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListInsideInputObject  {
        
    
    /// class members
    
        final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject? InputCustomScalarListInsideInputObject;
    
    // keywordargs constructor
    InputCustomScalarListInsideInputObject({
    
        this.InputCustomScalarListInsideInputObject,
    
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
        final RecordID? this$normalizedID_temp = data["InputCustomScalarListInsideInputObject"] as RecordID?;
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
            final InputCustomScalarListInsideInputObjectNormalized$Key = "InputCustomScalarListInsideInputObject";
            final InputCustomScalarListInsideInputObject$cached = this$NormalizedRecord[InputCustomScalarListInsideInputObjectNormalized$Key];
            final InputCustomScalarListInsideInputObject$raw = data["InputCustomScalarListInsideInputObject"];
            if (InputCustomScalarListInsideInputObject$raw != null){
                
                    InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject.updateCachePrivate(
                        InputCustomScalarListInsideInputObject$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListInsideInputObjectNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListInsideInputObject") && InputCustomScalarListInsideInputObject$cached != null){
                    this$NormalizedRecord[InputCustomScalarListInsideInputObjectNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, InputCustomScalarListInsideInputObjectNormalized$Key);
                    
                }
            }

        
    }

    static InputCustomScalarListInsideInputObject fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListInsideInputObject$raw = data["InputCustomScalarListInsideInputObject"];
            final InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject? InputCustomScalarListInsideInputObject$value = 
    
        
            InputCustomScalarListInsideInputObject$raw == null ? null :
        
    
;
        return InputCustomScalarListInsideInputObject(
            InputCustomScalarListInsideInputObject: InputCustomScalarListInsideInputObject$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListInsideInputObject &&
    
        
    
        other.InputCustomScalarListInsideInputObject == InputCustomScalarListInsideInputObject
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListInsideInputObject.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListInsideInputObject':
            
                
    
        
            this.InputCustomScalarListInsideInputObject?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject({
    required
        this.success,
    
        this.message,
    
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

        // TODO: handle arguments
            final messageNormalized$Key = "message";
            final message$cached = this$NormalizedRecord[messageNormalized$Key];
            final message$raw = data["message"];
            if (message$raw != null){
                
                    if (message$cached != message$raw){
                        
                    }
                    this$NormalizedRecord[messageNormalized$Key] = message$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("message") && message$cached != null){
                    this$NormalizedRecord[messageNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListInsideInputObject_InputCustomScalarListInsideInputObject &&
    
        
    
        other.success == success
    
 &&
    
        
    
        other.message == message
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            success,
        
            
            message,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'success':
            
                
    
        
            this.success
        
    

            
        ,
    
        
        'message':
            
                
    
        
            this.message
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputCustomScalarListInsideInputObject extends Requestable {
    
    final InputCustomScalarListInsideInputObjectVariables variables;
    

    RequestInputCustomScalarListInsideInputObject(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListInsideInputObject($newContainer: ItemContainerInput!) {
  InputCustomScalarListInsideInputObject(newContainer: $newContainer) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListInsideInputObject'
        );
    }
}


class InputCustomScalarListInsideInputObjectVariables {
    
    
        final ItemContainerInput newContainer;
    

    InputCustomScalarListInsideInputObjectVariables (
        
            {
            

    
        
            required this.newContainer
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["newContainer"] = 
    
        
            this.newContainer.toJson()
        
    
;
    


        return data;
    }

    
InputCustomScalarListInsideInputObjectVariables updateWith(
    {
        
            
                ItemContainerInput? newContainer
            
            
        
    }
) {
    
        final ItemContainerInput newContainer$next;
        
            if (newContainer != null) {
                newContainer$next = newContainer;
            } else {
                newContainer$next = this.newContainer;
            }
        
    
    return InputCustomScalarListInsideInputObjectVariables(
        
            newContainer: newContainer$next
            
        
    );
}


}
