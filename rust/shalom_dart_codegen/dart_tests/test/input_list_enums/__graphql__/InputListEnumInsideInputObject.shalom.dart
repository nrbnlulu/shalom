









// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListEnumInsideInputObjectResponse{

    /// class members
    
        
            final String? InputListEnumInsideInputObject;
        
    
    // keywordargs constructor
    InputListEnumInsideInputObjectResponse({
    
        this.InputListEnumInsideInputObject,
    
    });
    static InputListEnumInsideInputObjectResponse fromJson(JsonObject data) {
    
        
           final String? InputListEnumInsideInputObject_value;
           
               
                   InputListEnumInsideInputObject_value = data['InputListEnumInsideInputObject'];
               
           

        
    
    return InputListEnumInsideInputObjectResponse(
    
        
        InputListEnumInsideInputObject: InputListEnumInsideInputObject_value,
    
    );
    }
    InputListEnumInsideInputObjectResponse updateWithJson(JsonObject data) {
    
        
    final String? InputListEnumInsideInputObject_value;
    if (data.containsKey('InputListEnumInsideInputObject')) {
        
            InputListEnumInsideInputObject_value = data['InputListEnumInsideInputObject'];
        
    } else {
        InputListEnumInsideInputObject_value = InputListEnumInsideInputObject;
    }

        
    
    return InputListEnumInsideInputObjectResponse(
    
        
        InputListEnumInsideInputObject: InputListEnumInsideInputObject_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListEnumInsideInputObjectResponse &&
    
        other.InputListEnumInsideInputObject == InputListEnumInsideInputObject 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListEnumInsideInputObject.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputListEnumInsideInputObject':
            
                
                    InputListEnumInsideInputObject
                
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestInputListEnumInsideInputObject extends Requestable {
    
    final InputListEnumInsideInputObjectVariables variables;
    

    RequestInputListEnumInsideInputObject(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListEnumInsideInputObject($input: ObjectWithListOfInput!) {
  InputListEnumInsideInputObject(input: $input)
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'InputListEnumInsideInputObject'
        );
    }
}


class InputListEnumInsideInputObjectVariables {
    
    
        final ObjectWithListOfInput input;
    

    InputListEnumInsideInputObjectVariables (
        
            {
            

    
        
            required this.input
        ,
    
    
 
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
        
    
        
            
                 data["input"] = input.toJson();
            
        
    

    
        return data;
    } 

    
InputListEnumInsideInputObjectVariables updateWith(
    {
        
            
                ObjectWithListOfInput? input
            
            
        
    }
) {
    
        final ObjectWithListOfInput input$next;
        
            if (input != null) {
                input$next = input;
            } else {
                input$next = this.input;
            }
        
    
    return InputListEnumInsideInputObjectVariables(
        
            input: input$next
            
        
    );
}


}
