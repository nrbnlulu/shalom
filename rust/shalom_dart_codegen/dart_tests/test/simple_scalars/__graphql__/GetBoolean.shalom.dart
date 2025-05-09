
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetBooleanResponse{

    /// class members
    
        
            final bool boolean;
        
    
    // keywordargs constructor
    GetBooleanResponse({
    required
        this.boolean,
    
    });
    static GetBooleanResponse fromJson(JsonObject data) {
    
        
            final bool boolean_value = data['boolean'];
        
    
    return GetBooleanResponse(
    
        
        boolean: boolean_value,
    
    );
    }
    GetBooleanResponse updateWithJson(JsonObject data) {
    
        
            final bool boolean_value;
            if (data.containsKey('boolean')) {
            boolean_value = data['boolean'];
            } else {
            boolean_value = boolean;
            }
        
    
    return GetBooleanResponse(
    
        
        boolean: boolean_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanResponse &&
    
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
    

    RequestGetBoolean(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetBoolean {
  boolean
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetBoolean'
        );
    }
}

