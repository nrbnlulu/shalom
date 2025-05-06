
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetStringResponse{

    /// class members
    
        
            final String string;
        
    
    // keywordargs constructor
    GetStringResponse({
    required
        this.string,
    
    });
    static GetStringResponse fromJson(JsonObject data) {
    
        
            final String string_value = data['string'];
        
    
    return GetStringResponse(
    
        
        string: string_value,
    
    );
    }
    GetStringResponse updateWithJson(JsonObject data) {
    
        
            final String string_value;
            if (data.containsKey('string')) {
            string_value = data['string'];
            } else {
            string_value = string;
            }
        
    
    return GetStringResponse(
    
        
        string: string_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetStringResponse &&
    
        other.string == string 
    
    );
    }
    @override
    int get hashCode =>
    
        string.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'string':
            
                string
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetString extends Requestable {
    final GetStringVariables variables;

    RequestGetString({
        required this.variables,
    });

    @override
    Request toRequest() {
        return Request(
            query: , 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: 'GetString'
        );
    }
}


class GetStringVariables {
    

    GetStringVariables(
        
    );

    JsonObject toTypes() {
        return {
              
        };
    }  

    JsonObject toJson() {
        return {
              
        };
    } 
}
