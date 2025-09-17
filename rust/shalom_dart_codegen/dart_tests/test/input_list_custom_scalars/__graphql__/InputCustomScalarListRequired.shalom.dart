






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListRequiredResponse{

    
    /// class members
    
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired;
    
    // keywordargs constructor
    InputCustomScalarListRequiredResponse({
    
        this.InputCustomScalarListRequired,
    
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
            final InputCustomScalarListRequiredNormalized$Key = "InputCustomScalarListRequired";
            final InputCustomScalarListRequired$cached = this$NormalizedRecord[InputCustomScalarListRequiredNormalized$Key];
            final InputCustomScalarListRequired$raw = data["InputCustomScalarListRequired"];
            if (InputCustomScalarListRequired$raw != null){
                
                    InputCustomScalarListRequired_InputCustomScalarListRequired.updateCachePrivate(
                        InputCustomScalarListRequired$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListRequiredNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListRequired") && InputCustomScalarListRequired$cached != null){
                    this$NormalizedRecord[InputCustomScalarListRequiredNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListRequiredResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListRequired$raw = data["InputCustomScalarListRequired"];
            final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired$value = 
    
        
            InputCustomScalarListRequired$raw == null ? null :
        
    
;
        return InputCustomScalarListRequiredResponse(
            InputCustomScalarListRequired: InputCustomScalarListRequired$value,
            
        );
    }
    static InputCustomScalarListRequiredResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputCustomScalarListRequired",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputCustomScalarListRequired")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListRequiredResponse &&
    
        
    
        other.InputCustomScalarListRequired == InputCustomScalarListRequired
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListRequired.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListRequired':
            
                
    
        
            this.InputCustomScalarListRequired?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListRequired  {
        
    
    /// class members
    
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired;
    
    // keywordargs constructor
    InputCustomScalarListRequired({
    
        this.InputCustomScalarListRequired,
    
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
            final InputCustomScalarListRequiredNormalized$Key = "InputCustomScalarListRequired";
            final InputCustomScalarListRequired$cached = this$NormalizedRecord[InputCustomScalarListRequiredNormalized$Key];
            final InputCustomScalarListRequired$raw = data["InputCustomScalarListRequired"];
            if (InputCustomScalarListRequired$raw != null){
                
                    InputCustomScalarListRequired_InputCustomScalarListRequired.updateCachePrivate(
                        InputCustomScalarListRequired$raw as JsonObject,
                        ctx,
                        this$fieldName: InputCustomScalarListRequiredNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputCustomScalarListRequired") && InputCustomScalarListRequired$cached != null){
                    this$NormalizedRecord[InputCustomScalarListRequiredNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputCustomScalarListRequired fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputCustomScalarListRequired$raw = data["InputCustomScalarListRequired"];
            final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired$value = 
    
        
            InputCustomScalarListRequired$raw == null ? null :
        
    
;
        return InputCustomScalarListRequired(
            InputCustomScalarListRequired: InputCustomScalarListRequired$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListRequired &&
    
        
    
        other.InputCustomScalarListRequired == InputCustomScalarListRequired
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListRequired.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListRequired':
            
                
    
        
            this.InputCustomScalarListRequired?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputCustomScalarListRequired_InputCustomScalarListRequired  {
        
    
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputCustomScalarListRequired_InputCustomScalarListRequired({
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

    static InputCustomScalarListRequired_InputCustomScalarListRequired fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        
            final message$raw = data["message"];
            final String? message$value = 
    
        
            
                message$raw as String?
            
        
    
;
        return InputCustomScalarListRequired_InputCustomScalarListRequired(
            success: success$value,
            message: message$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListRequired_InputCustomScalarListRequired &&
    
        
    
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


class RequestInputCustomScalarListRequired extends Requestable {
    
    final InputCustomScalarListRequiredVariables variables;
    

    RequestInputCustomScalarListRequired(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListRequired($requiredItems: [Point!]!) {
  InputCustomScalarListRequired(requiredItems: $requiredItems) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListRequired'
        );
    }
}


class InputCustomScalarListRequiredVariables {
    
    
        final List<rmhlxei.Point> requiredItems;
    

    InputCustomScalarListRequiredVariables (
        
            {
            

    
        
            required this.requiredItems
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["requiredItems"] = 
    
        
        
            this.requiredItems.map((e) => 
    
        
        
            rmhlxei.pointScalarImpl.serialize(e)
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputCustomScalarListRequiredVariables updateWith(
    {
        
            
                List<rmhlxei.Point>? requiredItems
            
            
        
    }
) {
    
        final List<rmhlxei.Point> requiredItems$next;
        
            if (requiredItems != null) {
                requiredItems$next = requiredItems;
            } else {
                requiredItems$next = this.requiredItems;
            }
        
    
    return InputCustomScalarListRequiredVariables(
        
            requiredItems: requiredItems$next
            
        
    );
}


}
