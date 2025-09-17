






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListMaybeResponse{

    
    /// class members
    
        final InputCustomScalarListMaybe_InputCustomScalarListMaybe? InputCustomScalarListMaybe;
    
    // keywordargs constructor
    InputCustomScalarListMaybeResponse({
    
        this.InputCustomScalarListMaybe,
    
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
            final InputCustomScalarListMaybeNormalized$Key = "InputCustomScalarListMaybe";
            final InputCustomScalarListMaybe$cached = this$NormalizedRecord[InputCustomScalarListMaybeNormalized$Key];
            final InputCustomScalarListMaybe$raw = data["InputCustomScalarListMaybe"];
            if (InputCustomScalarListMaybe$raw != null){
                
                    InputCustomScalarListMaybe_InputCustomScalarListMaybe.updateCachePrivate(
                        InputCustomScalarListMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListMaybe") && InputCustomScalarListMaybe$cached != null){
                    this$NormalizedRecord[InputCustomScalarListMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListMaybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListMaybe$raw = data["InputCustomScalarListMaybe"];
            final InputCustomScalarListMaybe_InputCustomScalarListMaybe? InputCustomScalarListMaybe$value = 
    
        
            InputCustomScalarListMaybe$raw == null ? null :
        
    
;
        return InputCustomScalarListMaybeResponse(
            InputCustomScalarListMaybe: InputCustomScalarListMaybe$value,
            
        );
    }
    static InputCustomScalarListMaybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputCustomScalarListMaybe",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputCustomScalarListMaybe")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListMaybeResponse &&
    
        
    
        other.InputCustomScalarListMaybe == InputCustomScalarListMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListMaybe':
            
                
    
        
            this.InputCustomScalarListMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListMaybe  {
        
    
    /// class members
    
        final InputCustomScalarListMaybe_InputCustomScalarListMaybe? InputCustomScalarListMaybe;
    
    // keywordargs constructor
    InputCustomScalarListMaybe({
    
        this.InputCustomScalarListMaybe,
    
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
            final InputCustomScalarListMaybeNormalized$Key = "InputCustomScalarListMaybe";
            final InputCustomScalarListMaybe$cached = this$NormalizedRecord[InputCustomScalarListMaybeNormalized$Key];
            final InputCustomScalarListMaybe$raw = data["InputCustomScalarListMaybe"];
            if (InputCustomScalarListMaybe$raw != null){
                
                    InputCustomScalarListMaybe_InputCustomScalarListMaybe.updateCachePrivate(
                        InputCustomScalarListMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListMaybe") && InputCustomScalarListMaybe$cached != null){
                    this$NormalizedRecord[InputCustomScalarListMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListMaybe$raw = data["InputCustomScalarListMaybe"];
            final InputCustomScalarListMaybe_InputCustomScalarListMaybe? InputCustomScalarListMaybe$value = 
    
        
            InputCustomScalarListMaybe$raw == null ? null :
        
    
;
        return InputCustomScalarListMaybe(
            InputCustomScalarListMaybe: InputCustomScalarListMaybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListMaybe &&
    
        
    
        other.InputCustomScalarListMaybe == InputCustomScalarListMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListMaybe':
            
                
    
        
            this.InputCustomScalarListMaybe?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputCustomScalarListMaybe_InputCustomScalarListMaybe  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputCustomScalarListMaybe_InputCustomScalarListMaybe({
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

    static InputCustomScalarListMaybe_InputCustomScalarListMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputCustomScalarListMaybe_InputCustomScalarListMaybe(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListMaybe_InputCustomScalarListMaybe &&
    
        
    
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


class RequestInputCustomScalarListMaybe extends Requestable {
    
    final InputCustomScalarListMaybeVariables variables;
    

    RequestInputCustomScalarListMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListMaybe($optionalItems: [Point!]) {
  InputCustomScalarListMaybe(optionalItems: $optionalItems) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListMaybe'
        );
    }
}


class InputCustomScalarListMaybeVariables {
    
    
        final Option<List<rmhlxei.Point>?> optionalItems;
    

    InputCustomScalarListMaybeVariables (
        
            {
            

    
        
            this.optionalItems = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (optionalItems.isSome()) {
            final value = this.optionalItems.some();
            data["optionalItems"] = 
    
        
        
            value?.map((e) => 
    
        
        
            rmhlxei.pointScalarImpl.serialize(e)
        
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputCustomScalarListMaybeVariables updateWith(
    {
        
            
                Option<Option<List<rmhlxei.Point>?>> optionalItems = const None()
            
            
        
    }
) {
    
        final Option<List<rmhlxei.Point>?> optionalItems$next;
        
            switch (optionalItems) {

                case Some(value: final updateData):
                    optionalItems$next = updateData;
                case None():
                    optionalItems$next = this.optionalItems;
            }

        
    
    return InputCustomScalarListMaybeVariables(
        
            optionalItems: optionalItems$next
            
        
    );
}


}
