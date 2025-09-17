






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListObjectsMAybeResponse{

    
    /// class members
    
        final InputListObjectsMAybe_InputListObjectsMAybe? InputListObjectsMAybe;
    
    // keywordargs constructor
    InputListObjectsMAybeResponse({
    
        this.InputListObjectsMAybe,
    
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
            final InputListObjectsMAybeNormalized$Key = "InputListObjectsMAybe";
            final InputListObjectsMAybe$cached = this$NormalizedRecord[InputListObjectsMAybeNormalized$Key];
            final InputListObjectsMAybe$raw = data["InputListObjectsMAybe"];
            if (InputListObjectsMAybe$raw != null){
                
                    InputListObjectsMAybe_InputListObjectsMAybe.updateCachePrivate(
                        InputListObjectsMAybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputListObjectsMAybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListObjectsMAybe") && InputListObjectsMAybe$cached != null){
                    this$NormalizedRecord[InputListObjectsMAybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListObjectsMAybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListObjectsMAybe$raw = data["InputListObjectsMAybe"];
            final InputListObjectsMAybe_InputListObjectsMAybe? InputListObjectsMAybe$value = 
    
        
            InputListObjectsMAybe$raw == null ? null :
        
    
;
        return InputListObjectsMAybeResponse(
            InputListObjectsMAybe: InputListObjectsMAybe$value,
            
        );
    }
    static InputListObjectsMAybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListObjectsMAybe",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputListObjectsMAybe")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListObjectsMAybeResponse &&
    
        
    
        other.InputListObjectsMAybe == InputListObjectsMAybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListObjectsMAybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListObjectsMAybe':
            
                
    
        
            this.InputListObjectsMAybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListObjectsMAybe  {
        
    
    /// class members
    
        final InputListObjectsMAybe_InputListObjectsMAybe? InputListObjectsMAybe;
    
    // keywordargs constructor
    InputListObjectsMAybe({
    
        this.InputListObjectsMAybe,
    
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
            final InputListObjectsMAybeNormalized$Key = "InputListObjectsMAybe";
            final InputListObjectsMAybe$cached = this$NormalizedRecord[InputListObjectsMAybeNormalized$Key];
            final InputListObjectsMAybe$raw = data["InputListObjectsMAybe"];
            if (InputListObjectsMAybe$raw != null){
                
                    InputListObjectsMAybe_InputListObjectsMAybe.updateCachePrivate(
                        InputListObjectsMAybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputListObjectsMAybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListObjectsMAybe") && InputListObjectsMAybe$cached != null){
                    this$NormalizedRecord[InputListObjectsMAybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListObjectsMAybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListObjectsMAybe$raw = data["InputListObjectsMAybe"];
            final InputListObjectsMAybe_InputListObjectsMAybe? InputListObjectsMAybe$value = 
    
        
            InputListObjectsMAybe$raw == null ? null :
        
    
;
        return InputListObjectsMAybe(
            InputListObjectsMAybe: InputListObjectsMAybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListObjectsMAybe &&
    
        
    
        other.InputListObjectsMAybe == InputListObjectsMAybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListObjectsMAybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListObjectsMAybe':
            
                
    
        
            this.InputListObjectsMAybe?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputListObjectsMAybe_InputListObjectsMAybe  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputListObjectsMAybe_InputListObjectsMAybe({
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

    static InputListObjectsMAybe_InputListObjectsMAybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputListObjectsMAybe_InputListObjectsMAybe(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListObjectsMAybe_InputListObjectsMAybe &&
    
        
    
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


class RequestInputListObjectsMAybe extends Requestable {
    
    final InputListObjectsMAybeVariables variables;
    

    RequestInputListObjectsMAybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListObjectsMAybe($items: [MyInputObject!]) {
  InputListObjectsMAybe(items: $items) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListObjectsMAybe'
        );
    }
}


class InputListObjectsMAybeVariables {
    
    
        final Option<List<MyInputObject>?> items;
    

    InputListObjectsMAybeVariables (
        
            {
            

    
        
            this.items = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (items.isSome()) {
            final value = this.items.some();
            data["items"] = 
    
        
        
            value?.map((e) => 
    
        
            e.toJson()
        
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputListObjectsMAybeVariables updateWith(
    {
        
            
                Option<Option<List<MyInputObject>?>> items = const None()
            
            
        
    }
) {
    
        final Option<List<MyInputObject>?> items$next;
        
            switch (items) {

                case Some(value: final updateData):
                    items$next = updateData;
                case None():
                    items$next = this.items;
            }

        
    
    return InputListObjectsMAybeVariables(
        
            items: items$next
            
        
    );
}


}
