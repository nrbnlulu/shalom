






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListOfOptionalObjectsWithNullDefaultResponse{

    
    /// class members
    
        final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault? InputListOfOptionalObjectsWithNullDefault;
    
    // keywordargs constructor
    InputListOfOptionalObjectsWithNullDefaultResponse({
    
        this.InputListOfOptionalObjectsWithNullDefault,
    
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
            final InputListOfOptionalObjectsWithNullDefaultNormalized$Key = "InputListOfOptionalObjectsWithNullDefault";
            final InputListOfOptionalObjectsWithNullDefault$cached = this$NormalizedRecord[InputListOfOptionalObjectsWithNullDefaultNormalized$Key];
            final InputListOfOptionalObjectsWithNullDefault$raw = data["InputListOfOptionalObjectsWithNullDefault"];
            if (InputListOfOptionalObjectsWithNullDefault$raw != null){
                
                    InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault.updateCachePrivate(
                        InputListOfOptionalObjectsWithNullDefault$raw as JsonObject,
                        ctx,
                        this$fieldName: InputListOfOptionalObjectsWithNullDefaultNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListOfOptionalObjectsWithNullDefault") && InputListOfOptionalObjectsWithNullDefault$cached != null){
                    this$NormalizedRecord[InputListOfOptionalObjectsWithNullDefaultNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListOfOptionalObjectsWithNullDefaultResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListOfOptionalObjectsWithNullDefault$raw = data["InputListOfOptionalObjectsWithNullDefault"];
            final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault? InputListOfOptionalObjectsWithNullDefault$value = 
    
        
            InputListOfOptionalObjectsWithNullDefault$raw == null ? null :
        
    
;
        return InputListOfOptionalObjectsWithNullDefaultResponse(
            InputListOfOptionalObjectsWithNullDefault: InputListOfOptionalObjectsWithNullDefault$value,
            
        );
    }
    static InputListOfOptionalObjectsWithNullDefaultResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListOfOptionalObjectsWithNullDefault",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputListOfOptionalObjectsWithNullDefault")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfOptionalObjectsWithNullDefaultResponse &&
    
        
    
        other.InputListOfOptionalObjectsWithNullDefault == InputListOfOptionalObjectsWithNullDefault
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListOfOptionalObjectsWithNullDefault.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListOfOptionalObjectsWithNullDefault':
            
                
    
        
            this.InputListOfOptionalObjectsWithNullDefault?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListOfOptionalObjectsWithNullDefault  {
        
    
    /// class members
    
        final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault? InputListOfOptionalObjectsWithNullDefault;
    
    // keywordargs constructor
    InputListOfOptionalObjectsWithNullDefault({
    
        this.InputListOfOptionalObjectsWithNullDefault,
    
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
            final InputListOfOptionalObjectsWithNullDefaultNormalized$Key = "InputListOfOptionalObjectsWithNullDefault";
            final InputListOfOptionalObjectsWithNullDefault$cached = this$NormalizedRecord[InputListOfOptionalObjectsWithNullDefaultNormalized$Key];
            final InputListOfOptionalObjectsWithNullDefault$raw = data["InputListOfOptionalObjectsWithNullDefault"];
            if (InputListOfOptionalObjectsWithNullDefault$raw != null){
                
                    InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault.updateCachePrivate(
                        InputListOfOptionalObjectsWithNullDefault$raw as JsonObject,
                        ctx,
                        this$fieldName: InputListOfOptionalObjectsWithNullDefaultNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListOfOptionalObjectsWithNullDefault") && InputListOfOptionalObjectsWithNullDefault$cached != null){
                    this$NormalizedRecord[InputListOfOptionalObjectsWithNullDefaultNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListOfOptionalObjectsWithNullDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListOfOptionalObjectsWithNullDefault$raw = data["InputListOfOptionalObjectsWithNullDefault"];
            final InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault? InputListOfOptionalObjectsWithNullDefault$value = 
    
        
            InputListOfOptionalObjectsWithNullDefault$raw == null ? null :
        
    
;
        return InputListOfOptionalObjectsWithNullDefault(
            InputListOfOptionalObjectsWithNullDefault: InputListOfOptionalObjectsWithNullDefault$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfOptionalObjectsWithNullDefault &&
    
        
    
        other.InputListOfOptionalObjectsWithNullDefault == InputListOfOptionalObjectsWithNullDefault
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListOfOptionalObjectsWithNullDefault.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListOfOptionalObjectsWithNullDefault':
            
                
    
        
            this.InputListOfOptionalObjectsWithNullDefault?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault({
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

    static InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfOptionalObjectsWithNullDefault_InputListOfOptionalObjectsWithNullDefault &&
    
        
    
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


class RequestInputListOfOptionalObjectsWithNullDefault extends Requestable {
    
    final InputListOfOptionalObjectsWithNullDefaultVariables variables;
    

    RequestInputListOfOptionalObjectsWithNullDefault(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListOfOptionalObjectsWithNullDefault($items: [MyInputObject!] = null) {
  InputListOfOptionalObjectsWithNullDefault(items: $items) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListOfOptionalObjectsWithNullDefault'
        );
    }
}


class InputListOfOptionalObjectsWithNullDefaultVariables {
    
    
        final List<MyInputObject>? items;
    

    InputListOfOptionalObjectsWithNullDefaultVariables (
        
            {
            

    
        
            
            
                this.items
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["items"] = 
    
        
        
            this.items?.map((e) => 
    
        
            e.toJson()
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputListOfOptionalObjectsWithNullDefaultVariables updateWith(
    {
        
            
                Option<List<MyInputObject>?> items = const None()
            
            
        
    }
) {
    
        final List<MyInputObject>? items$next;
        
            switch (items) {

                case Some(value: final updateData):
                    items$next = updateData;
                case None():
                    items$next = this.items;
            }

        
    
    return InputListOfOptionalObjectsWithNullDefaultVariables(
        
            items: items$next
            
        
    );
}


}
