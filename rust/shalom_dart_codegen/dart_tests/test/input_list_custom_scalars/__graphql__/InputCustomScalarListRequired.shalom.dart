
























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListRequiredResponse{

    /// class members
    
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired;
    
    // keywordargs constructor
    InputCustomScalarListRequiredResponse({
    
        this.InputCustomScalarListRequired,
    
    });
    static InputCustomScalarListRequiredResponse fromJson(JsonObject data) {
    
        
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired_value;
        
            InputCustomScalarListRequired_value = 
    
        
            data["InputCustomScalarListRequired"] == null ? null : InputCustomScalarListRequired_InputCustomScalarListRequired.fromJson(data["InputCustomScalarListRequired"])
        
    
;
        
    
    return InputCustomScalarListRequiredResponse(
    
        
        InputCustomScalarListRequired: InputCustomScalarListRequired_value,
    
    );
    }
    InputCustomScalarListRequiredResponse updateWithJson(JsonObject data) {
    
        
        final InputCustomScalarListRequired_InputCustomScalarListRequired? InputCustomScalarListRequired_value;
        if (data.containsKey('InputCustomScalarListRequired')) {
            
                InputCustomScalarListRequired_value = 
    
        
            data["InputCustomScalarListRequired"] == null ? null : InputCustomScalarListRequired_InputCustomScalarListRequired.fromJson(data["InputCustomScalarListRequired"])
        
    
;
            
        } else {
            InputCustomScalarListRequired_value = InputCustomScalarListRequired;
        }
    
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
    static InputCustomScalarListRequired_InputCustomScalarListRequired fromJson(JsonObject data) {
    
        
        final bool success_value;
        
            success_value = 
    
        
            
                data["success"] as 
    bool

            
        
    
;
        
    
        
        final String? message_value;
        
            message_value = 
    
        
            
                data["message"] as 
    String
?
            
        
    
;
        
    
    return InputCustomScalarListRequired_InputCustomScalarListRequired(
    
        
        success: success_value,
    
        
        message: message_value,
    
    );
    }
    InputCustomScalarListRequired_InputCustomScalarListRequired updateWithJson(JsonObject data) {
    
        
        final bool success_value;
        if (data.containsKey('success')) {
            
                success_value = 
    
        
            
                data["success"] as 
    bool

            
        
    
;
            
        } else {
            success_value = success;
        }
    
        
        final String? message_value;
        if (data.containsKey('message')) {
            
                message_value = 
    
        
            
                data["message"] as 
    String
?
            
        
    
;
            
        } else {
            message_value = message;
        }
    
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
            StringopName: 'InputCustomScalarListRequired'
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
