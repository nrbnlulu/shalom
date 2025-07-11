





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetStringOptionalResponse {

    /// class members
    
            
            final String? stringOptional;
        
    
    // keywordargs constructor
    GetStringOptionalResponse({
    
        this.stringOptional,
    
    });
    
    
        GetStringOptionalResponse updateWithJson(JsonObject data) {
        
            
            final String? stringOptional_value;
            if (data.containsKey('stringOptional')) {
                final stringOptional$raw = data["stringOptional"];
                stringOptional_value = 
    
        
            
                stringOptional$raw as String?
            
        
    
;
            } else {
                stringOptional_value = stringOptional;
            }
        
        return GetStringOptionalResponse(
        
            
            stringOptional: stringOptional_value,
        
        );
        }
    
    static GetStringOptionalResponse fromJson(JsonObject data) {
    
        
        final String? stringOptional_value;
        final stringOptional$raw = data["stringOptional"];
        stringOptional_value = 
    
        
            
                stringOptional$raw as String?
            
        
    
;
    
    return GetStringOptionalResponse(
    
        
        stringOptional: stringOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetStringOptionalResponse &&
    
        
    
        other.stringOptional == stringOptional
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        stringOptional.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'stringOptional':
            
                
    
        
            this.stringOptional
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetStringOptional extends Requestable {
    

    RequestGetStringOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetStringOptional {
  stringOptional
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetStringOptional'
        );
    }
}

