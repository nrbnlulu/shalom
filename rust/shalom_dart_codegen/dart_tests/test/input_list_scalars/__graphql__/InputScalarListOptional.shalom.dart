






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputScalarListOptionalResponse{

    
    /// class members
    
        final InputScalarListOptional_InputScalarListOptional? InputScalarListOptional;
    
    // keywordargs constructor
    InputScalarListOptionalResponse({
    
        this.InputScalarListOptional,
    
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
            final InputScalarListOptionalNormalized$Key = "InputScalarListOptional";
            final InputScalarListOptional$cached = this$NormalizedRecord[InputScalarListOptionalNormalized$Key];
            final InputScalarListOptional$raw = data["InputScalarListOptional"];
            if (InputScalarListOptional$raw != null){
                
                    InputScalarListOptional_InputScalarListOptional.updateCachePrivate(
                        InputScalarListOptional$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarListOptionalNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarListOptional") && InputScalarListOptional$cached != null){
                    this$NormalizedRecord[InputScalarListOptionalNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListOptionalResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarListOptional$raw = data["InputScalarListOptional"];
            final InputScalarListOptional_InputScalarListOptional? InputScalarListOptional$value = 
    
        
            InputScalarListOptional$raw == null ? null :
        
    
;
        return InputScalarListOptionalResponse(
            InputScalarListOptional: InputScalarListOptional$value,
            
        );
    }
    static InputScalarListOptionalResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputScalarListOptional",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "InputScalarListOptional")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListOptionalResponse &&
    
        
    
        other.InputScalarListOptional == InputScalarListOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListOptional':
            
                
    
        
            this.InputScalarListOptional?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputScalarListOptional  {
        
    
    /// class members
    
        final InputScalarListOptional_InputScalarListOptional? InputScalarListOptional;
    
    // keywordargs constructor
    InputScalarListOptional({
    
        this.InputScalarListOptional,
    
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
            final InputScalarListOptionalNormalized$Key = "InputScalarListOptional";
            final InputScalarListOptional$cached = this$NormalizedRecord[InputScalarListOptionalNormalized$Key];
            final InputScalarListOptional$raw = data["InputScalarListOptional"];
            if (InputScalarListOptional$raw != null){
                
                    InputScalarListOptional_InputScalarListOptional.updateCachePrivate(
                        InputScalarListOptional$raw as JsonObject,
                        ctx,
                        this$fieldName: InputScalarListOptionalNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputScalarListOptional") && InputScalarListOptional$cached != null){
                    this$NormalizedRecord[InputScalarListOptionalNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputScalarListOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputScalarListOptional$raw = data["InputScalarListOptional"];
            final InputScalarListOptional_InputScalarListOptional? InputScalarListOptional$value = 
    
        
            InputScalarListOptional$raw == null ? null :
        
    
;
        return InputScalarListOptional(
            InputScalarListOptional: InputScalarListOptional$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListOptional &&
    
        
    
        other.InputScalarListOptional == InputScalarListOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListOptional':
            
                
    
        
            this.InputScalarListOptional?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class InputScalarListOptional_InputScalarListOptional  {
        
    
    /// class members
    
        final bool success;
    
    // keywordargs constructor
    InputScalarListOptional_InputScalarListOptional({
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

    static InputScalarListOptional_InputScalarListOptional fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final success$raw = data["success"];
            final bool success$value = 
    
        
            
                success$raw as bool
            
        
    
;
        return InputScalarListOptional_InputScalarListOptional(
            success: success$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListOptional_InputScalarListOptional &&
    
        
    
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


class RequestInputScalarListOptional extends Requestable {
    
    final InputScalarListOptionalVariables variables;
    

    RequestInputScalarListOptional(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputScalarListOptional($names: [String] = null) {
  InputScalarListOptional(names: $names) {
    success
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputScalarListOptional'
        );
    }
}


class InputScalarListOptionalVariables {
    
    
        final List<String?>? names;
    

    InputScalarListOptionalVariables (
        
            {
            

    
        
            
            
                this.names
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["names"] = 
    
        
        
            this.names?.map((e) => 
    
        e
    
).toList()
        
    
;
    


        return data;
    }

    
InputScalarListOptionalVariables updateWith(
    {
        
            
                Option<List<String?>?> names = const None()
            
            
        
    }
) {
    
        final List<String?>? names$next;
        
            switch (names) {

                case Some(value: final updateData):
                    names$next = updateData;
                case None():
                    names$next = this.names;
            }

        
    
    return InputScalarListOptionalVariables(
        
            names: names$next
            
        
    );
}


}
