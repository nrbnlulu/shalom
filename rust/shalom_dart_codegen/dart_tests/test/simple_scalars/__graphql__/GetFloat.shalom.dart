





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;





class GetFloatResponse  {

    /// class members
    
        final double float;
    
    // keywordargs constructor
    GetFloatResponse({
    required
        this.float,
    
    });
    static GetFloatResponse fromJson(JsonObject data) {
    
        
        final double float_value;
        final float$raw = data["float"];
        float_value = 
    
        
            
                float$raw as double
            
        
    
;
    
    return GetFloatResponse(
    
        
        float: float_value,
    
    );
    }
    GetFloatResponse updateWithJson(JsonObject data) {
    
        
        final double float_value;
        if (data.containsKey('float')) {
            final float$raw = data["float"];
            float_value = 
    
        
            
                float$raw as double
            
        
    
;
        } else {
            float_value = float;
        }
    
    return GetFloatResponse(
    
        
        float: float_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetFloatResponse &&
    
        
    
        other.float == float
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        float.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'float':
            
                
    
        
            this.float
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetFloat extends Requestable {
    

    RequestGetFloat(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetFloat {
  float
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetFloat'
        );
    }
}

