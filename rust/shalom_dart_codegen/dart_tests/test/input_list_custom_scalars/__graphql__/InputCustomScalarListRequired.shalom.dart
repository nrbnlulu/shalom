





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListRequiredResponse {

    /// class members
    
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired;
    
    // keywordargs constructor
    InputCustomScalarListRequiredResponse({
    
        this.InputCustomScalarListRequired,
    
    });
    static InputCustomScalarListRequiredResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired_value;
        final InputCustomScalarListRequired$raw = data["InputCustomScalarListRequired"];
        InputCustomScalarListRequired_value = 
    
           
            
                InputCustomScalarListRequired$raw == null ? null : InputCustomScalarListRequired_InputCustomScalarListRequired.fromJson(InputCustomScalarListRequired$raw, context)
            
        
    
;
    
    return InputCustomScalarListRequiredResponse(
    
        
        InputCustomScalarListRequired: InputCustomScalarListRequired_value,
    
    );
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
    static InputCustomScalarListRequired_InputCustomScalarListRequired fromJson(JsonObject data, ShalomContext? context) {
    
        
        final bool success_value;
        final success$raw = data["success"];
        success_value = 
    
        
            
                success$raw as bool
            
        
    
;
    
        
        final String? message_value;
        final message$raw = data["message"];
        message_value = 
    
        
            
                message$raw as String?
            
        
    
;
    
    return InputCustomScalarListRequired_InputCustomScalarListRequired(
    
        
        success: success_value,
    
        
        message: message_value,
    
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
