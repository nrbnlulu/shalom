
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetInt{

    /// class members
    
        
            final int intField;
        
    
    // keywordargs constructor
    GetInt({
    required
        this.intField,
    
    });
    static GetInt fromJson(JsonObject data) {
    
        
            final int intField_value = data['intField'];
        
    
    return GetInt(
    
        
        intField: intField_value,
    
    );
    }
    GetInt updateWithJson(JsonObject data) {
    
        
            final int intField_value;
            if (data.containsKey('intField')) {
            intField_value = data['intField'];
            } else {
            intField_value = intField;
            }
        
    
    return GetInt(
    
        
        intField: intField_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetInt &&
    
        other.intField == intField 
    
    );
    }
    @override
    int get hashCode =>
    
        intField.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intField':
            
                intField
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetInt extends Requestable {
    final GetInt operation;
    final GetIntVariables variables;

    RequestGetInt({
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
            StringopName: "GetInt"
        );
    }
}


class GetIntVariables {
    

    GetIntVariables(
        
    );

    JsonObject toJson() {
        return {
              
        };
    } 
}


