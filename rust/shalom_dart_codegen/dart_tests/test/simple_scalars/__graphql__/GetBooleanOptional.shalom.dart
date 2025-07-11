





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetBooleanOptionalResponse {

    /// class members
    
            
            final bool? booleanOptional;
        
    
    // keywordargs constructor
    GetBooleanOptionalResponse({
    
        this.booleanOptional,
    
    });
    
    
        GetBooleanOptionalResponse updateWithJson(JsonObject data) {
        
            
            final bool? booleanOptional_value;
            if (data.containsKey('booleanOptional')) {
                final booleanOptional$raw = data["booleanOptional"];
                booleanOptional_value = 
    
        
            
                booleanOptional$raw as bool?
            
        
    
;
            } else {
                booleanOptional_value = booleanOptional;
            }
        
        return GetBooleanOptionalResponse(
        
            
            booleanOptional: booleanOptional_value,
        
        );
        }
    
    static GetBooleanOptionalResponse fromJson(JsonObject data) {
    
        
        final bool? booleanOptional_value;
        final booleanOptional$raw = data["booleanOptional"];
        booleanOptional_value = 
    
        
            
                booleanOptional$raw as bool?
            
        
    
;
    
    return GetBooleanOptionalResponse(
    
        
        booleanOptional: booleanOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanOptionalResponse &&
    
        
    
        other.booleanOptional == booleanOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        booleanOptional.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'booleanOptional':
            
                
    
        
            this.booleanOptional
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetBooleanOptional extends Requestable {
    

    RequestGetBooleanOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetBooleanOptional {
  booleanOptional
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetBooleanOptional'
        );
    }
}

