






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListOptionalWithDefaultResponse{

    
    /// class members
    
        final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault? InputCustomScalarListOptionalWithDefault;
    
    // keywordargs constructor
    InputCustomScalarListOptionalWithDefaultResponse({
    
        this.InputCustomScalarListOptionalWithDefault,
    
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
            final InputCustomScalarListOptionalWithDefaultNormalized$Key = "InputCustomScalarListOptionalWithDefault";
            final InputCustomScalarListOptionalWithDefault$cached = this$NormalizedRecord[InputCustomScalarListOptionalWithDefaultNormalized$Key];
            final InputCustomScalarListOptionalWithDefault$raw = data["InputCustomScalarListOptionalWithDefault"];
            if (InputCustomScalarListOptionalWithDefault$raw != null){
                
                    InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault.updateCachePrivate(
                        InputCustomScalarListOptionalWithDefault$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListOptionalWithDefaultNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListOptionalWithDefault") && InputCustomScalarListOptionalWithDefault$cached != null){
                    this$NormalizedRecord[InputCustomScalarListOptionalWithDefaultNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListOptionalWithDefaultResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListOptionalWithDefault$raw = data["InputCustomScalarListOptionalWithDefault"];
            final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault? InputCustomScalarListOptionalWithDefault$value = 
    
        
            InputCustomScalarListOptionalWithDefault$raw == null ? null :
        
    
;
        return InputCustomScalarListOptionalWithDefaultResponse(
            InputCustomScalarListOptionalWithDefault: InputCustomScalarListOptionalWithDefault$value,
            
        );
    }
    static InputCustomScalarListOptionalWithDefaultResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputCustomScalarListOptionalWithDefault",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputCustomScalarListOptionalWithDefault")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListOptionalWithDefaultResponse &&
    
        
    
        other.InputCustomScalarListOptionalWithDefault == InputCustomScalarListOptionalWithDefault
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListOptionalWithDefault.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListOptionalWithDefault':
            
                
    
        
            this.InputCustomScalarListOptionalWithDefault?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListOptionalWithDefault  {
        
    
    /// class members
    
        final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault? InputCustomScalarListOptionalWithDefault;
    
    // keywordargs constructor
    InputCustomScalarListOptionalWithDefault({
    
        this.InputCustomScalarListOptionalWithDefault,
    
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
            final InputCustomScalarListOptionalWithDefaultNormalized$Key = "InputCustomScalarListOptionalWithDefault";
            final InputCustomScalarListOptionalWithDefault$cached = this$NormalizedRecord[InputCustomScalarListOptionalWithDefaultNormalized$Key];
            final InputCustomScalarListOptionalWithDefault$raw = data["InputCustomScalarListOptionalWithDefault"];
            if (InputCustomScalarListOptionalWithDefault$raw != null){
                
                    InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault.updateCachePrivate(
                        InputCustomScalarListOptionalWithDefault$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListOptionalWithDefaultNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListOptionalWithDefault") && InputCustomScalarListOptionalWithDefault$cached != null){
                    this$NormalizedRecord[InputCustomScalarListOptionalWithDefaultNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListOptionalWithDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListOptionalWithDefault$raw = data["InputCustomScalarListOptionalWithDefault"];
            final InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault? InputCustomScalarListOptionalWithDefault$value = 
    
        
            InputCustomScalarListOptionalWithDefault$raw == null ? null :
        
    
;
        return InputCustomScalarListOptionalWithDefault(
            InputCustomScalarListOptionalWithDefault: InputCustomScalarListOptionalWithDefault$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListOptionalWithDefault &&
    
        
    
        other.InputCustomScalarListOptionalWithDefault == InputCustomScalarListOptionalWithDefault
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListOptionalWithDefault.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListOptionalWithDefault':
            
                
    
        
            this.InputCustomScalarListOptionalWithDefault?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault({
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

    static InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListOptionalWithDefault_InputCustomScalarListOptionalWithDefault &&
    
        
    
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


class RequestInputCustomScalarListOptionalWithDefault extends Requestable {
    
    final InputCustomScalarListOptionalWithDefaultVariables variables;
    

    RequestInputCustomScalarListOptionalWithDefault(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListOptionalWithDefault($defaultItems: [Point!] = null) {
  InputCustomScalarListOptionalWithDefault(defaultItems: $defaultItems) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListOptionalWithDefault'
        );
    }
}


class InputCustomScalarListOptionalWithDefaultVariables {
    
    
        final List<rmhlxei.Point>? defaultItems;
    

    InputCustomScalarListOptionalWithDefaultVariables (
        
            {
            

    
        
            
            
                this.defaultItems
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["defaultItems"] = 
    
        
        
            this.defaultItems?.map((e) => 
    
        
        
            rmhlxei.pointScalarImpl.serialize(e)
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputCustomScalarListOptionalWithDefaultVariables updateWith(
    {
        
            
                Option<List<rmhlxei.Point>?> defaultItems = const None()
            
            
        
    }
) {
    
        final List<rmhlxei.Point>? defaultItems$next;
        
            switch (defaultItems) {

                case Some(value: final updateData):
                    defaultItems$next = updateData;
                case None():
                    defaultItems$next = this.defaultItems;
            }

        
    
    return InputCustomScalarListOptionalWithDefaultVariables(
        
            defaultItems: defaultItems$next
            
        
    );
}


}
