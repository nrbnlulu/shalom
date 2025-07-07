
























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

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
    static InputScalarListOptionalResponse fromJson(JsonObject data) {
    
        
        final InputScalarListOptional_InputScalarListOptional? InputScalarListOptional_value;
        
            InputScalarListOptional_value = 
    
        
            data["InputScalarListOptional"] == null ? null : InputScalarListOptional_InputScalarListOptional.fromJson(data["InputScalarListOptional"])
        
    
;
        
    
    return InputScalarListOptionalResponse(
    
        
        InputScalarListOptional: InputScalarListOptional_value,
    
    );
    }
    InputScalarListOptionalResponse updateWithJson(JsonObject data) {
    
        
        final InputScalarListOptional_InputScalarListOptional? InputScalarListOptional_value;
        if (data.containsKey('InputScalarListOptional')) {
            
                InputScalarListOptional_value = 
    
        
            data["InputScalarListOptional"] == null ? null : InputScalarListOptional_InputScalarListOptional.fromJson(data["InputScalarListOptional"])
        
    
;
            
        } else {
            InputScalarListOptional_value = InputScalarListOptional;
        }
    
    return InputScalarListOptionalResponse(
    
        
        InputScalarListOptional: InputScalarListOptional_value,
    
    );
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


    class InputScalarListOptional_InputScalarListOptional  {
        
    /// class members
    
        final bool success;
    
    // keywordargs constructor
    InputScalarListOptional_InputScalarListOptional({
    required
        this.success,
    
    });
    static InputScalarListOptional_InputScalarListOptional fromJson(JsonObject data) {
    
        
        final bool success_value;
        
            success_value = 
    
        
            
                data["success"] as 
    bool

            
        
    
;
        
    
    return InputScalarListOptional_InputScalarListOptional(
    
        
        success: success_value,
    
    );
    }
    InputScalarListOptional_InputScalarListOptional updateWithJson(JsonObject data) {
    
        
        final bool success_value;
        if (data.containsKey('success')) {
            
                success_value = 
    
        
            
                data["success"] as 
    bool

            
        
    
;
            
        } else {
            success_value = success;
        }
    
    return InputScalarListOptional_InputScalarListOptional(
    
        
        success: success_value,
    
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
            StringopName: 'InputScalarListOptional'
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
