
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetFloatOptional{

    /// class members
    
        
            final double? floatOptional;
        
    
    // keywordargs constructor
    GetFloatOptional({
    
        this.floatOptional,
    
    });
    static GetFloatOptional fromJson(JsonObject data) {
    
        
            final double? floatOptional_value = data['floatOptional'];
        
    
    return GetFloatOptional(
    
        
        floatOptional: floatOptional_value,
    
    );
    }
    GetFloatOptional updateWithJson(JsonObject data) {
    
        
            final double? floatOptional_value;
            if (data.containsKey('floatOptional')) {
            floatOptional_value = data['floatOptional'];
            } else {
            floatOptional_value = floatOptional;
            }
        
    
    return GetFloatOptional(
    
        
        floatOptional: floatOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetFloatOptional &&
    
        other.floatOptional == floatOptional 
    
    );
    }
    @override
    int get hashCode =>
    
        floatOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'floatOptional':
            
                floatOptional
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
    final GetFloatOptional operation;
    final GetFloatOptionalVariables variables;

    RequestGetFloatOptional({
        required this.operation,  
        required this.variables,
    });

    Request toRequest() {
        final jsonEncoder = JsonEncoder();
        String queryString = jsonEncoder.convert(operation.toJson()); 
        return Request(
            query: queryString, 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: "GetFloatOptional"
        );
    }
}


class GetFloatOptionalVariables {
    

    GetFloatOptionalVariables(
        
    );

    JsonObject toJson() {
        return {
              
        };
    } 
}


