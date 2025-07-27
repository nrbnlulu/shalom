





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputCustomScalarListMaybeResponse {

    /// class members
    
        
        InputCustomScalarListMaybe_InputCustomScalarListMaybe? InputCustomScalarListMaybe;
        
    
    // keywordargs constructor
    InputCustomScalarListMaybeResponse({
    
        
        
        this.InputCustomScalarListMaybe,
        
    
    });
    static InputCustomScalarListMaybeResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final InputCustomScalarListMaybe_InputCustomScalarListMaybe? InputCustomScalarListMaybe_value;
        final InputCustomScalarListMaybe$raw = data["InputCustomScalarListMaybe"];
        
        InputCustomScalarListMaybe_value = 
    
       
            InputCustomScalarListMaybe$raw == null ? null : InputCustomScalarListMaybe_InputCustomScalarListMaybe.fromJson(InputCustomScalarListMaybe$raw, context)
         
    
;
        
    
    return InputCustomScalarListMaybeResponse(
    
        
        InputCustomScalarListMaybe: InputCustomScalarListMaybe_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListMaybeResponse &&
    
        
    
        other.InputCustomScalarListMaybe == InputCustomScalarListMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputCustomScalarListMaybe.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'InputCustomScalarListMaybe':
            
                
    
        
            this.InputCustomScalarListMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputCustomScalarListMaybe_InputCustomScalarListMaybe  {
        
    /// class members
    
        
        bool success;
        
    
        
        String? message;
        
    
    // keywordargs constructor
    InputCustomScalarListMaybe_InputCustomScalarListMaybe({
    
        required
        
        this.success,
        
    
        
        
        this.message,
        
    
    });
    static InputCustomScalarListMaybe_InputCustomScalarListMaybe fromJson(JsonObject data, ShalomContext? context) {
    
        
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
        
    
    return InputCustomScalarListMaybe_InputCustomScalarListMaybe(
    
        
        success: success_value,
    
        
        message: message_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputCustomScalarListMaybe_InputCustomScalarListMaybe &&
    
        
    
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


class RequestInputCustomScalarListMaybe extends Requestable {
    
    final InputCustomScalarListMaybeVariables variables;
    

    RequestInputCustomScalarListMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputCustomScalarListMaybe($optionalItems: [Point!]) {
  InputCustomScalarListMaybe(optionalItems: $optionalItems) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputCustomScalarListMaybe'
        );
    }
}


class InputCustomScalarListMaybeVariables {
    
    
        final Option<List<rmhlxei.Point>?> optionalItems;
    

    InputCustomScalarListMaybeVariables (
        
            {
            

    
        
            this.optionalItems = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (optionalItems.isSome()) {
            final value = this.optionalItems.some();
            data["optionalItems"] = 
    
        
        
            value?.map((e) => 
    
        
        
            rmhlxei.pointScalarImpl.serialize(e)
        
    
).toList()
        
    
;
        }
    


        return data;
    }

    
InputCustomScalarListMaybeVariables updateWith(
    {
        
            
                Option<Option<List<rmhlxei.Point>?>> optionalItems = const None()
            
            
        
    }
) {
    
        final Option<List<rmhlxei.Point>?> optionalItems$next;
        
            switch (optionalItems) {

                case Some(value: final updateData):
                    optionalItems$next = updateData;
                case None():
                    optionalItems$next = this.optionalItems;
            }

        
    
    return InputCustomScalarListMaybeVariables(
        
            optionalItems: optionalItems$next
            
        
    );
}


}
