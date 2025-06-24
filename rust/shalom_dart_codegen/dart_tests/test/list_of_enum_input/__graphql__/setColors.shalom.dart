













// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class setColorsResponse{

    /// class members
    
        
            final bool setColors;
        
    
    // keywordargs constructor
    setColorsResponse({
    required
        this.setColors,
    
    });
    static setColorsResponse fromJson(JsonObject data) {
    
        
            final bool setColors_value;
            
                setColors_value = data['setColors'];
            

        
    
    return setColorsResponse(
    
        
        setColors: setColors_value,
    
    );
    }
    setColorsResponse updateWithJson(JsonObject data) {
    
        
    final bool setColors_value;
    if (data.containsKey('setColors')) {
        
            setColors_value = data['setColors'];
        
    } else {
        setColors_value = setColors;
    }

        
    
    return setColorsResponse(
    
        
        setColors: setColors_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is setColorsResponse &&
    
        other.setColors == setColors 
    
    );
    }
    @override
    int get hashCode =>
    
        setColors.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'setColors':
            
                
                    setColors
                
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestsetColors extends Requestable {
    
    final setColorsVariables variables;
    

    RequestsetColors(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation setColors($input: ListOfEnumInput!) {
  setColors(input: $input)
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'setColors'
        );
    }
}


class setColorsVariables {
    
    
        final ListOfEnumInput input;
    

    setColorsVariables (
        
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

    
setColorsVariables updateWith(
    {
        
            
                ListOfEnumInput? input
            
            
        
    }
) {
    
        final ListOfEnumInput input$next;
        
            if (input != null) {
                input$next = input;
            } else {
                input$next = this.input;
            }
        
    
    return setColorsVariables(
        
            input: input$next
            
        
    );
}


}
