






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputObjectContainingListOfObjectsResponse{

    
    /// class members
    
        final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects? InputObjectContainingListOfObjects;
    
    // keywordargs constructor
    InputObjectContainingListOfObjectsResponse({
    
        this.InputObjectContainingListOfObjects,
    
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
            final InputObjectContainingListOfObjectsNormalized$Key = "InputObjectContainingListOfObjects";
            final InputObjectContainingListOfObjects$cached = this$NormalizedRecord[InputObjectContainingListOfObjectsNormalized$Key];
            final InputObjectContainingListOfObjects$raw = data["InputObjectContainingListOfObjects"];
            if (InputObjectContainingListOfObjects$raw != null){
                
                    InputObjectContainingListOfObjects_InputObjectContainingListOfObjects.updateCachePrivate(
                        InputObjectContainingListOfObjects$raw as JsonObject,
                        ctx,
                        this$fieldName: InputObjectContainingListOfObjectsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputObjectContainingListOfObjects") && InputObjectContainingListOfObjects$cached != null){
                    this$NormalizedRecord[InputObjectContainingListOfObjectsNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputObjectContainingListOfObjectsResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputObjectContainingListOfObjects$raw = data["InputObjectContainingListOfObjects"];
            final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects? InputObjectContainingListOfObjects$value = 
    
        
            InputObjectContainingListOfObjects$raw == null ? null :
        
    
;
        return InputObjectContainingListOfObjectsResponse(
            InputObjectContainingListOfObjects: InputObjectContainingListOfObjects$value,
            
        );
    }
    static InputObjectContainingListOfObjectsResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputObjectContainingListOfObjects",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputObjectContainingListOfObjects")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputObjectContainingListOfObjectsResponse &&
    
        
    
        other.InputObjectContainingListOfObjects == InputObjectContainingListOfObjects
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputObjectContainingListOfObjects.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputObjectContainingListOfObjects':
            
                
    
        
            this.InputObjectContainingListOfObjects?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputObjectContainingListOfObjects  {
        
    
    /// class members
    
        final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects? InputObjectContainingListOfObjects;
    
    // keywordargs constructor
    InputObjectContainingListOfObjects({
    
        this.InputObjectContainingListOfObjects,
    
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
            final InputObjectContainingListOfObjectsNormalized$Key = "InputObjectContainingListOfObjects";
            final InputObjectContainingListOfObjects$cached = this$NormalizedRecord[InputObjectContainingListOfObjectsNormalized$Key];
            final InputObjectContainingListOfObjects$raw = data["InputObjectContainingListOfObjects"];
            if (InputObjectContainingListOfObjects$raw != null){
                
                    InputObjectContainingListOfObjects_InputObjectContainingListOfObjects.updateCachePrivate(
                        InputObjectContainingListOfObjects$raw as JsonObject,
                        ctx,
                        this$fieldName: InputObjectContainingListOfObjectsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputObjectContainingListOfObjects") && InputObjectContainingListOfObjects$cached != null){
                    this$NormalizedRecord[InputObjectContainingListOfObjectsNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputObjectContainingListOfObjects fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputObjectContainingListOfObjects$raw = data["InputObjectContainingListOfObjects"];
            final InputObjectContainingListOfObjects_InputObjectContainingListOfObjects? InputObjectContainingListOfObjects$value = 
    
        
            InputObjectContainingListOfObjects$raw == null ? null :
        
    
;
        return InputObjectContainingListOfObjects(
            InputObjectContainingListOfObjects: InputObjectContainingListOfObjects$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputObjectContainingListOfObjects &&
    
        
    
        other.InputObjectContainingListOfObjects == InputObjectContainingListOfObjects
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputObjectContainingListOfObjects.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputObjectContainingListOfObjects':
            
                
    
        
            this.InputObjectContainingListOfObjects?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputObjectContainingListOfObjects_InputObjectContainingListOfObjects  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputObjectContainingListOfObjects_InputObjectContainingListOfObjects({
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

    static InputObjectContainingListOfObjects_InputObjectContainingListOfObjects fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputObjectContainingListOfObjects_InputObjectContainingListOfObjects(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputObjectContainingListOfObjects_InputObjectContainingListOfObjects &&
    
        
    
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


class RequestInputObjectContainingListOfObjects extends Requestable {
    
    final InputObjectContainingListOfObjectsVariables variables;
    

    RequestInputObjectContainingListOfObjects(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputObjectContainingListOfObjects($data: ContainerInput!) {
  InputObjectContainingListOfObjects(data: $data) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputObjectContainingListOfObjects'
        );
    }
}


class InputObjectContainingListOfObjectsVariables {
    
    
        final ContainerInput data;
    

    InputObjectContainingListOfObjectsVariables (
        
            {
            

    
        
            required this.data
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["data"] = 
    
        
            this.data.toJson()
        
    
;
    


        return data;
    }

    
InputObjectContainingListOfObjectsVariables updateWith(
    {
        
            
                ContainerInput? data
            
            
        
    }
) {
    
        final ContainerInput data$next;
        
            if (data != null) {
                data$next = data;
            } else {
                data$next = this.data;
            }
        
    
    return InputObjectContainingListOfObjectsVariables(
        
            data: data$next
            
        
    );
}


}
