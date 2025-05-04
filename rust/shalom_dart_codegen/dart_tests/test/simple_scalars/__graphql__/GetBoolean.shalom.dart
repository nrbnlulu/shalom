
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetBoolean{

    /// class members
    
        
            final bool boolean;
        
    
    // keywordargs constructor
    GetBoolean({
    required
        this.boolean,
    
    });
    static GetBoolean fromJson(JsonObject data) {
    
        
            final bool boolean_value = data['boolean'];
        
    
    return GetBoolean(
    
        
        boolean: boolean_value,
    
    );
    }
    GetBoolean updateWithJson(JsonObject data) {
    
        
            final bool boolean_value;
            if (data.containsKey('boolean')) {
            boolean_value = data['boolean'];
            } else {
            boolean_value = boolean;
            }
        
    
    return GetBoolean(
    
        
        boolean: boolean_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBoolean &&
    
        other.boolean == boolean 
    
    );
    }
    @override
    int get hashCode =>
    
        boolean.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'boolean':
            
                boolean
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBoolean extends Requestable {
    final GetBoolean operation;
    final GetBooleanVariables variables;

    RequestGetBoolean({
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
            StringopName: "GetBoolean"
        );
    }
}


class GetBooleanVariables {
    

    GetBooleanVariables(
        
    );

    JsonObject toJson() {
        return {
              
        };
    } 
}


