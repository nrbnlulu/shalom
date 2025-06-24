













// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class setColorsRootResponse{

    /// class members
    
        
            final bool setColorsRoot;
        
    
    // keywordargs constructor
    setColorsRootResponse({
    required
        this.setColorsRoot,
    
    });
    static setColorsRootResponse fromJson(JsonObject data) {
    
        
            final bool setColorsRoot_value;
            
                setColorsRoot_value = data['setColorsRoot'];
            

        
    
    return setColorsRootResponse(
    
        
        setColorsRoot: setColorsRoot_value,
    
    );
    }
    setColorsRootResponse updateWithJson(JsonObject data) {
    
        
    final bool setColorsRoot_value;
    if (data.containsKey('setColorsRoot')) {
        
            setColorsRoot_value = data['setColorsRoot'];
        
    } else {
        setColorsRoot_value = setColorsRoot;
    }

        
    
    return setColorsRootResponse(
    
        
        setColorsRoot: setColorsRoot_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is setColorsRootResponse &&
    
        other.setColorsRoot == setColorsRoot 
    
    );
    }
    @override
    int get hashCode =>
    
        setColorsRoot.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'setColorsRoot':
            
                
                    setColorsRoot
                
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestsetColorsRoot extends Requestable {
    
    final setColorsRootVariables variables;
    

    RequestsetColorsRoot(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation setColorsRoot($colors: [Color!]!) {
  setColorsRoot(colors: $colors)
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'setColorsRoot'
        );
    }
}


class setColorsRootVariables {
    
    
        final List<Color> colors;
    

    setColorsRootVariables (
        
            {
            

    
        
            required this.colors  
        ,
    
      
 
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    

    
    
        
            data["colors"] = colors.map((e) => e.name).toList();
        
    

    
        return data;
    } 

    
setColorsRootVariables updateWith(
    {
        
            
                List<Color>? colors
            
            
        
    }
) {
    
        final List<Color> colors$next;
        
            if (colors != null) {
                colors$next = colors;
            } else {
                colors$next = this.colors;
            }
        
    
    return setColorsRootVariables(
        
            colors: colors$next
            
        
    );
}


}
