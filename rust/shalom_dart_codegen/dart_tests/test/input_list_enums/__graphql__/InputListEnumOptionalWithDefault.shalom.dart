






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListEnumOptionalWithDefaultResponse{

    
    /// class members
    
        final String? InputListEnumOptionalWithDefault;
    
    // keywordargs constructor
    InputListEnumOptionalWithDefaultResponse({
    
        this.InputListEnumOptionalWithDefault,
    
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
            final InputListEnumOptionalWithDefaultNormalized$Key = "InputListEnumOptionalWithDefault";
            final InputListEnumOptionalWithDefault$cached = this$NormalizedRecord[InputListEnumOptionalWithDefaultNormalized$Key];
            final InputListEnumOptionalWithDefault$raw = data["InputListEnumOptionalWithDefault"];
            if (InputListEnumOptionalWithDefault$raw != null){
                
                    if (InputListEnumOptionalWithDefault$cached != InputListEnumOptionalWithDefault$raw){
                        
                    }
                    this$NormalizedRecord[InputListEnumOptionalWithDefaultNormalized$Key] = InputListEnumOptionalWithDefault$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumOptionalWithDefault") && InputListEnumOptionalWithDefault$cached != null){
                    this$NormalizedRecord[InputListEnumOptionalWithDefaultNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListEnumOptionalWithDefaultResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumOptionalWithDefault$raw = data["InputListEnumOptionalWithDefault"];
            final String? InputListEnumOptionalWithDefault$value = 
    
        
            
                InputListEnumOptionalWithDefault$raw as String?
            
        
    
;
        return InputListEnumOptionalWithDefaultResponse(
            InputListEnumOptionalWithDefault: InputListEnumOptionalWithDefault$value,
            
        );
    }
    static InputListEnumOptionalWithDefaultResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "InputListEnumOptionalWithDefault",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "InputListEnumOptionalWithDefault")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumOptionalWithDefaultResponse &&
    
        
    
        other.InputListEnumOptionalWithDefault == InputListEnumOptionalWithDefault
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumOptionalWithDefault.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumOptionalWithDefault':
            
                
    
        
            this.InputListEnumOptionalWithDefault
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListEnumOptionalWithDefault  {
        
    
    /// class members
    
        final String? InputListEnumOptionalWithDefault;
    
    // keywordargs constructor
    InputListEnumOptionalWithDefault({
    
        this.InputListEnumOptionalWithDefault,
    
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
            final InputListEnumOptionalWithDefaultNormalized$Key = "InputListEnumOptionalWithDefault";
            final InputListEnumOptionalWithDefault$cached = this$NormalizedRecord[InputListEnumOptionalWithDefaultNormalized$Key];
            final InputListEnumOptionalWithDefault$raw = data["InputListEnumOptionalWithDefault"];
            if (InputListEnumOptionalWithDefault$raw != null){
                
                    if (InputListEnumOptionalWithDefault$cached != InputListEnumOptionalWithDefault$raw){
                        
                    }
                    this$NormalizedRecord[InputListEnumOptionalWithDefaultNormalized$Key] = InputListEnumOptionalWithDefault$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("InputListEnumOptionalWithDefault") && InputListEnumOptionalWithDefault$cached != null){
                    this$NormalizedRecord[InputListEnumOptionalWithDefaultNormalized$Key] = null;
                    
                }
            }

        
    }

    static InputListEnumOptionalWithDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final InputListEnumOptionalWithDefault$raw = data["InputListEnumOptionalWithDefault"];
            final String? InputListEnumOptionalWithDefault$value = 
    
        
            
                InputListEnumOptionalWithDefault$raw as String?
            
        
    
;
        return InputListEnumOptionalWithDefault(
            InputListEnumOptionalWithDefault: InputListEnumOptionalWithDefault$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumOptionalWithDefault &&
    
        
    
        other.InputListEnumOptionalWithDefault == InputListEnumOptionalWithDefault
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumOptionalWithDefault.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumOptionalWithDefault':
            
                
    
        
            this.InputListEnumOptionalWithDefault
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestInputListEnumOptionalWithDefault extends Requestable {
    
    final InputListEnumOptionalWithDefaultVariables variables;
    

    RequestInputListEnumOptionalWithDefault(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListEnumOptionalWithDefault($foo: [Gender!] = null) {
  InputListEnumOptionalWithDefault(foo: $foo)
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListEnumOptionalWithDefault'
        );
    }
}


class InputListEnumOptionalWithDefaultVariables {
    
    
        final List<Gender>? foo;
    

    InputListEnumOptionalWithDefaultVariables (
        
            {
            

    
        
            
            
                this.foo
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["foo"] = 
    
        
        
            this.foo?.map((e) => 
    
        
            e.name
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputListEnumOptionalWithDefaultVariables updateWith(
    {
        
            
                Option<List<Gender>?> foo = const None()
            
            
        
    }
) {
    
        final List<Gender>? foo$next;
        
            switch (foo) {

                case Some(value: final updateData):
                    foo$next = updateData;
                case None():
                    foo$next = this.foo;
            }

        
    
    return InputListEnumOptionalWithDefaultVariables(
        
            foo: foo$next
            
        
    );
}


}
