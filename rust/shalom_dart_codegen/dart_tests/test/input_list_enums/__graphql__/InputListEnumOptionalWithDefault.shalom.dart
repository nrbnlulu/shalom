









// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListEnumOptionalWithDefaultResponse{

    /// class members
    
        
            final String? InputListEnumOptionalWithDefault;
        
    
    // keywordargs constructor
    InputListEnumOptionalWithDefaultResponse({
    
        this.InputListEnumOptionalWithDefault,
    
    });
    static InputListEnumOptionalWithDefaultResponse fromJson(JsonObject data) {
    
        
           final String? InputListEnumOptionalWithDefault_value;
           
               
                   InputListEnumOptionalWithDefault_value = data['InputListEnumOptionalWithDefault'];
               
           

        
    
    return InputListEnumOptionalWithDefaultResponse(
    
        
        InputListEnumOptionalWithDefault: InputListEnumOptionalWithDefault_value,
    
    );
    }
    InputListEnumOptionalWithDefaultResponse updateWithJson(JsonObject data) {
    
        
    final String? InputListEnumOptionalWithDefault_value;
    if (data.containsKey('InputListEnumOptionalWithDefault')) {
        
            InputListEnumOptionalWithDefault_value = data['InputListEnumOptionalWithDefault'];
        
    } else {
        InputListEnumOptionalWithDefault_value = InputListEnumOptionalWithDefault;
    }

        
    
    return InputListEnumOptionalWithDefaultResponse(
    
        
        InputListEnumOptionalWithDefault: InputListEnumOptionalWithDefault_value,
    
    );
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
            
                
                    InputListEnumOptionalWithDefault
                
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



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
            StringopName: 'InputListEnumOptionalWithDefault'
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
        

    
        
    
        
            
            
                
                    data["foo"] = foo?.map((e) => e.name).toList();
                
            
        
    

    
        return data;
    } 

    
InputListEnumOptionalWithDefaultVariables updateWith(
    {
        
            
                Option<List<Gender>?> foo = const None()
            
            
        
    }
) {
    
        final List<Gender>? foo$next;
        
            switch (foo) {

                case Some(value: final data):
                    foo$next = data;
                case None():
                    foo$next = this.foo;
            }

        
    
    return InputListEnumOptionalWithDefaultVariables(
        
            foo: foo$next
            
        
    );
}


}
