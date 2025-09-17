






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputScalarListMaybeResponse{

    
    /// class members
    
        final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe;
    
    // keywordargs constructor
    InputScalarListMaybeResponse({
    
        this.InputScalarListMaybe,
    
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
            final InputScalarListMaybeNormalized$Key = "InputScalarListMaybe";
            final InputScalarListMaybe$cached = this$NormalizedRecord[InputScalarListMaybeNormalized$Key];
            final InputScalarListMaybe$raw = data["InputScalarListMaybe"];
            if (InputScalarListMaybe$raw != null){
                
                    InputScalarListMaybe_InputScalarListMaybe.updateCachePrivate(
                        InputScalarListMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarListMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarListMaybe") && InputScalarListMaybe$cached != null){
                    this$NormalizedRecord[InputScalarListMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListMaybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarListMaybe$raw = data["InputScalarListMaybe"];
            final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe$value = 
    
        
            InputScalarListMaybe$raw == null ? null :
        
    
;
        return InputScalarListMaybeResponse(
            InputScalarListMaybe: InputScalarListMaybe$value,
            
        );
    }
    static InputScalarListMaybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputScalarListMaybe",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputScalarListMaybe")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListMaybeResponse &&
    
        
    
        other.InputScalarListMaybe == InputScalarListMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListMaybe':
            
                
    
        
            this.InputScalarListMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputScalarListMaybe  {
        
    
    /// class members
    
        final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe;
    
    // keywordargs constructor
    InputScalarListMaybe({
    
        this.InputScalarListMaybe,
    
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
            final InputScalarListMaybeNormalized$Key = "InputScalarListMaybe";
            final InputScalarListMaybe$cached = this$NormalizedRecord[InputScalarListMaybeNormalized$Key];
            final InputScalarListMaybe$raw = data["InputScalarListMaybe"];
            if (InputScalarListMaybe$raw != null){
                
                    InputScalarListMaybe_InputScalarListMaybe.updateCachePrivate(
                        InputScalarListMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarListMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarListMaybe") && InputScalarListMaybe$cached != null){
                    this$NormalizedRecord[InputScalarListMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarListMaybe$raw = data["InputScalarListMaybe"];
            final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe$value = 
    
        
            InputScalarListMaybe$raw == null ? null :
        
    
;
        return InputScalarListMaybe(
            InputScalarListMaybe: InputScalarListMaybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListMaybe &&
    
        
    
        other.InputScalarListMaybe == InputScalarListMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListMaybe':
            
                
    
        
            this.InputScalarListMaybe?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputScalarListMaybe_InputScalarListMaybe  {
        
    
    /// class members
    
        final bool success;
    
    // keywordargs constructor
    InputScalarListMaybe_InputScalarListMaybe({
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

    static InputScalarListMaybe_InputScalarListMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        return InputScalarListMaybe_InputScalarListMaybe(
            success: success$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListMaybe_InputScalarListMaybe &&
    
        
    
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


class RequestInputScalarListMaybe extends Requestable {
    
    final InputScalarListMaybeVariables variables;
    

    RequestInputScalarListMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputScalarListMaybe($ints: [Int]) {
  InputScalarListMaybe(ints: $ints) {
    success
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputScalarListMaybe'
        );
    }
}


class InputScalarListMaybeVariables {
    
    
        final Option<List<int?>?> ints;
    

    InputScalarListMaybeVariables (
        
            {
            

    
        
            this.ints = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (ints.isSome()) {
            final value = this.ints.some();
            data["ints"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputScalarListMaybeVariables updateWith(
    {
        
            
                Option<Option<List<int?>?>> ints = const None()
            
            
        
    }
) {
    
        final Option<List<int?>?> ints$next;
        
            switch (ints) {

                case Some(value: final updateData):
                    ints$next = updateData;
                case None():
                    ints$next = this.ints;
            }

        
    
    return InputScalarListMaybeVariables(
        
            ints: ints$next
            
        
    );
}


}
