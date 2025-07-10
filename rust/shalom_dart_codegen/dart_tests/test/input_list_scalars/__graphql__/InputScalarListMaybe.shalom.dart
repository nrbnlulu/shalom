





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';





typedef JsonObject = Map<String, dynamic>;





class InputScalarListMaybeResponse {

    /// class members
    
        final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe;
    
    // keywordargs constructor
    InputScalarListMaybeResponse({
    
        this.InputScalarListMaybe,
    
    });
    static InputScalarListMaybeResponse fromJson(JsonObject data) {
    
        
        final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe_value;
        final InputScalarListMaybe$raw = data["InputScalarListMaybe"];
        InputScalarListMaybe_value = 
    
        
            InputScalarListMaybe$raw == null ? null : InputScalarListMaybe_InputScalarListMaybe.fromJson(InputScalarListMaybe$raw)
        
    
;
    
    return InputScalarListMaybeResponse(
    
        
        InputScalarListMaybe: InputScalarListMaybe_value,
    
    );
    }
    InputScalarListMaybeResponse updateWithJson(JsonObject data) {
    
        
        final InputScalarListMaybe_InputScalarListMaybe? InputScalarListMaybe_value;
        if (data.containsKey('InputScalarListMaybe')) {
            final InputScalarListMaybe$raw = data["InputScalarListMaybe"];
            InputScalarListMaybe_value = 
    
        
            InputScalarListMaybe$raw == null ? null : InputScalarListMaybe_InputScalarListMaybe.fromJson(InputScalarListMaybe$raw)
        
    
;
        } else {
            InputScalarListMaybe_value = InputScalarListMaybe;
        }
    
    return InputScalarListMaybeResponse(
    
        
        InputScalarListMaybe: InputScalarListMaybe_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListMaybeResponse &&
    
        
    
        other.InputScalarListMaybe == InputScalarListMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputScalarListMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'InputScalarListMaybe':
            
                
    
        
            this.InputScalarListMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputScalarListMaybe_InputScalarListMaybe   {
        
    /// class members
    
        final bool success;
    
    // keywordargs constructor
    InputScalarListMaybe_InputScalarListMaybe({
    required
        this.success,
    
    });
    static InputScalarListMaybe_InputScalarListMaybe fromJson(JsonObject data) {
    
        
        final bool success_value;
        final success$raw = data["success"];
        success_value = 
    
        
            
                success$raw as bool
            
        
    
;
    
    return InputScalarListMaybe_InputScalarListMaybe(
    
        
        success: success_value,
    
    );
    }
    InputScalarListMaybe_InputScalarListMaybe updateWithJson(JsonObject data) {
    
        
        final bool success_value;
        if (data.containsKey('success')) {
            final success$raw = data["success"];
            success_value = 
    
        
            
                success$raw as bool
            
        
    
;
        } else {
            success_value = success;
        }
    
    return InputScalarListMaybe_InputScalarListMaybe(
    
        
        success: success_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputScalarListMaybe_InputScalarListMaybe &&
    
        
    
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


class RequestInputScalarListMaybe extends Requestable {
    
    final InputScalarListMaybeVariables variables;
    

    RequestInputScalarListMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputScalarListMaybe($ints: [Int]) {
  InputScalarListMaybe(ints: $ints) {
    success
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputScalarListMaybe'
        );
    }
}


class InputScalarListMaybeVariables {
    
    
        final Option<List<int?>?> ints;
    

    InputScalarListMaybeVariables (
        
            {
            

    
        
            this.ints = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (ints.isSome()) {
            final value = this.ints.some();
            data["ints"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputScalarListMaybeVariables updateWith(
    {
        
            
                Option<Option<List<int?>?>> ints = const None()
            
            
        
    }
) {
    
        final Option<List<int?>?> ints$next;
        
            switch (ints) {

                case Some(value: final updateData):
                    ints$next = updateData;
                case None():
                    ints$next = this.ints;
            }

        
    
    return InputScalarListMaybeVariables(
        
            ints: ints$next
            
        
    );
}


}
