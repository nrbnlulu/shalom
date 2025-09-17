






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListNullableMaybeResponse{

    
    /// class members
    
        final InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe? InputCustomScalarListNullableMaybe;
    
    // keywordargs constructor
    InputCustomScalarListNullableMaybeResponse({
    
        this.InputCustomScalarListNullableMaybe,
    
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
            final InputCustomScalarListNullableMaybeNormalized$Key = "InputCustomScalarListNullableMaybe";
            final InputCustomScalarListNullableMaybe$cached = this$NormalizedRecord[InputCustomScalarListNullableMaybeNormalized$Key];
            final InputCustomScalarListNullableMaybe$raw = data["InputCustomScalarListNullableMaybe"];
            if (InputCustomScalarListNullableMaybe$raw != null){
                
                    InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe.updateCachePrivate(
                        InputCustomScalarListNullableMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListNullableMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListNullableMaybe") && InputCustomScalarListNullableMaybe$cached != null){
                    this$NormalizedRecord[InputCustomScalarListNullableMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListNullableMaybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListNullableMaybe$raw = data["InputCustomScalarListNullableMaybe"];
            final InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe? InputCustomScalarListNullableMaybe$value = 
    
        
            InputCustomScalarListNullableMaybe$raw == null ? null :
        
    
;
        return InputCustomScalarListNullableMaybeResponse(
            InputCustomScalarListNullableMaybe: InputCustomScalarListNullableMaybe$value,
            
        );
    }
    static InputCustomScalarListNullableMaybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputCustomScalarListNullableMaybe",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputCustomScalarListNullableMaybe")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListNullableMaybeResponse &&
    
        
    
        other.InputCustomScalarListNullableMaybe == InputCustomScalarListNullableMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListNullableMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListNullableMaybe':
            
                
    
        
            this.InputCustomScalarListNullableMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListNullableMaybe  {
        
    
    /// class members
    
        final InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe? InputCustomScalarListNullableMaybe;
    
    // keywordargs constructor
    InputCustomScalarListNullableMaybe({
    
        this.InputCustomScalarListNullableMaybe,
    
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
            final InputCustomScalarListNullableMaybeNormalized$Key = "InputCustomScalarListNullableMaybe";
            final InputCustomScalarListNullableMaybe$cached = this$NormalizedRecord[InputCustomScalarListNullableMaybeNormalized$Key];
            final InputCustomScalarListNullableMaybe$raw = data["InputCustomScalarListNullableMaybe"];
            if (InputCustomScalarListNullableMaybe$raw != null){
                
                    InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe.updateCachePrivate(
                        InputCustomScalarListNullableMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListNullableMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListNullableMaybe") && InputCustomScalarListNullableMaybe$cached != null){
                    this$NormalizedRecord[InputCustomScalarListNullableMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListNullableMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListNullableMaybe$raw = data["InputCustomScalarListNullableMaybe"];
            final InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe? InputCustomScalarListNullableMaybe$value = 
    
        
            InputCustomScalarListNullableMaybe$raw == null ? null :
        
    
;
        return InputCustomScalarListNullableMaybe(
            InputCustomScalarListNullableMaybe: InputCustomScalarListNullableMaybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListNullableMaybe &&
    
        
    
        other.InputCustomScalarListNullableMaybe == InputCustomScalarListNullableMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListNullableMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListNullableMaybe':
            
                
    
        
            this.InputCustomScalarListNullableMaybe?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe({
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

    static InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe &&
    
        
    
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


class RequestInputCustomScalarListNullableMaybe extends Requestable {
    
    final InputCustomScalarListNullableMaybeVariables variables;
    

    RequestInputCustomScalarListNullableMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListNullableMaybe($sparseData: [Point]) {
  InputCustomScalarListNullableMaybe(sparseData: $sparseData) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListNullableMaybe'
        );
    }
}


class InputCustomScalarListNullableMaybeVariables {
    
    
        final Option<List<rmhlxei.Point?>?> sparseData;
    

    InputCustomScalarListNullableMaybeVariables (
        
            {
            

    
        
            this.sparseData = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (sparseData.isSome()) {
            final value = this.sparseData.some();
            data["sparseData"] = 
    
        
        
            value?.map((e) => 
    
        
        
            e == null ? null : rmhlxei.pointScalarImpl.serialize(e!)
        
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputCustomScalarListNullableMaybeVariables updateWith(
    {
        
            
                Option<Option<List<rmhlxei.Point?>?>> sparseData = const None()
            
            
        
    }
) {
    
        final Option<List<rmhlxei.Point?>?> sparseData$next;
        
            switch (sparseData) {

                case Some(value: final updateData):
                    sparseData$next = updateData;
                case None():
                    sparseData$next = this.sparseData;
            }

        
    
    return InputCustomScalarListNullableMaybeVariables(
        
            sparseData: sparseData$next
            
        
    );
}


}
