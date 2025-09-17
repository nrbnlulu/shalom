






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListEnumMaybeResponse{

    
    /// class members
    
        final String? InputListEnumMaybe;
    
    // keywordargs constructor
    InputListEnumMaybeResponse({
    
        this.InputListEnumMaybe,
    
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
            final InputListEnumMaybeNormalized$Key = "InputListEnumMaybe";
            final InputListEnumMaybe$cached = this$NormalizedRecord[InputListEnumMaybeNormalized$Key];
            final InputListEnumMaybe$raw = data["InputListEnumMaybe"];
            if (InputListEnumMaybe$raw != null){
                
                    if (InputListEnumMaybe$cached != InputListEnumMaybe$raw){
                        
                    }
                    this$NormalizedRecord[InputListEnumMaybeNormalized$Key] = InputListEnumMaybe$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumMaybe") && InputListEnumMaybe$cached != null){
                    this$NormalizedRecord[InputListEnumMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListEnumMaybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumMaybe$raw = data["InputListEnumMaybe"];
            final String? InputListEnumMaybe$value = 
    
        
            
                InputListEnumMaybe$raw as String?
            
        
    
;
        return InputListEnumMaybeResponse(
            InputListEnumMaybe: InputListEnumMaybe$value,
            
        );
    }
    static InputListEnumMaybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListEnumMaybe",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputListEnumMaybe")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumMaybeResponse &&
    
        
    
        other.InputListEnumMaybe == InputListEnumMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumMaybe':
            
                
    
        
            this.InputListEnumMaybe
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListEnumMaybe  {
        
    
    /// class members
    
        final String? InputListEnumMaybe;
    
    // keywordargs constructor
    InputListEnumMaybe({
    
        this.InputListEnumMaybe,
    
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
            final InputListEnumMaybeNormalized$Key = "InputListEnumMaybe";
            final InputListEnumMaybe$cached = this$NormalizedRecord[InputListEnumMaybeNormalized$Key];
            final InputListEnumMaybe$raw = data["InputListEnumMaybe"];
            if (InputListEnumMaybe$raw != null){
                
                    if (InputListEnumMaybe$cached != InputListEnumMaybe$raw){
                        
                    }
                    this$NormalizedRecord[InputListEnumMaybeNormalized$Key] = InputListEnumMaybe$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumMaybe") && InputListEnumMaybe$cached != null){
                    this$NormalizedRecord[InputListEnumMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListEnumMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumMaybe$raw = data["InputListEnumMaybe"];
            final String? InputListEnumMaybe$value = 
    
        
            
                InputListEnumMaybe$raw as String?
            
        
    
;
        return InputListEnumMaybe(
            InputListEnumMaybe: InputListEnumMaybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumMaybe &&
    
        
    
        other.InputListEnumMaybe == InputListEnumMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumMaybe':
            
                
    
        
            this.InputListEnumMaybe
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputListEnumMaybe extends Requestable {
    
    final InputListEnumMaybeVariables variables;
    

    RequestInputListEnumMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListEnumMaybe($foo: [Gender!]) {
  InputListEnumMaybe(foo: $foo)
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListEnumMaybe'
        );
    }
}


class InputListEnumMaybeVariables {
    
    
        final Option<List<Gender>?> foo;
    

    InputListEnumMaybeVariables (
        
            {
            

    
        
            this.foo = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (foo.isSome()) {
            final value = this.foo.some();
            data["foo"] = 
    
        
        
            value?.map((e) => 
    
        
            e.name
        
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputListEnumMaybeVariables updateWith(
    {
        
            
                Option<Option<List<Gender>?>> foo = const None()
            
            
        
    }
) {
    
        final Option<List<Gender>?> foo$next;
        
            switch (foo) {

                case Some(value: final updateData):
                    foo$next = updateData;
                case None():
                    foo$next = this.foo;
            }

        
    
    return InputListEnumMaybeVariables(
        
            foo: foo$next
            
        
    );
}


}
