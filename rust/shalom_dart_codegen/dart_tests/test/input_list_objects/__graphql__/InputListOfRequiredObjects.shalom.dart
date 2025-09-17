






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListOfRequiredObjectsResponse{

    
    /// class members
    
        final InputListOfRequiredObjects_InputListOfRequiredObjects? InputListOfRequiredObjects;
    
    // keywordargs constructor
    InputListOfRequiredObjectsResponse({
    
        this.InputListOfRequiredObjects,
    
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
            final InputListOfRequiredObjectsNormalized$Key = "InputListOfRequiredObjects";
            final InputListOfRequiredObjects$cached = this$NormalizedRecord[InputListOfRequiredObjectsNormalized$Key];
            final InputListOfRequiredObjects$raw = data["InputListOfRequiredObjects"];
            if (InputListOfRequiredObjects$raw != null){
                
                    InputListOfRequiredObjects_InputListOfRequiredObjects.updateCachePrivate(
                        InputListOfRequiredObjects$raw as JsonObject,
                        ctx,
                        this$fieldName: InputListOfRequiredObjectsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListOfRequiredObjects") && InputListOfRequiredObjects$cached != null){
                    this$NormalizedRecord[InputListOfRequiredObjectsNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListOfRequiredObjectsResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListOfRequiredObjects$raw = data["InputListOfRequiredObjects"];
            final InputListOfRequiredObjects_InputListOfRequiredObjects? InputListOfRequiredObjects$value = 
    
        
            InputListOfRequiredObjects$raw == null ? null :
        
    
;
        return InputListOfRequiredObjectsResponse(
            InputListOfRequiredObjects: InputListOfRequiredObjects$value,
            
        );
    }
    static InputListOfRequiredObjectsResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListOfRequiredObjects",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputListOfRequiredObjects")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfRequiredObjectsResponse &&
    
        
    
        other.InputListOfRequiredObjects == InputListOfRequiredObjects
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListOfRequiredObjects.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListOfRequiredObjects':
            
                
    
        
            this.InputListOfRequiredObjects?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListOfRequiredObjects  {
        
    
    /// class members
    
        final InputListOfRequiredObjects_InputListOfRequiredObjects? InputListOfRequiredObjects;
    
    // keywordargs constructor
    InputListOfRequiredObjects({
    
        this.InputListOfRequiredObjects,
    
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
            final InputListOfRequiredObjectsNormalized$Key = "InputListOfRequiredObjects";
            final InputListOfRequiredObjects$cached = this$NormalizedRecord[InputListOfRequiredObjectsNormalized$Key];
            final InputListOfRequiredObjects$raw = data["InputListOfRequiredObjects"];
            if (InputListOfRequiredObjects$raw != null){
                
                    InputListOfRequiredObjects_InputListOfRequiredObjects.updateCachePrivate(
                        InputListOfRequiredObjects$raw as JsonObject,
                        ctx,
                        this$fieldName: InputListOfRequiredObjectsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListOfRequiredObjects") && InputListOfRequiredObjects$cached != null){
                    this$NormalizedRecord[InputListOfRequiredObjectsNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListOfRequiredObjects fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListOfRequiredObjects$raw = data["InputListOfRequiredObjects"];
            final InputListOfRequiredObjects_InputListOfRequiredObjects? InputListOfRequiredObjects$value = 
    
        
            InputListOfRequiredObjects$raw == null ? null :
        
    
;
        return InputListOfRequiredObjects(
            InputListOfRequiredObjects: InputListOfRequiredObjects$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfRequiredObjects &&
    
        
    
        other.InputListOfRequiredObjects == InputListOfRequiredObjects
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListOfRequiredObjects.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListOfRequiredObjects':
            
                
    
        
            this.InputListOfRequiredObjects?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputListOfRequiredObjects_InputListOfRequiredObjects  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputListOfRequiredObjects_InputListOfRequiredObjects({
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

    static InputListOfRequiredObjects_InputListOfRequiredObjects fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputListOfRequiredObjects_InputListOfRequiredObjects(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfRequiredObjects_InputListOfRequiredObjects &&
    
        
    
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


class RequestInputListOfRequiredObjects extends Requestable {
    
    final InputListOfRequiredObjectsVariables variables;
    

    RequestInputListOfRequiredObjects(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListOfRequiredObjects($items: [MyInputObject!]!) {
  InputListOfRequiredObjects(items: $items) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListOfRequiredObjects'
        );
    }
}


class InputListOfRequiredObjectsVariables {
    
    
        final List<MyInputObject> items;
    

    InputListOfRequiredObjectsVariables (
        
            {
            

    
        
            required this.items
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["items"] = 
    
        
        
            this.items.map((e) => 
    
        
            e.toJson()
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputListOfRequiredObjectsVariables updateWith(
    {
        
            
                List<MyInputObject>? items
            
            
        
    }
) {
    
        final List<MyInputObject> items$next;
        
            if (items != null) {
                items$next = items;
            } else {
                items$next = this.items;
            }
        
    
    return InputListOfRequiredObjectsVariables(
        
            items: items$next
            
        
    );
}


}
