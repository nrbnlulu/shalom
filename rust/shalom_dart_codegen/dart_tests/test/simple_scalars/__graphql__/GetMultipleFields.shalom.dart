
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetMultipleFields{

    /// class members
    
        
            final String id;
        
    
        
            final int intField;
        
    
    // keywordargs constructor
    GetMultipleFields({
    required
        this.id,
    required
        this.intField,
    
    });
    static GetMultipleFields fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final int intField_value = data['intField'];
        
    
    return GetMultipleFields(
    
        
        id: id_value,
    
        
        intField: intField_value,
    
    );
    }
    GetMultipleFields updateWithJson(JsonObject data) {
    
        
            final String id_value;
            if (data.containsKey('id')) {
            id_value = data['id'];
            } else {
            id_value = id;
            }
        
    
        
            final int intField_value;
            if (data.containsKey('intField')) {
            intField_value = data['intField'];
            } else {
            intField_value = intField;
            }
        
    
    return GetMultipleFields(
    
        
        id: id_value,
    
        
        intField: intField_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetMultipleFields &&
    
        other.id == id &&
    
        other.intField == intField 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            intField,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                id
            
        ,
    
        
        'intField':
            
                intField
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetMultipleFields extends Requestable {
    final GetMultipleFields operation;
    final GetMultipleFieldsVariables variables;

    RequestGetMultipleFields({
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
            StringopName: "GetMultipleFields"
        );
    }
}


class GetMultipleFieldsVariables {
    

    GetMultipleFieldsVariables(
        
    );

    JsonObject toJson() {
        return {
              
        };
    } 
}


