





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputScalarInsideInputTypeResponse {

    /// class members
    
            
            final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType;
        
    
    // keywordargs constructor
    InputScalarInsideInputTypeResponse({
    
        this.InputScalarInsideInputType,
    
    });
    static InputScalarInsideInputTypeResponse fromJson(JsonObject data) {
    
        
        final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType_value;
        final InputScalarInsideInputType$raw = data["InputScalarInsideInputType"];
        InputScalarInsideInputType_value = 
    
        
            InputScalarInsideInputType$raw == null ? null : InputScalarInsideInputType_InputScalarInsideInputType.fromJson(InputScalarInsideInputType$raw)
        
    
;
    
    return InputScalarInsideInputTypeResponse(
    
        
        InputScalarInsideInputType: InputScalarInsideInputType_value,
    
    );
    }
    
    
        InputScalarInsideInputTypeResponse updateWithJson(JsonObject data) {
        
            
            final InputScalarInsideInputType_InputScalarInsideInputType? InputScalarInsideInputType_value;
            if (data.containsKey('InputScalarInsideInputType')) {
                final InputScalarInsideInputType$raw = data["InputScalarInsideInputType"];
                InputScalarInsideInputType_value = 
    
        
            InputScalarInsideInputType$raw == null ? null : InputScalarInsideInputType_InputScalarInsideInputType.fromJson(InputScalarInsideInputType$raw)
        
    
;
            } else {
                InputScalarInsideInputType_value = InputScalarInsideInputType;
            }
        
        return InputScalarInsideInputTypeResponse(
        
            
            InputScalarInsideInputType: InputScalarInsideInputType_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarInsideInputTypeResponse &&
    
        
    
        other.InputScalarInsideInputType == InputScalarInsideInputType
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarInsideInputType.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'InputScalarInsideInputType':
            
                
    
        
            this.InputScalarInsideInputType?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputScalarInsideInputType_InputScalarInsideInputType  {
        
    /// class members
    
            
            final bool success;
        
    
    // keywordargs constructor
    InputScalarInsideInputType_InputScalarInsideInputType({
    required
        this.success,
    
    });
    static InputScalarInsideInputType_InputScalarInsideInputType fromJson(JsonObject data) {
    
        
        final bool success_value;
        final success$raw = data["success"];
        success_value = 
    
        
            
                success$raw as bool
            
        
    
;
    
    return InputScalarInsideInputType_InputScalarInsideInputType(
    
        
        success: success_value,
    
    );
    }
    
    
        InputScalarInsideInputType_InputScalarInsideInputType updateWithJson(JsonObject data) {
        
            
            final bool success_value;
            if (data.containsKey('success')) {
                final success$raw = data["success"];
                success_value = 
    
        
            
                success$raw as bool
            
        
    
;
            } else {
                success_value = success;
            }
        
        return InputScalarInsideInputType_InputScalarInsideInputType(
        
            
            success: success_value,
        
        );
        }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarInsideInputType_InputScalarInsideInputType &&
    
        
    
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


class RequestInputScalarInsideInputType extends Requestable {
    
    final InputScalarInsideInputTypeVariables variables;
    

    RequestInputScalarInsideInputType(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputScalarInsideInputType($user: UserInput!) {
  InputScalarInsideInputType(user: $user) {
    success
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputScalarInsideInputType'
        );
    }
}


class InputScalarInsideInputTypeVariables {
    
    
        final UserInput user;
    

    InputScalarInsideInputTypeVariables (
        
            {
            

    
        
            required this.user
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["user"] = 
    
        
            this.user.toJson()
        
    
;
    


        return data;
    }

    
InputScalarInsideInputTypeVariables updateWith(
    {
        
            
                UserInput? user
            
            
        
    }
) {
    
        final UserInput user$next;
        
            if (user != null) {
                user$next = user;
            } else {
                user$next = this.user;
            }
        
    
    return InputScalarInsideInputTypeVariables(
        
            user: user$next
            
        
    );
}


}
