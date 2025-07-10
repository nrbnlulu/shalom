





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;





class GetIntResponse  {

    /// class members
    
        final int intField;
    
    // keywordargs constructor
    GetIntResponse({
    required
        this.intField,
    
    });
    static GetIntResponse fromJson(JsonObject data) {
    
        
        final int intField_value;
        final intField$raw = data["intField"];
        intField_value = 
    
        
            
                intField$raw as int
            
        
    
;
    
    return GetIntResponse(
    
        
        intField: intField_value,
    
    );
    }
    GetIntResponse updateWithJson(JsonObject data) {
    
        
        final int intField_value;
        if (data.containsKey('intField')) {
            final intField$raw = data["intField"];
            intField_value = 
    
        
            
                intField$raw as int
            
        
    
;
        } else {
            intField_value = intField;
        }
    
    return GetIntResponse(
    
        
        intField: intField_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIntResponse &&
    
        
    
        other.intField == intField
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        intField.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intField':
            
                
    
        
            this.intField
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetInt extends Requestable {
    

    RequestGetInt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetInt {
  intField
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetInt'
        );
    }
}

