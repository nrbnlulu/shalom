





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class InputListOfRequiredObjectsResponse {

    /// class members
    
        
        InputListOfRequiredObjects_InputListOfRequiredObjects? InputListOfRequiredObjects;
        
    
    // keywordargs constructor
    InputListOfRequiredObjectsResponse({
    
        
        
        this.InputListOfRequiredObjects,
        
    
    });
    static InputListOfRequiredObjectsResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final InputListOfRequiredObjects_InputListOfRequiredObjects? InputListOfRequiredObjects_value;
        final InputListOfRequiredObjects$raw = data["InputListOfRequiredObjects"];
        
        InputListOfRequiredObjects_value = 
    
       
            InputListOfRequiredObjects$raw == null ? null : InputListOfRequiredObjects_InputListOfRequiredObjects.fromJson(InputListOfRequiredObjects$raw, context)
         
    
;
        
    
    return InputListOfRequiredObjectsResponse(
    
        
        InputListOfRequiredObjects: InputListOfRequiredObjects_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfRequiredObjectsResponse &&
    
        
    
        other.InputListOfRequiredObjects == InputListOfRequiredObjects
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        InputListOfRequiredObjects.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'InputListOfRequiredObjects':
            
                
    
        
            this.InputListOfRequiredObjects?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class InputListOfRequiredObjects_InputListOfRequiredObjects  {
        
    /// class members
    
        
        bool success;
        
    
        
        String? message;
        
    
    // keywordargs constructor
    InputListOfRequiredObjects_InputListOfRequiredObjects({
    
        required
        
        this.success,
        
    
        
        
        this.message,
        
    
    });
    static InputListOfRequiredObjects_InputListOfRequiredObjects fromJson(JsonObject data, ShalomContext? context) {
    
        
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
        
    
    return InputListOfRequiredObjects_InputListOfRequiredObjects(
    
        
        success: success_value,
    
        
        message: message_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is InputListOfRequiredObjects_InputListOfRequiredObjects &&
    
        
    
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


class RequestInputListOfRequiredObjects extends Requestable {
    
    final InputListOfRequiredObjectsVariables variables;
    

    RequestInputListOfRequiredObjects(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation InputListOfRequiredObjects($items: [MyInputObject!]!) {
  InputListOfRequiredObjects(items: $items) {
    success
    message
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'InputListOfRequiredObjects'
        );
    }
}


class InputListOfRequiredObjectsVariables {
    
    
        final List<MyInputObject> items;
    

    InputListOfRequiredObjectsVariables (
        
            {
            

    
        
            required this.items
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["items"] = 
    
        
        
            this.items.map((e) => 
    
        
            e.toJson()
        
    
).toList()
        
    
;
    


        return data;
    }

    
InputListOfRequiredObjectsVariables updateWith(
    {
        
            
                List<MyInputObject>? items
            
            
        
    }
) {
    
        final List<MyInputObject> items$next;
        
            if (items != null) {
                items$next = items;
            } else {
                items$next = this.items;
            }
        
    
    return InputListOfRequiredObjectsVariables(
        
            items: items$next
            
        
    );
}


}
