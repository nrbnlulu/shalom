






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputScalarInsideInputTypeResponse{

    
    /// class members
    
        final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType;
    
    // keywordargs constructor
    InputScalarInsideInputTypeResponse({
    
        this.InputScalarInsideInputType,
    
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
        final RecordID? this$normalizedID_temp = data["InputScalarInsideInputType"] as RecordID?;
            if (this$normalizedID_temp == null) {
                
                    this$normalizedID = this$fieldName;
                    this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
                
            } else {
                this$normalizedID = this$normalizedID_temp as String;
                this$data[this$fieldName] = this$normalizedID;
                ctx.addDependantRecord(this$normalizedID);
                this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
                }
        // TODO: handle arguments
            final InputScalarInsideInputTypeNormalized$Key = "InputScalarInsideInputType";
            final InputScalarInsideInputType$cached = this$NormalizedRecord[InputScalarInsideInputTypeNormalized$Key];
            final InputScalarInsideInputType$raw = data["InputScalarInsideInputType"];
            if (InputScalarInsideInputType$raw != null){
                
                    InputScalarInsideInputType_InputScalarInsideInputType.updateCachePrivate(
                        InputScalarInsideInputType$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarInsideInputTypeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarInsideInputType") && InputScalarInsideInputType$cached != null){
                    this$NormalizedRecord[InputScalarInsideInputTypeNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, InputScalarInsideInputTypeNormalized$Key);
                    
                }
            }

        
    }

    static InputScalarInsideInputTypeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarInsideInputType$raw = data["InputScalarInsideInputType"];
            final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType$value = 
    
        
            InputScalarInsideInputType$raw == null ? null :
        
    
;
        return InputScalarInsideInputTypeResponse(
            InputScalarInsideInputType: InputScalarInsideInputType$value,
            
        );
    }
    static InputScalarInsideInputTypeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputScalarInsideInputType",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputScalarInsideInputType")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarInsideInputTypeResponse &&
    
        
    
        other.InputScalarInsideInputType == InputScalarInsideInputType
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarInsideInputType.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarInsideInputType':
            
                
    
        
            this.InputScalarInsideInputType?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputScalarInsideInputType  {
        
    
    /// class members
    
        final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType;
    
    // keywordargs constructor
    InputScalarInsideInputType({
    
        this.InputScalarInsideInputType,
    
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
        final RecordID? this$normalizedID_temp = data["InputScalarInsideInputType"] as RecordID?;
            if (this$normalizedID_temp == null) {
                
                    this$normalizedID = this$fieldName;
                    this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
                
            } else {
                this$normalizedID = this$normalizedID_temp as String;
                this$data[this$fieldName] = this$normalizedID;
                ctx.addDependantRecord(this$normalizedID);
                this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
                }
        // TODO: handle arguments
            final InputScalarInsideInputTypeNormalized$Key = "InputScalarInsideInputType";
            final InputScalarInsideInputType$cached = this$NormalizedRecord[InputScalarInsideInputTypeNormalized$Key];
            final InputScalarInsideInputType$raw = data["InputScalarInsideInputType"];
            if (InputScalarInsideInputType$raw != null){
                
                    InputScalarInsideInputType_InputScalarInsideInputType.updateCachePrivate(
                        InputScalarInsideInputType$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarInsideInputTypeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarInsideInputType") && InputScalarInsideInputType$cached != null){
                    this$NormalizedRecord[InputScalarInsideInputTypeNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, InputScalarInsideInputTypeNormalized$Key);
                    
                }
            }

        
    }

    static InputScalarInsideInputType fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarInsideInputType$raw = data["InputScalarInsideInputType"];
            final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType$value = 
    
        
            InputScalarInsideInputType$raw == null ? null :
        
    
;
        return InputScalarInsideInputType(
            InputScalarInsideInputType: InputScalarInsideInputType$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarInsideInputType &&
    
        
    
        other.InputScalarInsideInputType == InputScalarInsideInputType
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarInsideInputType.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarInsideInputType':
            
                
    
        
            this.InputScalarInsideInputType?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputScalarInsideInputType_InputScalarInsideInputType  {
        
    
    /// class members
    
        final bool success;
    
    // keywordargs constructor
    InputScalarInsideInputType_InputScalarInsideInputType({
    required
        this.success,
    
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

        
    }

    static InputScalarInsideInputType_InputScalarInsideInputType fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        return InputScalarInsideInputType_InputScalarInsideInputType(
            success: success$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarInsideInputType_InputScalarInsideInputType &&
    
        
    
        other.success == success
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        success.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'success':
            
                
    
        
            this.success
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputScalarInsideInputType extends Requestable {
    
    final InputScalarInsideInputTypeVariables variables;
    

    RequestInputScalarInsideInputType(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputScalarInsideInputType($user: UserInput!) {
  InputScalarInsideInputType(user: $user) {
    success
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputScalarInsideInputType'
        );
    }
}


class InputScalarInsideInputTypeVariables {
    
    
        final UserInput user;
    

    InputScalarInsideInputTypeVariables (
        
            {
            

    
        
            required this.user
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["user"] = 
    
        
            this.user.toJson()
        
    
;
    


        return data;
    }

    
InputScalarInsideInputTypeVariables updateWith(
    {
        
            
                UserInput? user
            
            
        
    }
) {
    
        final UserInput user$next;
        
            if (user != null) {
                user$next = user;
            } else {
                user$next = this.user;
            }
        
    
    return InputScalarInsideInputTypeVariables(
        
            user: user$next
            
        
    );
}


}
