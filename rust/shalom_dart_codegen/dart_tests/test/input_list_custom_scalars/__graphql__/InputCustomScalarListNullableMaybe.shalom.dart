





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListNullableMaybeResponse {

    /// class members
    
        final InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe? InputCustomScalarListNullableMaybe;
    
    // keywordargs constructor
    InputCustomScalarListNullableMaybeResponse({
    
        this.InputCustomScalarListNullableMaybe,
    
    });
    static InputCustomScalarListNullableMaybeResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe? InputCustomScalarListNullableMaybe_value;
        final InputCustomScalarListNullableMaybe$raw = data["InputCustomScalarListNullableMaybe"];
        InputCustomScalarListNullableMaybe_value = 
    
           
            
                InputCustomScalarListNullableMaybe$raw == null ? null : InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe.fromJson(InputCustomScalarListNullableMaybe$raw, context)
            
        
    
;
    
    return InputCustomScalarListNullableMaybeResponse(
    
        
        InputCustomScalarListNullableMaybe: InputCustomScalarListNullableMaybe_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListNullableMaybeResponse &&
    
        
    
        other.InputCustomScalarListNullableMaybe == InputCustomScalarListNullableMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListNullableMaybe.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListNullableMaybe':
            
                
    
        
            this.InputCustomScalarListNullableMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe  {
        
    /// class members
    
        final bool success;
    
        final String? message;
    
    // keywordargs constructor
    InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe({
    required
        this.success,
    
        this.message,
    
    });
    static InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe fromJson(JsonObject data, ShalomContext? context) {
    
        
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
    
    return InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe(
    
        
        success: success_value,
    
        
        message: message_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListNullableMaybe_InputCustomScalarListNullableMaybe &&
    
        
    
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


class RequestInputCustomScalarListNullableMaybe extends Requestable {
    
    final InputCustomScalarListNullableMaybeVariables variables;
    

    RequestInputCustomScalarListNullableMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListNullableMaybe($sparseData: [Point]) {
  InputCustomScalarListNullableMaybe(sparseData: $sparseData) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListNullableMaybe'
        );
    }
}


class InputCustomScalarListNullableMaybeVariables {
    
    
        final Option<List<rmhlxei.Point?>?> sparseData;
    

    InputCustomScalarListNullableMaybeVariables (
        
            {
            

    
        
            this.sparseData = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (sparseData.isSome()) {
            final value = this.sparseData.some();
            data["sparseData"] = 
    
        
        
            value?.map((e) => 
    
        
        
            e == null ? null : rmhlxei.pointScalarImpl.serialize(e!)
        
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputCustomScalarListNullableMaybeVariables updateWith(
    {
        
            
                Option<Option<List<rmhlxei.Point?>?>> sparseData = const None()
            
            
        
    }
) {
    
        final Option<List<rmhlxei.Point?>?> sparseData$next;
        
            switch (sparseData) {

                case Some(value: final updateData):
                    sparseData$next = updateData;
                case None():
                    sparseData$next = this.sparseData;
            }

        
    
    return InputCustomScalarListNullableMaybeVariables(
        
            sparseData: sparseData$next
            
        
    );
}


}
