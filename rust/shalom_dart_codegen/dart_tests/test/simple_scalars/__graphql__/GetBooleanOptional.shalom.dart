
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetBooleanOptional{

    /// class members
    
        
            final bool? booleanOptional;
        
    
    // keywordargs constructor
    GetBooleanOptional({
    
        this.booleanOptional,
    
    });
    static GetBooleanOptional fromJson(JsonObject data) {
    
        
            final bool? booleanOptional_value = data['booleanOptional'];
        
    
    return GetBooleanOptional(
    
        
        booleanOptional: booleanOptional_value,
    
    );
    }
    GetBooleanOptional updateWithJson(JsonObject data) {
    
        
            final bool? booleanOptional_value;
            if (data.containsKey('booleanOptional')) {
            booleanOptional_value = data['booleanOptional'];
            } else {
            booleanOptional_value = booleanOptional;
            }
        
    
    return GetBooleanOptional(
    
        
        booleanOptional: booleanOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanOptional &&
    
        other.booleanOptional == booleanOptional 
    
    );
    }
    @override
    int get hashCode =>
    
        booleanOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'booleanOptional':
            
                booleanOptional
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBooleanOptional extends Requestable {
    final GetBooleanOptional operation;
    final GetBooleanOptionalVariables variables;

    RequestGetBooleanOptional({
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
            StringopName: "GetBooleanOptional"
        );
    }
}


class GetBooleanOptionalVariables {
    

    GetBooleanOptionalVariables(
        
    );

    JsonObject toJson() {
        return {
              
        };
    } 
}


